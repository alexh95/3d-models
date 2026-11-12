# Riser for the Dell U3421WE: design notes and handoff

Everything decided, measured and learned so far, so the work can continue
from the repository alone. Last updated 2026-11-12.

**Status:** the monitor's base outline is confirmed, the seat it sits in has
been test-printed once and revised, and the way to split a module into
printable parts is chosen (option A, two halves). The riser itself is not
designed yet.

## 1. What is being built

A 3D-printed riser that sits under the stand of a Dell U3421WE monitor.
Requirements, from the original brief:

- Same footprint as the monitor's base plate.
- Variable height.
- Not wasteful with material, but sturdy enough to carry the monitor and itself.
- Stackable modules.
- The top module holds the monitor base neatly in place.
- A drawer that goes in as deep as possible. The drawer follows the outline
  of the base plate; handles may stick out.
- Something useful in the two side wedges. Swivelling pie-shaped drawers were
  suggested; other ideas are wanted too.
- The files must be easy to open and review in a 3D editor (OpenSCAD).

Printers: Bambu Lab P1S and P1P, 256 x 256 x 256 mm.

## 2. How the owner wants to work

These came up during the session and should carry over:

- **Confirm before designing.** Agree the outline, then the interface, then
  the concept, each with a drawing or model, before building the next thing.
- **Test for real, cheaply.** Print a small test piece for each new interface
  before committing to a large part.
- **Single self-contained `.scad` files.** Files get downloaded one at a time
  and opened in OpenSCAD 2021.01 on Windows. A file that pulls in another
  file showed an empty preview, so every `.scad` here stands alone.
- **Footprint-independent process.** The method should be reusable for other
  monitors, not hard-wired to this one. See section 9. Not built yet.
- Colleagues are interested in the riser, and three earlier versions were
  made by hand. A web "riser designer" is planned to show it off (section 10).

## 3. The monitor's base, as measured

### Outline (confirmed)

Traced from the top view in Dell's "U3421WE Outline Dimension" drawing and
scaled to Dell's published stand size of 357.5 x 235 mm. The owner checked
it against the real plate: "Your calculations are correct. This is the
outline." The first fit-test ring also lined up with the silver plate edge
all the way round.

Shape: a fan or keystone. Straight sides that converge toward the front, a
rear edge that bows out toward the wall, a front edge that is hollow.

| Parameter (as in the `.scad` files) | Value, mm |
|---|---|
| `plate_rear_w`, width across the rear corners before rounding | 360.56 |
| `plate_front_w`, width across the front corners before rounding | 247.0 |
| `plate_depth`, rear arc apex to front corners before rounding | 235.75 |
| `plate_rear_arc_r`, rear edge radius (bows out) | 640 |
| `plate_front_arc_r`, front edge radius (hollow) | 490 |
| `plate_rear_corner_r` | 7 |
| `plate_front_corner_r` | 3.5 |

Derived: overall 357.4 x 235.0 after corner rounding; rear edge bows out
about 25.9; front edge is hollow by about 15.8; depth on the centre line is
about 220; each side is about 15 degrees from square; area about 674 cm2.

Coordinates used everywhere: X = left/right, +Y = toward the wall (rear),
Z = up. The two front corners sit on Y = 0 and the plate is centred on X = 0.

Accuracy: one pixel of the screenshot was 1.2 mm, so the traced values
(everything except 357.5 and 235) are good to about 2 mm. Corner radii were
estimated separately, by measuring how far the rounded corner sits inside
the sharp one, and are the least certain.

### Underside (from the owner's photo and measurements)

The photo is not in the repository. What it shows:

- A silver top plate that overhangs a black lower body all the way round.
- The black body is a rim roughly 25 to 30 mm wide around a recessed,
  stamped steel plate with ribs and a central round hub (stand lock).
- Four rubber feet near the corners. One round foot is clearly visible near
  the rear-left corner, about 20 mm across and about 20 mm in from each
  edge. There is also a black rectangular pad at the rear centre and a small
  semicircular feature at the front centre.
- The owner said to ignore the feet and work from the inner outline only.

Measurements:

- **Overhang** of the silver plate past the black body: first estimated at
  about 2 mm. The first fit test showed it is about **1.2 mm**: a lip whose
  inside face was 1.2 inside the plate edge touched the black body with no
  play.
- **Height of the black body** below the overhang: about six credit cards,
  so about 4.56 mm. Probably a little more, since a 3.8 mm lip left an air
  gap that looked too big.

## 4. The seat

The monitor's black lower body drops into a shallow pocket on top of the
riser. A lip surrounds it.

Current version (second), all set by the owner after the first test:

| Parameter | Value, mm |
|---|---|
| `seat_lip_inner_inset`, inside face of the lip, inward from the silver plate edge | 0.2 |
| `seat_lip_w`, lip thickness | 1.8 |
| Outside face of the lip, outside the silver plate edge | 1.6 |
| `seat_lip_h`, lip height above the pocket floor | 4.2 |
| `seat_fillet_r`, round-over on the top inside edge and cove at the foot | 0.6 |
| Side play of the black body in the pocket | about 1.0 each side |

Consequence: the riser body is 1.6 mm larger than the silver plate all
round, about 360.6 x 238.2 mm overall.

The cove takes up 0.6 of the 1.0 mm play at floor level, so the body should
centre itself on the coves. That is the seating effect the owner asked for.

See `docs/seat-section.png` and `interface_check.scad`.

### Fit-test history

| Ring | Seat | Result |
|---|---|---|
| 1 | Lip 1.2 thick, 3.8 tall, inside face 1.2 inside the plate edge, outside face flush with it, 0.4 bevel | Printed on the P1P. Halves press together nicely at the dovetails (0.2 gap). Base drops in. Silver edges line up. No side play. Air gap under the plate "perhaps too big". |
| 2 | Lip 1.8 thick, 4.2 tall, inside face 0.2 inside the plate edge, 0.6 fillets | Exported, in `stl/`. **Result not reported yet.** |

The ring is the lip on a 10 mm band, 1.2 thick, with wider patches at the
corners for the feet, split on the centre line and joined by a dovetail at
the front and rear. About 17 g per half, one half per plate.

## 5. Decisions

| Date | Decision | Who |
|---|---|---|
| 2026-11-12 | Outline as in section 3 is correct. | Owner, after checking |
| 2026-11-12 | Seat is a lip around the black lower body; ignore the rubber feet. | Owner |
| 2026-11-12 | Seat dimensions as in section 4 (second version). | Owner |
| 2026-11-12 | Test pieces before large prints. | Owner |
| 2026-11-12 | **Split: option A, two mirrored halves** with the seam on the centre line. | Owner |

Recommended but not explicitly confirmed:

- Top interface built into the module (lip and shelf on the walls), with no
  separate deck plate. A drop-in deck stays possible as an option.
- Printed dovetails for the seam, with glue optional.

## 6. Option A in more detail

From the block model in `split_concepts.scad` (concept A). All of it is
placeholder geometry to be designed properly.

- **Module** = an open-topped tray in two mirrored halves: floor, rear wall,
  two drawer-bay walls, corner pieces. Prints floor-down with no supports,
  one half per plate. Each half is about 187 x 238 mm.
- **Top:** the lip (section 4) stands on the walls. Below it a shelf about
  5 mm wide carries the monitor's black body, or the next module. In the
  real design the shelf needs a 45 degree underside so it prints unsupported.
- **Bottom:** the lowest few millimetres are stepped in so they drop inside
  the lip of the module below. In the block model: stepped-in outline is the
  lip's inside face plus a 0.3 gap; stepped-in height is the lip height plus
  0.4. The step needs a 45 degree chamfer in the real design.
- **Stacking** ties the two halves together, because the stepped bottom of
  the upper module sits inside the lip of the lower one across the seam. The
  seam joint mainly has to align the halves.
- **Seam joint** in the block model: a flat dovetail in the floor at the
  front and a full-height dovetail on a thick block at the rear wall.
- **Drawer bay:** block model uses a half-width of 118 mm to the outside of
  the bay walls. The drawer prints in one piece, so its width is limited by
  the bed to roughly 236 to 240 mm.
- **Wedges:** the outside wall is left open along each side between about
  Y = 30 and Y = 180, so a wedge insert can be reached or swung out there.
  The front and rear corners keep a wrap of wall and lip.
- **Monitor support without a deck:** the black body rests on the shelf and
  the wall tops, and the rubber feet hang free. **Not yet checked** that the
  feet clear whatever is underneath them (rear feet are over the wedge
  corners, front feet over the front of the drawer bay).

Measured from the block models, 60 mm module, PLA. These run heavy (solid
floor, no lightening) and nothing has been sliced:

| Part | Size, mm | Weight |
|---|---|---|
| A left half | 187 x 238 x 64 | 174 g |
| A right half | 180 x 238 x 64 | 165 g |
| Drop-in deck, each half (optional) | 185 x 234 x 2 | 83 g |
| Placeholder drawer | 230 x 227 x 57 | 171 g |

`python tools/measure_parts.py` reproduces these.

### The options not chosen

- **B, centre piece and two wedge pods.** 387 g against 339 g for A (+14 %),
  three parts, two plates. Lets wedge inserts be swapped without reprinting
  half a module. Drawbacks: visible seams on the front face, the lip is
  interrupted at four places, the monitor's rear feet load goes through the
  pod joints, and the centre piece is 246 mm wide with its rails, which is
  right at the bed limit.
- **C, two closed halves printed standing on their front ends.** 499 g. The
  only way found to print a full built-in deck. Needs a brim and supports
  under the hollow front edges, and is a 238 mm tall print on thin edges.
- **A built-in deck printed flat** does not work: right way up it would
  bridge the whole drawer bay; upside down the pocket needs support
  everywhere.

### Seam joints compared

Modelled in `joint_concepts.scad` on a 40 mm tall sample. Weight is what the
joint adds to a pair.

| Joint | To buy | Comes apart | Adds | Notes |
|---|---|---|---|---|
| Printed dovetails | nothing | yes | 13 g | Floor version proven on the fit-test ring |
| Dowels and glue | 6 mm dowels or printed, glue | no | 12 g | Needs thick blocks for the holes |
| Screws | M3 screws, threaded inserts | yes | 13 g | Strongest, pulls the seam tight |
| Loose keys | nothing | yes | 9 g | Both parts stay mirror images |
| Tongue and groove, glued | glue | no | 5 g | Lightest, relies on the glue |

## 7. Ideas not yet designed

Collected during the session. None of these is decided.

**Main drawer**

- Front panel covers the bay opening and follows the outline's front edge, so
  it is flush with the body. The front edge is hollow, so the panel is curved.
- Handle options: a bridged D-pull, a lip, or a finger notch.
- A stop so the drawer cannot be pulled right out: a springy tongue cut into
  the drawer's side wall near the back, standing up from the bottom so it
  prints unsupported, with a bump that runs in a groove in the bay wall. The
  groove ends before the front. Squeeze the tongue to remove the drawer.
- A small bump and dimple to hold it closed.
- The drawer's rear can follow the bowed rear wall to use the full depth.
- Owner wants **variants for drawer front attachments**.

**Wedges**

- Swivelling pie-shaped drawer. Pivot near the narrow front end, swinging
  out through the open side. The part of the drawer in front of the pivot
  must stay within a small radius or it hits the bay wall, so the pivot sits
  about 6 to 7 mm from that wall with a round hub. A short lug on the hub
  can act as the open stop. A finger tab on the outside face to grab.
- Open cubby reached from the side.
- Cable garage open to the rear, with tie-down points.
- Slotted inserts for pens, SD cards, USB sticks.
- Swing-out tray for a phone or cup.
- Hidden compartment held by magnets.

**Module**

- Lighten the floor with cut-outs between the strips the drawer runs on.
- Recesses in the bottom for stick-on rubber feet on the lowest module.
- Optional drop-in deck plate. It needs the lip 2 mm taller.

## 8. Open questions and risks

- Result of fit-test ring 2 is unknown.
- True height of the black body, and so the real air gap above the lip.
- Positions and height of the four rubber feet, and whether they hang clear
  in the no-deck design.
- The P1 bed is believed to have a small no-print corner at the front left
  (about 18 x 28 mm). Check in Bambu Studio before relying on parts wider
  than about 236 mm.
- All weights come from block models. Nothing has been sliced, and print
  times quoted in conversation (roughly 30 g per hour) were estimates.
- Large flat floors fill most of the plate, so corner warping is the main
  print risk, more so in PETG than PLA.
- Stacking has not been test-printed. Two short rings would check it.
- Joints other than the floor dovetail have not been printed.

## 9. Footprint-independent process (proposed, not built)

- One generic model that works only from an outline and a few measurements,
  using offsets and intersections, so nothing assumes this monitor's shape.
  Bed size is a parameter.
- One small profile per monitor: the outline as a list of points, plus the
  seat numbers (overhang, lower-body height, where the feet are).
- The same steps for every monitor: trace the outline from a drawing or
  photo; check it with a 1:1 paper template; print the fit-test ring and
  adjust the seat; print a stacking test; generate the riser parts.
- A build step that writes one self-contained `.scad` and the STLs per
  monitor, so single-file downloads keep working.

At present the Dell outline is written into each `.scad` file separately,
and the seam and corner details use Dell-specific helper functions
(`plate_front_y`, `plate_rear_y`, `plate_rear_corner_y`).

## 10. Planned next

From the owner:

1. **Build the full design** on option A, with variants for drawer front
   attachments and for what goes in the wedges.
2. **A "riser designer" website** on the owner's local Apollo stack: pick
   modules of different heights with different wedges, to show colleagues.

Suggestions for the website, not decisions:

- Keep one parameter description (module list with height, wedge type per
  side, drawer front type) as the contract between the model and the site,
  so the site and the `.scad` cannot drift apart.
- Two ways to show the model in a browser: run the same OpenSCAD source in
  the browser (a WebAssembly build of OpenSCAD exists), or re-implement the
  geometry in a JavaScript CAD or mesh library and draw it with a 3D viewer.
  The first keeps a single source of truth but previews are slower.
- The `render()` calls in `split_concepts.scad` make previews take up to
  half a minute in OpenSCAD 2021.01; a site will want lighter geometry or
  pre-generated meshes per option.

## 11. Files and how to regenerate things

| File | What it is |
|---|---|
| `interface_check.scad` | The Dell base as measured, the seat, and the fit-test ring |
| `split_concepts.scad` | Block models of split options A, B, C |
| `joint_concepts.scad` | Samples of five seam joints |
| `stl/fit_test_left.stl`, `stl/fit_test_right.stl` | Fit-test ring 2 |
| `docs/outline-u3421we.png`, `.svg` | Dimensioned outline |
| `docs/outline-u3421we-1to1-A4.pdf` | 1:1 paper template, two A4 pages |
| `docs/seat-section.png`, `.svg` | Seat cross-section |
| `docs/concepts-exploded.png`, `docs/concepts-print-plates.png` | Split options |
| `docs/joint-concepts.png` | Seam joints |
| `tools/trace_dell_outline.py` | How the outline was traced from Dell's drawing |
| `tools/outline_drawings.py`, `tools/seat_drawing.py`, `tools/render_docs.js` | Regenerate the drawings and the template |
| `tools/measure_parts.py` | Export parts and report size and weight |

Commands used (OpenSCAD 2021.01 command line):

```bash
openscad -o stl/fit_test_left.stl --export-format binstl -D 'view="fit test: left half"' interface_check.scad
```

```bash
openscad -o stl/fit_test_right.stl --export-format binstl -D 'view="fit test: right half"' interface_check.scad
```

```bash
openscad -o preview.png --imgsize=1400,820 --projection=ortho --camera=0,60,10,52,0,24,1150 -D 'concept="A"' -D 'view="exploded"' split_concepts.scad
```

Notes:

- Each fit-test half takes about a minute and a half to export, because the
  two fillets are built from 0.1 mm slices. The concept parts take seconds.
- PNG export needs a display; on a headless Linux machine prefix the command
  with `xvfb-run -a`.
- The Python tools need `numpy`, `pillow`, `shapely` and `numpy-stl`.
  `render_docs.js` needs Playwright with Chromium.
- `outline_drawings.py` and `seat_drawing.py` have their own copies of the
  numbers; keep them in step with the `.scad` files.
