#!/usr/bin/env python3
"""Build, check and export the riser's parts from riser.scad.

  python tools/riser_build.py check      bed fit, overlaps, overhangs, the straight-middle rule
  python tools/riser_build.py stl        the ready-made set and the test pieces, into stl/
  python tools/riser_build.py slice      slice the parts with Bambu Studio; weights and times
                                         go to tools/sliced.json
  python tools/riser_build.py web        the website bundle, into web/
  python tools/riser_build.py pictures   the pictures in docs/

Give --openscad PATH, or set OPENSCAD, if OpenSCAD is not found. It has to be a build with
the Manifold backend (2025 or later). `slice` needs Bambu Studio (BAMBU_STUDIO names its
folder). No Python packages are needed.
"""
import argparse
import datetime
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SCAD = ROOT / "riser.scad"
RING_SCAD = ROOT / "interface_check.scad"
SLICED = HERE / "sliced.json"
PLA = 1.24          # g/cm3, the density the estimates are given for
BED = 256           # mm
BED_Z = 250
RATE_G_PER_H = 33   # what the P1P really does in PLA at 0.20 mm, from its job history

REF_H = 60
REF_PLATE_H = 8
HEIGHTS = [30, 60, 120]
PLATE_HEIGHTS = [7, 8, 20]
# Coarser meshes for the website: fewer points on the outline, taller steps
WEB = {"_arc_steps": 24, "_fn": 20, "_dz": 0.7}

# bundle id, part in riser.scad, parameters, colour slot, the options it belongs to
MODULE_PARTS = [
    ("body_left", "body_left", {}, "body", {}),
    ("body_right", "body_right", {}, "body", {}),
    ("drawer_scoop", "drawer", {"drawer_front": "scoop"}, "drawer", {"front": "scoop"}),
    ("drawer_plain", "drawer", {"drawer_front": "plain"}, "drawer", {"front": "plain"}),
    ("wedge_swivel_l", "wedge_left", {}, "wedges", {"wedge_l": "swivel"}),
    ("wedge_swivel_r", "wedge_right", {}, "wedges", {"wedge_r": "swivel"}),
]
PLATE_PARTS = [
    ("plate_left", "plate_left", {}, "body", {}),
    ("plate_right", "plate_right", {}, "body", {}),
]
# test piece, module height it is exported at
TESTS = [
    ("test_step_left", 60), ("test_step_right", 60),
    ("test_hub_body", 30), ("test_hub_drawer", 30),
    ("test_front_left", 30), ("test_front_right", 30), ("test_front_drawer", 30),
    ("test_stop_body", 30), ("test_stop_drawer", 30),
    ("test_seam_left", 40), ("test_seam_right", 40),
]
# Names that must carry the same value in every .scad file that has them
SHARED = ["plate_rear_w", "plate_front_w", "plate_depth", "plate_rear_arc_r", "plate_front_arc_r",
          "plate_rear_corner_r", "plate_front_corner_r", "seat_lip_inner_inset", "seat_lip_w",
          "seat_lip_h", "seat_fillet_r", "stack_gap", "ledge_w", "wall", "floor_t", "bay_half",
          "dell_overhang", "dell_black_h"]

OPENSCAD = None


def find_openscad(given):
    names = [given, os.environ.get("OPENSCAD"), shutil.which("openscad"),
             r"C:\Program Files\OpenSCAD (Nightly)\openscad.com", r"C:\Program Files\OpenSCAD\openscad.com"]
    for name in names:
        if name and Path(name).exists():
            return str(name)
    sys.exit("riser_build: OpenSCAD not found; give --openscad PATH")


def define(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, str):
        return '"%s"' % value
    return repr(value)


def openscad(out, defs, extra=(), scad=None):
    """Runs OpenSCAD. Returns the numbers the file echoes, or None if it drew nothing."""
    out = Path(out)
    if out.exists():
        out.unlink()
    cmd = [OPENSCAD, "--backend=manifold", "-o", str(out), *extra]
    if out.suffix == ".stl":
        cmd += ["--export-format", "binstl"]
    for key, value in defs.items():
        cmd += ["-D", "%s=%s" % (key, define(value))]
    run = subprocess.run(cmd + [str(scad or SCAD)], capture_output=True, text=True)
    said = run.stdout + run.stderr    # echo goes to either, depending on the build
    for line in said.splitlines():
        if "WARNING" in line or "ERROR" in line:
            if "empty" not in line.lower():
                print("   openscad: " + line.strip())
    if not out.exists():
        return None
    return {m.group(1): float(m.group(2)) for m in re.finditer(r'NUM (\w+) ([-\d.e]+)', said)}


class Mesh:
    def __init__(self, path):
        data = Path(path).read_bytes()
        count = struct.unpack_from("<I", data, 80)[0]
        self.tris = [(t[3:6], t[6:9], t[9:12]) for t in struct.iter_unpack("<12fH", data[84:84 + 50 * count])]
        self.size = len(data)

    def volume(self):
        total = 0.0
        for a, b, c in self.tris:
            total += (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0])
                      + a[2] * (b[0] * c[1] - b[1] * c[0]))
        return total / 6.0

    def box(self):
        lo = [min(p[i] for t in self.tris for p in t) for i in range(3)]
        hi = [max(p[i] for t in self.tris for p in t) for i in range(3)]
        return lo, hi

    def points(self, places=2):
        return {(round(p[0], places), round(p[1], places), round(p[2], places)) for t in self.tris for p in t}

    def levels(self):
        return sorted({round(p[2], 3) for t in self.tris for p in t})


def export(part, defs, folder, name=None):
    out = Path(folder) / ((name or part) + ".stl")
    nums = openscad(out, {**defs, "part": part})
    if nums is None:
        sys.exit("riser_build: %s came out empty" % part)
    return Mesh(out), nums, out


# ------------------------------------------------------------------ check

def shared_values():
    problems = []
    values = {}
    for path in sorted(ROOT.glob("*.scad")):
        text = path.read_text(encoding="utf-8")
        for name in SHARED:
            found = re.search(r"^%s\s*=\s*([-\d.]+)\s*;" % name, text, re.M)
            if found:
                values.setdefault(name, {})[path.name] = float(found.group(1))
    for name, per_file in values.items():
        if len(set(per_file.values())) > 1:
            problems.append("%s differs: %s" % (name, per_file))
    return problems


def overlap(tmp, check, fraction, height):
    out = Path(tmp) / "overlap.stl"
    nums = openscad(out, {"_check": check, "_f": fraction, "module_h": height,
                          "wedge_detent_h": 0, "detent_h": 0})
    return 0.0 if nums is None else abs(Mesh(out).volume())


def overhang_patches(tmp, part, defs):
    """Flat undersides wider than 0.7 mm, as (z, x size, y size) of each patch."""
    out = Path(tmp) / "overhang.stl"
    if openscad(out, {**defs, "part": part, "_overhang": True}) is None:
        return []
    groups = {}
    for tri in Mesh(out).tris:
        z = round(min(p[2] for p in tri), 2)
        key = (z, round(sum(p[0] for p in tri) / 3 / 30), round(sum(p[1] for p in tri) / 3 / 30))
        box = groups.setdefault(key, [1e9, -1e9, 1e9, -1e9])
        for p in tri:
            box[0] = min(box[0], p[0]); box[1] = max(box[1], p[0])
            box[2] = min(box[2], p[1]); box[3] = max(box[3], p[1])
    seen = {}
    for (z, _, _), box in groups.items():
        size = (round(box[1] - box[0] + 0.7, 1), round(box[3] - box[2] + 0.7, 1))
        seen[(round(z, 1), size)] = True
    return sorted(seen)


def stretch_band(tmp, part, defs, key, ref):
    """Where a part is straight: (reference mesh, z0, z1). Found by exporting it 10 mm taller
    and seeing which levels moved."""
    mesh, nums, _ = export(part, {**defs, **WEB, key: ref}, tmp, "ref")
    taller, _, _ = export(part, {**defs, **WEB, key: ref + 10}, tmp, "taller")
    low, high = mesh.levels(), taller.levels()
    if len(low) != len(high):
        sys.exit("riser_build: %s changes shape with height" % part)
    moved = [abs(b - a - 10) < 0.002 for a, b in zip(low, high)]
    stayed = [abs(b - a) < 0.002 for a, b in zip(low, high)]
    first = moved.index(True)
    if not (all(stayed[:first]) and all(moved[first:])):
        sys.exit("riser_build: %s has no single straight section" % part)
    return mesh, nums, low[first - 1], low[first]


def stretched(mesh, z1, by):
    return {(x, y, round(z + by, 3) if z >= z1 - 0.001 else z) for x, y, z in mesh.points(3)}


def stretched_volume(mesh, z1, by):
    total = 0.0
    for tri in mesh.tris:
        a, b, c = [(p[0], p[1], p[2] + by if p[2] >= z1 - 0.001 else p[2]) for p in tri]
        total += (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0])
                  + a[2] * (b[0] * c[1] - b[1] * c[0]))
    return total / 6.0


def unmatched(points, others, tolerance=0.005):
    """How many of points have no partner in others within the tolerance."""
    buckets = {}
    for p in others:
        buckets.setdefault((round(p[0], 1), round(p[1], 1)), []).append(p)
    count = 0
    for p in points:
        near = [q for dx in (-0.1, 0, 0.1) for dy in (-0.1, 0, 0.1)
                for q in buckets.get((round(p[0] + dx, 1), round(p[1] + dy, 1)), [])]
        if not any(all(abs(p[i] - q[i]) <= tolerance for i in range(3)) for q in near):
            count += 1
    return count


def check_stretch(tmp, part, defs, key, ref, others):
    """A part exported at another height must be the reference mesh with its top moved."""
    problems = []
    notes = []
    mesh, _, z0, z1 = stretch_band(tmp, part, defs, key, ref)
    for height in others:
        other, _, _ = export(part, {**defs, **WEB, key: height}, tmp, "other")
        want = stretched(mesh, z1, height - ref)
        have = other.points(3)
        missing = unmatched(want - have, have)
        extra = unmatched(have - want, want)
        if missing or extra:
            # Where features tied to the top reach down among those tied to the bottom, the
            # slabs split differently and the points differ, though the solid is the same.
            gap = abs(stretched_volume(mesh, z1, height - ref) - other.volume())
            if gap < 1.0 and mesh.box()[0][:2] == other.box()[0][:2]:
                notes.append("%s: same solid, levels interleave" % height)
            else:
                problems.append("%s at %s: %d points missing, %d extra, volume off by %.1f mm3"
                                % (part, height, missing, extra, gap))
    return (z0, z1), problems, notes


def cmd_check(args):
    failed = []
    want = lambda name: args.only in (None, name)
    with tempfile.TemporaryDirectory() as tmp:
        if want("shared"):
            print("Shared numbers in the .scad files")
            problems = shared_values()
            failed += problems
            print("   " + ("; ".join(problems) if problems else "the same everywhere"))

        if want("bed"):
            print("Bed fit (%d x %d mm, %d tall)" % (BED, BED, BED_Z))
            for group, key, tall in [(MODULE_PARTS, "module_h", 200), (PLATE_PARTS, "plate_h", 20)]:
                for ident, part, defs, _, _ in group:
                    mesh, _, _ = export(part, {**defs, **WEB, key: tall}, tmp)
                    lo, hi = mesh.box()
                    size = [hi[i] - lo[i] for i in range(3)]
                    ok = size[0] <= BED and size[1] <= BED and size[2] <= BED_Z
                    print("   %-15s %6.1f x %6.1f x %5.1f at %s = %d  %s" % (
                        ident, size[0], size[1], size[2], key, tall, "ok" if ok else "TOO BIG"))
                    if not ok:
                        failed.append("%s does not fit the bed" % ident)

        if want("overlaps"):
            print("Overlaps between parts (mm3), drawers closed to fully open")
            drawer_f = [0, 0.1, 0.5, 1]
            wedge_f = [0, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
            pairs = [("body|drawer", drawer_f), ("body|wedge", wedge_f), ("drawer|wedge", [0, 1]),
                     ("body|plate+", [0]), ("drawer|plate+", [0, 1]), ("wedge|plate+", [0, 0.5, 1]),
                     ("body|plate-", [0]), ("drawer|plate-", [0, 0.5, 1]), ("wedge|plate-", [0, 0.5, 1]),
                     ("body|body-", [0]), ("drawer|body-", [0, 0.5, 1]), ("wedge|body-", [0, 0.25, 0.5, 0.75, 1]),
                     ("plate|plate-", [0])]
            for height in ([60] if args.quick else [30, 60]):
                for check, fractions in pairs:
                    worst = max(overlap(tmp, check, f, height) for f in fractions)
                    print("   %3d mm  %-14s %s" % (height, check, "none" if worst < 0.05 else "%.2f  OVERLAP" % worst), flush=True)
                    if worst >= 0.05:
                        failed.append("%s overlap at %d mm" % (check, height))

        if want("overhangs"):
            print("Flat undersides wider than 0.7 mm (z, size); short bridges are fine")
            for ident, part, defs, _, _ in MODULE_PARTS + PLATE_PARTS:
                patches = overhang_patches(tmp, part, defs)
                bad = [p for p in patches if min(p[1]) > 5.0 or max(p[1]) > 15.0]
                print("   %-15s %s" % (ident, ", ".join("z %.1f: %.1f x %.1f" % (z, s[0], s[1]) for z, s in patches) or "none"))
                if bad:
                    failed.append("%s needs support: %s" % (ident, bad))

        if want("stretch"):
            print("Straight middle section: other heights against the stretched reference mesh")
            for group, key, ref, others in [(MODULE_PARTS, "module_h", REF_H, [30, 45, 90, 120, 200]),
                                            (PLATE_PARTS, "plate_h", REF_PLATE_H, [7, 12, 20])]:
                for ident, part, defs, _, _ in group:
                    band, problems, notes = check_stretch(tmp, part, defs, key, ref, others)
                    print("   %-15s straight from %.1f to %.1f  %s" % (
                        ident, band[0], band[1], "; ".join(problems + notes) or "ok"), flush=True)
                    failed += problems
    print()
    if failed:
        print("FAILED:")
        for line in failed:
            print("   " + line)
        sys.exit(1)
    print("All checks passed.")


# -------------------------------------------------------------------- stl

def cmd_stl(args):
    sets = [("module_%dmm" % REF_H, MODULE_PARTS, {"module_h": REF_H}),
            ("plate_%dmm" % REF_PLATE_H, PLATE_PARTS, {"plate_h": REF_PLATE_H})]
    for folder, parts, defs in sets:
        target = ROOT / "stl" / folder
        target.mkdir(parents=True, exist_ok=True)
        for ident, part, more, _, _ in parts:
            mesh, _, path = export(part, {**defs, **more}, target, ident)
            lo, hi = mesh.box()
            print("%-34s %6.1f x %6.1f x %5.1f mm  %6.1f cm3" % (
                path.relative_to(ROOT), hi[0] - lo[0], hi[1] - lo[1], hi[2] - lo[2], mesh.volume() / 1000))
    target = ROOT / "stl" / "tests"
    target.mkdir(parents=True, exist_ok=True)
    for part, height in TESTS:
        mesh, _, path = export(part, {"module_h": height}, target)
        lo, hi = mesh.box()
        print("%-34s %6.1f x %6.1f x %5.1f mm  %6.1f cm3" % (
            path.relative_to(ROOT), hi[0] - lo[0], hi[1] - lo[1], hi[2] - lo[2], mesh.volume() / 1000))
    # The seat ring comes from interface_check.scad. The step ring above is tested in it.
    for side in ("left", "right"):
        path = ROOT / "stl" / ("fit_test_%s.stl" % side)
        if openscad(path, {"view": "fit test: %s half" % side}, scad=RING_SCAD) is None:
            sys.exit("riser_build: the fit-test ring came out empty")
        mesh = Mesh(path)
        lo, hi = mesh.box()
        print("%-34s %6.1f x %6.1f x %5.1f mm  %6.1f cm3" % (
            path.relative_to(ROOT), hi[0] - lo[0], hi[1] - lo[1], hi[2] - lo[2], mesh.volume() / 1000))


# ------------------------------------------------------------------ slice

STUDIO = Path(os.environ.get("BAMBU_STUDIO", r"C:\Program Files\Bambu Studio"))
LAYER = 0.2
SLICE_SETUP = {"printer": "Bambu Lab P1P 0.4 nozzle", "process": "0.20mm Standard @BBL P1P",
               "filament": "Generic PLA", "bed": "Textured PEI Plate", "walls": 3, "infill": 15,
               "top_layers": 5}
# The top plate is a slab, and most of its weight is solid layers and infill. Thinner
# infill and one top layer fewer take 40 g off a pair; fewer walls would save only 4 g.
PLATE_SETUP = {**SLICE_SETUP, "infill": 10, "top_layers": 4}


def studio_profile(kind, name):
    """A Bambu Studio profile with everything it inherits merged in."""
    data = json.loads((STUDIO / "resources/profiles/BBL" / kind / (name + ".json")).read_text(encoding="utf-8"))
    merged = studio_profile(kind, data["inherits"]) if data.get("inherits") else {}
    for part in data.pop("include", None) or []:
        merged.update(studio_profile(kind, part))
    merged.update(data)
    merged.pop("inherits", None)
    return merged


def slice_stl(stl, folder, setup=SLICE_SETUP):
    """Slices one STL on its own plate. Returns (grams, minutes)."""
    folder = Path(folder)
    files = {}
    for kind, name, changes in [
            ("machine", setup["printer"], {}),
            # The slicer keeps whichever is more of the layer count and the thickness, so both are set
            ("process", setup["process"], {"wall_loops": str(setup["walls"]),
                                           "sparse_infill_density": "%d%%" % setup["infill"],
                                           "top_shell_layers": str(setup["top_layers"]),
                                           "top_shell_thickness": "%.1f" % (setup["top_layers"] * LAYER)}),
            ("filament", setup["filament"], {})]:
        files[kind] = folder / (kind + ".json")
        files[kind].write_text(json.dumps({**studio_profile(kind, name), **changes, "name": name,
                                           "from": "system", "type": kind}), encoding="utf-8")
    out = folder / "job.3mf"
    if out.exists():
        out.unlink()
    run = subprocess.run([str(STUDIO / "bambu-studio.exe"), "--slice", "0",
                          "--load-settings", "%s;%s" % (files["machine"], files["process"]),
                          "--load-filaments", str(files["filament"]), "--curr-bed-type", setup["bed"],
                          "--arrange", "1", "--orient", "0", "--export-3mf", out.name,
                          "--outputdir", str(folder), str(Path(stl).resolve())],
                         cwd=folder, capture_output=True, text=True, timeout=900)
    if run.returncode or not out.exists():
        return None
    with zipfile.ZipFile(out) as job:
        plate = ET.fromstring(job.read("Metadata/slice_info.config")).find("plate")
    meta = {m.get("key"): m.get("value") for m in plate.findall("metadata")}
    if meta.get("outside") != "false":
        return None
    return round(float(meta["weight"]), 1), round(float(meta["prediction"]) / 60)


def cmd_slice(args):
    result = {"setup": SLICE_SETUP, "plate_setup": PLATE_SETUP,
              "sliced_on": datetime.date.today().isoformat(), "parts": {}}
    with tempfile.TemporaryDirectory() as tmp:
        jobs = ([(p, "module_h", HEIGHTS, SLICE_SETUP) for p in MODULE_PARTS]
                + [(p, "plate_h", PLATE_HEIGHTS, PLATE_SETUP) for p in PLATE_PARTS])
        for (ident, part, defs, _, _), key, heights, setup in jobs:
            for height in heights:
                _, _, stl = export(part, {**defs, key: height}, tmp, ident)
                numbers = slice_stl(stl, tmp, setup)
                if numbers is None:
                    print("%-15s %3s mm  slicing failed" % (ident, height))
                    continue
                result["parts"].setdefault(ident, {})[str(height)] = {"grams": numbers[0], "minutes": numbers[1]}
                print("%-15s %3s mm  %6.1f g  %dh%02d" % (ident, height, numbers[0], numbers[1] // 60, numbers[1] % 60), flush=True)
    SLICED.write_text(json.dumps(result, indent=1) + "\n", encoding="utf-8")
    print("Wrote %s" % SLICED.relative_to(ROOT))


# -------------------------------------------------------------------- web

def customizer(name):
    """A parameter's default and the choices or range in its Customizer comment."""
    text = SCAD.read_text(encoding="utf-8")
    found = re.search(r'^%s\s*=\s*("?)([^";]+)\1\s*;\s*//\s*\[([^\]]+)\]' % name, text, re.M)
    if not found:
        sys.exit("riser_build: no Customizer line for %s" % name)
    default, inside = found.group(2), found.group(3)
    if found.group(1):
        return default, [v.strip() for v in inside.split(",")]
    low, step, high = (float(v) for v in inside.split(":"))
    return float(default), (low, step, high)


def tidy(number):
    return int(number) if float(number).is_integer() else number


def estimate(tmp, ident, part, defs, key, heights, fill):
    """Grams and minutes at each height: sliced if tools/sliced.json has them, else from volume."""
    sliced = json.loads(SLICED.read_text(encoding="utf-8"))["parts"].get(ident, {}) if SLICED.exists() else {}
    if all(str(h) in sliced for h in heights):
        return {"h": heights, "grams": [sliced[str(h)]["grams"] for h in heights],
                "minutes": [sliced[str(h)]["minutes"] for h in heights], "source": "sliced"}
    grams = []
    for height in heights:
        mesh, _, _ = export(part, {**defs, **WEB, key: height}, tmp, "est")
        grams.append(round(mesh.volume() / 1000 * PLA * fill, 1))
    return {"h": heights, "grams": grams, "minutes": [round(g / RATE_G_PER_H * 60) for g in grams], "source": "volume"}


def cmd_web(args):
    target = ROOT / "web"
    meshes = target / "meshes"
    if meshes.exists():
        shutil.rmtree(meshes)
    meshes.mkdir(parents=True)
    h_default, (h_min, _, h_max) = customizer("module_h")
    p_default, (p_min, _, p_max) = customizer("plate_h")
    front_default, fronts = customizer("drawer_front")
    wedge_default, wedges = customizer("wedge_right")
    parts = []
    with tempfile.TemporaryDirectory() as tmp:
        for kind, group, key, ref, heights, fill in [
                ("module", MODULE_PARTS, "module_h", REF_H, HEIGHTS, 1.0),
                ("plate", PLATE_PARTS, "plate_h", REF_PLATE_H, PLATE_HEIGHTS, 0.45)]:
            for ident, part, defs, slot, when in group:
                mesh, nums, z0, z1 = stretch_band(tmp, part, defs, key, ref)
                shutil.copy(Path(tmp) / "ref.stl", meshes / (ident + ".stl"))
                lo, hi = mesh.box()
                motion = None
                if part == "drawer":
                    motion = {"type": "slide", "dir": [0, -1, 0], "travel": round(nums["drawer_travel"], 1)}
                elif part in ("wedge_left", "wedge_right"):
                    side = 1 if part == "wedge_right" else -1
                    motion = {"type": "swivel",
                              "pivot": [round(side * nums["wedge_pivot_x"], 2), round(nums["wedge_pivot_y"], 2)],
                              "deg": -side * tidy(nums["wedge_swing"])}
                parts.append({
                    "id": ident, "kind": kind, "slot": slot, "when": when,
                    "mesh": "meshes/%s.stl" % ident,
                    "stretch": [{"z0": z0, "z1": z1, "share": 1}],
                    "motion": motion,
                    "bed": [int(hi[0] - lo[0]) + 1, int(hi[1] - lo[1]) + 1],
                    "est": estimate(tmp, ident, part, defs, key, heights, fill),
                })
                print("%-15s %7d triangles %6.0f kB  straight %.1f..%.1f  %s" % (
                    ident, len(mesh.tris), mesh.size / 1024, z0, z1, parts[-1]["est"]["source"]))
        for name in ("dell_black", "dell_plate"):
            export(name, WEB, meshes, name)
        nums = openscad(Path(tmp) / "nums.stl", {"part": "dell_black"})
    # The model and the slicer's numbers both: new estimates are a new revision too
    digest = hashlib.sha256(SCAD.read_bytes() + (SLICED.read_bytes() if SLICED.exists() else b"")).hexdigest()[:8]
    bundle = {
        "bundle": 1,
        "profile": "dell-u3421we",
        "revision": "%s.%s" % (datetime.date.today().isoformat(), digest),
        "density_ref": PLA,
        "kinds": {
            "module": {
                "h": {"min": tidy(h_min), "max": tidy(h_max), "step": 5, "default": tidy(h_default), "ref": REF_H},
                "options": {
                    "front": {"values": fronts, "default": front_default},
                    "wedge_l": {"values": wedges, "default": wedge_default},
                    "wedge_r": {"values": wedges, "default": wedge_default},
                },
                "color_slots": ["body", "drawer", "wedges"],
            },
            "plate": {
                "h": {"min": tidy(p_min), "max": tidy(p_max), "step": 1, "default": tidy(p_default), "ref": REF_PLATE_H},
                "options": {},
                "color_slots": ["body"],
            },
        },
        "parts": parts,
        "seat": {"lip_h": 4.2, "moving_parts_above": nums["plug_h"]},
        "ghost": {"black": "meshes/dell_black.stl", "plate": "meshes/dell_plate.stl",
                  "note": "the monitor's base, with Z = 0 on the pocket floor of the top item"},
    }
    (target / "bundle.json").write_text(json.dumps(bundle, indent=1) + "\n", encoding="utf-8")
    total = sum(f.stat().st_size for f in meshes.iterdir())
    print("Wrote web/bundle.json, revision %s, meshes %.1f MB" % (bundle["revision"], total / 1e6))


# --------------------------------------------------------------- pictures

PICTURES = [
    ("riser-exploded.png", {"view": "exploded"}, "0,105,35,58,0,25,1150"),
    ("riser-open.png", {"view": "open"}, "0,60,20,52,0,20,1250"),
    ("riser-stack.png", {"view": "stack"}, "0,110,70,66,0,28,1000"),
    ("riser-print-plates.png", {"view": "print plates"}, "843,128,0,50,0,0,2900"),
    ("riser-hub.png", {"view": "open", "drawer_front": "plain"}, "132,45,40,35,0,20,170"),
]


def cmd_pictures(args):
    for name, defs, camera in PICTURES:
        out = ROOT / "docs" / name
        openscad(out, defs, ["--render", "--imgsize=1500,950", "--projection=ortho", "--camera=" + camera,
                             "--colorscheme=Tomorrow"])
        print("docs/%s %s" % (name, "written" if out.exists() else "FAILED"))


def main():
    global OPENSCAD
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("command", choices=["check", "stl", "slice", "web", "pictures"])
    parser.add_argument("--openscad")
    parser.add_argument("--quick", action="store_true", help="check: overlaps at 60 mm only")
    parser.add_argument("--only", help="check: one of shared, bed, overlaps, overhangs, stretch")
    args = parser.parse_args()
    OPENSCAD = find_openscad(args.openscad)
    {"check": cmd_check, "stl": cmd_stl, "slice": cmd_slice, "web": cmd_web, "pictures": cmd_pictures}[args.command](args)


if __name__ == "__main__":
    main()
