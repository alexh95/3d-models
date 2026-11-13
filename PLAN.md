# Plan: the riser model, the top plate and the designer site

Written 2026-11-12, reviewed by Alex on 2026-11-13. Section 2 records his
decisions, and work on tracks M and W has started. `u3421we-riser/DESIGN.md`
stays the record of measurements, decisions and test results; this file
says what gets built next, in what order, and what can run at the same
time.

Three tracks:

- **M, the model:** a finished, printable riser module with a parametric
  height, a default drawer pull and a default wedge insert, plus the
  stackable top plate.
- **W, the website:** the "monitor box designer", built on the Odin + htmx
  starter and hosted on apollo under `alexh95.com`.
- **C, cydonia:** the few places where a link to cydonia earns its keep.

## 1. What the survey found

### Printers, read live from cydonia's FABRICATOR (2026-11-12 18:11)

| | 3DP-P1P-1 (P1P) | Alchemist 2 (P1S) | Alchemist 1 (A1 mini) |
|---|---|---|---|
| Build volume, mm | 256 x 256 x 250 | 256 x 256 x 250 | 180 x 180 x 180 |
| Nozzle | 0.4, stainless | 0.4, stainless | 0.2, stainless |
| Filament feed | spool holder, one filament | AMS, 4 trays | spool holder, one filament |
| Loaded now | yellow PLA | black PLA Basic in all 4 trays | white PLA |
| Plates used | textured PEI, smooth | smooth | smooth |
| State | idle, no fault | idle, no fault reported | idle, no fault |
| Real rate, 0.20 mm layers | PLA 31 to 36 g/h, PETG 15 to 25 g/h | PLA 28 to 48 g/h | 3 to 4 g/h at 0.10 mm |

The rates come from the job history FABRICATOR keeps (grams and seconds per
finished job). What the printers mean for the design:

- **Riser parts print on the P1P or the P1S only.** A half module is about
  187 x 237 mm. The A1 mini can only take small add-ons (pulls, labels),
  and it carries a 0.2 mm nozzle at the moment.
- **One colour per part.** cydonia's send check refuses a job with more
  than one filament, and the P1P has no AMS. The designer therefore assigns
  a colour to each part, never two colours within a part.
- **No abrasive filaments.** Both 0.4 nozzles are stainless, so
  carbon-fibre and glow filaments stay out of the catalogue.
- **The P1S fan.** The superserter notes say its part-cooling fan was dead
  on 2026-11-07. FABRICATOR shows no fault today, and two jobs of about
  five hours finished on it on 11-11 and 11-12. Worth a word from Alex
  before the P1S gets long riser prints.

### The fit test

FABRICATOR lists three fit-test jobs on the P1P today: 12:08
(`fit_test_left.stl`, 13.2 g), 12:47 (`fit_test_right.stl`, 12.8 g) and
14:51 (`fit_test_left (1).stl`, 16.5 g). Alex on 2026-11-13: treat ring 2
as passed. He will check it once more, and the seat numbers in section 4 of
`DESIGN.md` can still be amended after that.

He tested it later the same day: nicer than ring 1, but a bit too loose.
The seat is now 0.6 mm smaller each side in every model and every test
piece (third version, 0.4 mm of play). He printed ring 3 the same day and
confirmed the fit. Next he prints the test pieces, then a whole top plate
as the final test.

### Tools on the dev PC

- OpenSCAD nightly 2026.10.22 with the Manifold backend, at
  `C:\Program Files\OpenSCAD (Nightly)\openscad.com`. A half module of the
  block model exports in about 0.1 s. `interface_check.scad` renders in
  0.6 s with Manifold and in 3 min 35 s with CGAL, the only backend 2021.01
  has. So the STLs get built here and committed, and nobody needs F6 in
  2021.01.
- OpenSCAD 2021.01, the version the files target, is not installed here.
  Compatibility needs its own check (step M1.7).
- `openscad --export-format param` writes every Customizer parameter (name,
  caption, options, default) as JSON. Tried on `split_concepts.scad`.
- Bambu Studio, whose command line is what cydonia's `bin/slice-plate`
  drives. It reads back the slicer's print time and grams, for the P1P and
  P1S profiles.

### One measurement that shapes the website

A module is the same shape at every height except for a straight middle
section. Checked on the block model: the left half exported at 60 mm has no
vertices between Z = 4.6 and Z = 56, and the 90 mm export is the same mesh
with everything above that band moved up by 30. Weight grows in a straight
line too: 174 g at 60 mm, 226 g at 90 mm, so about 1.7 g per mm for a half
and 1.8 g per mm for the drawer.

So the browser does not need a CAD kernel. It can load one mesh per part,
exported once by OpenSCAD, and move the top of it up or down. The `.scad`
stays the only source of the geometry.

### The starter (`odin-htmx-starter`, v2.6.0)

- A new app starts from GitHub's "Use this template" and
  `odin run tools/init -- <name> --features ...`. Init removes the apollo
  stack files, so the new app brings its own compose service and proxy
  entries.
- Reusable as is: routing, SQLite with migrations and backups, admin
  accounts with TOTP, a `Lan_Only` flag per route, rate limits, background
  jobs with an admin page, SSE, logging, metrics, health endpoints, the
  Docker image and the release flow.
- **No outbound email at all**, by design. The container image has no TLS
  either, so mail has to leave through a relay (step W4).
- **No WebAssembly.** The Content-Security-Policy has no
  `wasm-unsafe-eval`, and `blob:` workers and images are blocked. WebGL is
  not affected. That is one more reason for the stretched-mesh viewer.
- Static files are a fixed, compiled-in list of 11. three.js, the designer
  script and the part meshes need that list and `tools/bundle` extended.
- The starter's own stack on apollo is LAN-only. A site for colleagues has
  to be public, like `hl.alexh95.com`.

### cydonia

- cydonia only pulls. Nothing listens for inbound traffic, the link to
  apollo is read-only, and sending a print is always Alex's own
  `cydonia-printers print ... --go`. Text from outside (job titles today,
  order notes tomorrow) is treated as untrusted.
- There is no print queue, order tracking or cost model to reuse.
- `bin/slice-plate` and `cydonia-printers print FILE PRINTER` already make
  a working path from an STL to a checked job on a printer.

### The repository

`alexh95/3d-models` is public. Its default branch is `main` since
2026-11-13 (decision 9). The work up to the choice of option A is also
on the older branch `claude/confident-dijkstra-dvvz2y`, which `main`
starts from.

## 2. Decisions (Alex, 2026-11-13)

Alex went with the recommendations, with three changes: no email yet, a
swivelling wedge drawer as the default, and four drawer features to plan
but not build.

| # | Topic | Decision |
|---|---|---|
| 1 | Fit-test ring 2 | Counted as passed, then tested the same day: a bit too loose. The seat shrinks by 0.6 mm each side in every model and test piece (`DESIGN.md` section 4). Ring 3 confirmed the new seat on 2026-11-13. Still to print: the test pieces, then a whole top plate as the final test |
| 2 | Default way to open the drawer | The finger scoop, for now. Handles that replace it are planned (M4.1) |
| 3 | Default wedge insert | A drawer that swivels out and cannot be taken out in use (M1.4). `open` stays as the second choice |
| 4 | Top plate | A slab 8 mm tall in two halves, same seat on top and same step underneath as a module |
| 5 | Site name and reach | **Desk Stack** at `deskstack.alexh95.com`, public, with `launchpad.alexh95.com` leading to the same site (W6). Admin pages reachable from the LAN and WireGuard only |
| 6 | Requests and currency | Anyone with the link may fill in the form; costs in lei, catalogue kept in EUR |
| 7 | Email | **Deferred.** The form and its pages get built. Submitting shows a "work in progress" notice; nothing is sent and nothing is stored (W4) |
| 8 | Where the site's code lives | Its own repository made from the starter template, `C:\Projects\cc\riser-designer` |
| 9 | `main` branch for `3d-models` | Yes, as the default branch |
| 10 | cydonia links | C1 and C3; C2 once requests arrive (section 5) |

Planned, not to be built yet (section 3, M4): handles in place of the
finger scoop, a Gridfinity drawer with office bins, several drawers in one
module, and inner drawers.

## 3. Track M: the model

One file, `u3421we-riser/riser.scad`, self-contained like the others. It
holds the module, the drawer, the wedge insert and the top plate, chosen
with a `part` parameter, so the outline and seat numbers exist once in it.

### M0. Close the open measurements (Alex, minutes)

- A second look at ring 2 (decision 1). Done on 2026-11-13: a bit too
  loose, so the seat is 0.6 mm smaller each side.
- The four rubber feet: where they are and how far they stand below the
  black body. Without a deck they hang into the module; with the top plate
  they stand on it.
- The no-print corner of the P1 bed, checked in Bambu Studio with the
  230 mm wide drawer.

### M1. The module, with a parametric height

1. **Body halves.** Option A as chosen: floor, rear wall, two bay walls,
   corner wraps, shelf and lip on top, stepped bottom. The shelf underside
   and the bottom step get their 45 degree chamfers. Seam: flat dovetail in
   the floor at the front, full-height dovetail at the rear.
2. **Height.** `module_h` from 30 to 200 mm, default 60. Everything is
   anchored to the bottom or to the top of the module and nothing scales,
   so the middle stays a straight section. That rule is what lets the
   website stretch a mesh, and a script checks it on every export.
3. **Drawer and default pull.** Front panel flush with the body, following
   the hollow front edge. Default pull: a rounded scoop about 40 mm wide
   and 14 mm deep in the top edge of the panel. It needs no extra part,
   prints without supports, sticks out nowhere, and works at every height
   and in every position of a stack. Also in the file: `plain`. Handles
   come later (M4.1). Stop tongue and closed detent as sketched in
   `DESIGN.md` section 7.
4. **Default wedge: a swivelling drawer.** A pie-shaped drawer on an
   upright post near the narrow front end of the wedge. It swings out
   through the open side by about 60 degrees. Its outside wall is the
   module's side wall there, so a closed drawer leaves the side flush.
   - **Captive.** The drawer drops over the post before the next module,
     plate or the monitor goes on. After that it cannot lift off: 0.6 mm
     of play against a post as tall as the module. Taking it out means
     unstacking.
   - **Stops.** A rib on the hub meets a buttress on the bay wall at full
     swing; the bay wall itself stops it when closed. A bump on a rail
     holds it shut.
   - **Rides high.** The drawer's floor runs 4.6 mm up, on a low sill and
     two rails, so it swings out over the lip of whatever is underneath.
     The main drawer rides at the same level for the same reason, which
     makes the lowest 4.6 mm of a module a closed plinth all the way
     round.
   - **Pull.** A finger notch in the top edge near the far end.
   - `open` (no drawer, an open cubby) is the other choice. A wall carried
     through (`closed`) and other inserts can follow.
5. **Lightening and feet.** Cut-outs in the floor between the strips the
   drawer runs on, recesses for stick-on feet under the lowest module, and
   a clearance band under the pocket floor for the monitor's own feet.
6. **Views.** Assembled, exploded, print plates, a stack of several
   modules, and each part alone for export.
7. **Checks, scripted in `tools/`.** Export every part at 30, 45, 60, 90
   and 120 mm; fit on a 256 mm bed; no overhang steeper than 45 degrees;
   the straight-middle rule; the parameter block identical to the other
   `.scad` files. Open each file once in a real OpenSCAD 2021.01 (a Docker
   image under WSL, or its portable zip beside the nightly), since Alex
   views them there.
8. **Small test prints before the big one.** A step ring that drops into
   the existing fit-test ring (stacking gap), the front 60 mm of the bay
   with the front 60 mm of a drawer (slide, scoop), the drawer stop (a
   slice of bay wall with a slice of drawer side), the hub end of a wedge
   with the hub end of its drawer (post, swing, stops), and a 40 mm sample
   of the rear seam. Between 13 and 55 g a set, about 150 g in all.
9. **Ready-made set.** STLs for a 60 mm module in `stl/`, sliced plates for
   the P1P through `slice-plate`, real weights and times in `DESIGN.md`.

**Built on 2026-11-13** (`u3421we-riser/riser.scad`, `DESIGN.md` section
12): steps 1 to 7 and 9 are done on the computer, step 8's five test
pieces are exported and wait for the printer. Sliced, a 60 mm module is
540 g and 13 h 54 over four plates, wedge drawers included; with an 8 mm
top plate, 779 g and 7 to 16 EUR of PLA. Not built from step 5: the
recesses for stick-on feet, and a clearance band for the monitor's own
feet. The top plate under the monitor takes the place of the second.

### M2. The top plate

- **What it is.** A flat slab with the riser's outline. Its top carries the
  same lip and pocket as a module; its underside has the same step. So it
  sits on a module, on the desk, or on another plate, without limit.
- **What it is for.** A lid and a full deck under the monitor (the rubber
  feet stand on it, as on a desk), a fine height step, and a low riser made
  of plates alone. It also ties the two halves of the module below it.
- **Build.** `plate_h` 8 mm by default (7 is the least the step and its
  chamfer allow). Printed flat, right way up, as a solid slab with the
  slicer's infill; no bridging, no supports. Two halves with the flat
  dovetail the fit-test ring already proved. Sliced: 239 g a pair,
  5 h 40.
- **Seam on the centre line.** An off-centre seam, staggered like
  brickwork, was the other idea. It would not hold a stack together any
  better: the step of the upper part sits *inside* the lip of the lower
  one, so a lower half is never held in by what stands on it. The
  dovetails hold the halves; the lip below keeps the upper halves from
  spreading.
- **Test.** The step ring from M1.8 is the cheap check; then one plate.

**Built on 2026-11-13,** in the same file as the module. It is also the
recommended top of every stack: under the monitor it gives the rubber
feet a flat deck.

### M3. Export for the website

`u3421we-riser/tools/riser_build.py web` writes the bundle from
`riser.scad` into `u3421we-riser/web/` (first written 2026-11-13, with
sliced weights and times). The site copies that folder and pins its `revision`.
This is the contract between the model and the site, bundle version 1:

- `meshes/<part id>.stl`: one binary STL per part and variant, in mm, in
  the model's own coordinates (X right, +Y to the wall, Z up, Z = 0 at the
  underside of the module or plate), exported at the reference height.
- `bundle.json`:

  ```json
  {"bundle": 1, "profile": "dell-u3421we", "revision": "2026-11-13.1",
   "density_ref": 1.24,
   "kinds": {
     "module": {"h": {"min": 30, "max": 200, "step": 5, "default": 60, "ref": 60},
       "options": {"front": {"values": ["scoop", "plain"], "default": "scoop"},
                   "wedge_l": {"values": ["swivel", "open"], "default": "swivel"},
                   "wedge_r": {"values": ["swivel", "open"], "default": "swivel"}},
       "color_slots": ["body", "drawer", "wedges"]},
     "plate": {"h": {"min": 7, "max": 20, "step": 1, "default": 8, "ref": 8},
       "options": {}, "color_slots": ["body"]}},
   "parts": [
     {"id": "body_left", "kind": "module", "slot": "body", "when": {},
      "mesh": "meshes/body_left.stl",
      "stretch": [{"z0": 7.0, "z1": 53.0, "share": 1}],
      "motion": null, "bed": [189, 239],
      "est": {"h": [30, 60, 120], "grams": [98, 131, 197], "minutes": [190, 250, 370], "source": "sliced"}},
     {"id": "drawer_scoop", "kind": "module", "slot": "drawer", "when": {"front": "scoop"},
      "motion": {"type": "slide", "dir": [0, -1, 0], "travel": 165}},
     {"id": "wedge_swivel_r", "kind": "module", "slot": "wedges", "when": {"wedge_r": "swivel"},
      "motion": {"type": "swivel", "pivot": [130.4, 47.0], "deg": -60}}],
   "seat": {"lip_h": 4.2, "moving_parts_above": 4.6},
   "ghost": {"black": "meshes/dell_black.stl", "plate": "meshes/dell_plate.stl"}}
  ```

  (The numbers above are examples; a part lists every field.)
- **Stacking.** Each item in a stack adds its own `h`. Anything can stand
  on anything.
- **`when`** lists the option values a part belongs to; an empty object
  means always. Left and right parts are exported separately, so the site
  never mirrors a mesh.
- **`stretch`.** For a height `h`, every vertex at or above `z1` moves up
  by `share * (h - ref)`; vertices at or below `z0` stay. No vertex lies
  between `z0` and `z1`. Version 1 has one band per part; the list form is
  there so a part with a runner halfway up (M4.3) can have two.
- **`motion`.** `slide`: move by `travel` mm along `dir` when fully open.
  `swivel`: turn by `deg` degrees about the upright axis through `pivot`,
  counter-clockwise seen from above when positive.
- **`est`.** Grams (for `density_ref`) and minutes at the listed heights;
  the site draws straight lines between them. `source` is `sliced` (Bambu
  Studio through `slice-plate`) or `volume` (mesh volume and the real
  rates in section 1) until a part has been sliced.
- **`ghost`** is the monitor's base for the site to draw: two meshes, the
  black lower body and the silver plate, with Z = 0 on the pocket floor of
  the top item.

The site checks every design against `kinds` before storing it, so the
site and the model cannot drift apart.

### M4. Planned, not built yet

Alex, 2026-11-13: plan these, do not build them yet. They shape a few
choices in M1 (noted at the end), and each gets its own small test print
before it goes into the ready-made set.

#### M4.1 Handles in place of the finger scoop

- **A mount, not a handle.** The drawer front gets a third variant,
  `handle`: a panel without the scoop, with two upright dovetail slots
  96 mm apart that are open at the panel's top edge. A separately printed
  handle slides in from above. Whatever stands on the module leaves it
  0.6 mm of lift, so it stays in.
- **The set:** a bar pull, an edge pull (a lip along the top edge), a cup
  pull, a knob (one slot), a pull with a window for a paper or tape label,
  and a small tab pull for the wedge drawers.
- **Limits.** The front edge is hollow by 15.8 mm on the centre line, so a
  handle up to about 14 mm proud stays behind the line between the front
  corners and never passes the footprint. Every handle prints lying on its
  back, without supports, and is small enough for the A1 mini.
- **Fixing.** The dovetail by default. As an alternative, an M3 screw from
  inside into a heat-set insert, since the insert press exists.
- **On the site:** more values for `front`, a `pulls` colour slot, handle
  meshes that never stretch.
- **Test:** 50 mm of panel with the mount and one bar pull, about 10 g.

#### M4.2 A Gridfinity drawer with office bins

- **The grid.** Gridfinity is an open standard (MIT): 42 mm cells, 7 mm
  height units. The bins get written here as one self-contained
  `gridfinity_bins.scad`, to the published profile, so bins from anywhere
  else fit too. Its numbers get checked against the specification and a
  one-cell print before anything larger.
- **What fits.** The drawer is about 227 mm wide inside and 200 mm deep at
  its shallowest: 5 by 4 cells (210 x 168 mm) with a full-width strip
  about 30 mm deep left at the front. That strip becomes a trough for pens
  and a 20 cm ruler.
- **In the floor, not loose.** A drawer variant, `drawer_floor = "grid"`,
  prints the baseplate profile into the drawer's floor. A loose baseplate
  would cost the same height and be one more part.
- **Height.** Bins are cut to the module, without the stacking lip by
  default:

  | Module height | Clear height in the drawer | Tallest bin |
  |---|---|---|
  | 30 mm | 23.8 mm | 3 units (21 mm) |
  | 45 mm | 38.8 mm | 5 units (35 mm) |
  | 60 mm | 53.8 mm | 7 units (49 mm) |
  | 90 mm | 83.8 mm | 11 units (77 mm) |

  (Clear height is the module height less 6.2 mm: the plinth, the
  drawer's floor and the play at the top.)

- **The bin generator:** cells in X and Y, height in units, dividers in X
  and Y, a scooped floor, a label tab, lip on or off.
- **Office presets,** each a set of generator values plus, where needed, a
  fitted inside:

  | Bin | Cells | Holds |
  |---|---|---|
  | Small parts | 1 x 1, 1 x 2, 2 x 2 | paper clips, pins, rubber bands; scooped floor |
  | Divided | 1 x 1 in 2 or 4, 2 x 1 in 3 | staples, clips by size, coins |
  | Pen tray | 1 x 4 | pens and pencils up to 164 mm |
  | Marker tray | 2 x 4 | markers, highlighters, a stapler |
  | Sticky notes | 2 x 2 | a 76 x 76 mm pad, with a thumb cut |
  | Flags and small pads | 1 x 2 | 51 x 38 mm pads, page markers |
  | Cards | 3 x 2 | business and bank cards lying flat, two piles |
  | Card rack | 2 x 1 | cards standing in slots |
  | SD rack | 1 x 1 | 8 SD and 8 microSD cards |
  | USB rack | 1 x 1 | 6 USB-A sticks or dongles, upright |
  | Battery tray | 2 x 1 | 8 AA or 12 AAA, upright |
  | Cable bin | 2 x 2 | coiled cables, with a comb on one wall |
  | Charger bay | 2 x 2 | a charger and its cable |
  | Glasses tray | 4 x 2 | glasses, lined floor optional |
  | Keys and coins | 2 x 2 | shallow, scooped |
  | Earbuds and small tech | 2 x 1 | a case, adapters |
  | Blank | any | a flat cover to fill unused cells |

- **The wedge drawers** are not on the grid; a triangle wastes it. They
  get fitted inserts: a pen rest along the outside wall and a divider set.
- **On the site:** a layout editor for the drawer (a 5 by 4 board, bins
  dragged from a palette, a few ready layouts), bins as parts with their
  own colours, bins shown in the opened drawer, and the estimate from a
  sliced table per bin size.
- **Tests:** one cell of gridded floor with a 1 x 1 bin; then one drawer.

#### M4.3 Several drawers in one module

Two layouts, chosen with one parameter, `drawer_layout`:

- **Side by side.** A wall on the seam, one half of it on each body half,
  and two drawers about 113 mm wide. It suits the split: every half
  becomes a complete unit, the centre wall stiffens the seam and carries
  what stands on top, and each drawer prints faster and warps less. Each
  takes 2 by 4 cells with a strip left over. Build this one first.
- **Two high.** Runner ledges on the bay walls, with a 45 degree
  underside, carry an upper drawer; the lower one runs beneath them. For
  modules of 60 mm and more. Two low modules stacked give nearly the same
  space, so this mostly saves two body parts and keeps tall wedge drawers
  beside two shallow main ones.
- **Cost to the site:** the ledges sit halfway up, so those parts stretch
  in two bands (already allowed by the bundle format). `front`, the grid
  and the stop then exist per drawer.

#### M4.4 Inner drawers

Read as: a shallow tray that runs inside the main drawer, above its lower
compartment, and slides back to uncover it. If Alex meant a second, hidden
drawer behind the same front, running on the bay walls, that is the "two
high" layout with a shared front panel.

- Two ledges on the inside of the drawer's side walls carry the tray. It
  is as wide as the drawer and about half as deep, so it slides between
  front and back.
- The tray is 3 units (21 mm) inside, enough for pens; the compartment
  below keeps the rest. That needs a module of 60 mm or more.
- The tray can carry the grid as well (5 by 2 cells).
- On the site: one more option on the drawer, one more part that slides
  with the drawer and then on its own.

#### What this changes in M1 now

- The bay stays 231.2 mm wide inside and the drawer's rear wall is
  straight, so both the 5 by 4 grid and a seam wall fit later.
- The drawer's side walls stay plain on the inside, where the tray ledges
  will go.
- The bundle's `stretch` is a list, and `options` can grow.
- Suggested order: handles, then the grid and bins, then the inner tray,
  then several drawers.

## 4. Track W: the website

A new repository from the starter template. The designer page itself is
browser code (the design lives in local storage); htmx serves the request
form, the order page and the admin pages.

### W0. Skeleton and contract

- Create the repository and run `tools/init` with accounts (admin and
  TOTP), jobs and audit. Add three features: `designer`, `catalog`,
  `orders`.
- Fix the design format, version 1. A design is a list from the desk up:

  ```json
  {"v": 1, "profile": "dell-u3421we", "stack": [
    {"kind": "module", "h": 60, "front": "scoop",
     "wedge_l": "swivel", "wedge_r": "swivel",
     "colors": {"body": "bambu.pla-basic.black", "drawer": "sunlu.pla-matte.white", "wedges": "bambu.pla-basic.orange"}},
    {"kind": "plate", "h": 8, "colors": {"body": "bambu.pla-basic.black"}}
  ]}
  ```

  The option names, their values and the colour slots come from the
  bundle's `kinds` (M3), and the server checks every design against them.
- Start on a placeholder bundle in the M3 format, exported from today's
  block model, so this track does not wait for track M.

### W1. The 3D viewer

- three.js r187 (MIT), vendored, loaded only on the designer page: two
  files, about 315 KB compressed, plus its STL loader and orbit controls.
  A recorded exception to the starter's small-script budget.
- Two things to get past in the starter: its fixed static-file list, and
  its Content-Security-Policy, which blocks the inline import map three.js
  add-ons expect. Either the map's hash goes into the policy or the
  add-ons' import lines are rewritten when vendoring.
- If stretching ever stops being exact (step M1.2 guards it), the fallback
  is one mesh per height on a fixed step.
- Loads the bundle, stretches each part to its module's height, stacks the
  modules, draws a desk and a ghost of the Dell stand and panel for scale.
- Orbit, zoom and pan with mouse and touch. A material per filament line:
  matte, basic, silk, translucent.
- Animations: drawers slide to their real stop, wedge drawers swing out
  on their pivots, modules drop in when added and lift out when removed,
  an exploded view.
- Without WebGL: a picture and the parts table.

### W2. The editor

- Module list: add, remove, reorder, copy, edit one (height, pull, left
  and right wedge, colour per part), apply a change to all. Top plates as
  list items.
- Local storage: named designs, autosave, a versioned format, export and
  import as a file.
- A share link that carries the design in the address, with no server
  storage.
- A totals bar: height, weight, print time, cost range, number of plates.

### W3. Filaments and the estimate

- **Catalogue:** the lines that suit these printers, each colour with its
  name and hex value, each line with density, a low and a high price per
  kg and the date they were last checked. Editable in the admin pages.
  The first data set is in `docs/filaments-2026-11-12.md`:

  | Brand | Line | Colours | Density | EUR per kg, low to high |
  |---|---|---|---|---|
  | Bambu Lab | PLA Basic | 30 | 1.24 | 9.00 to 19.99 |
  | Bambu Lab | PLA Matte | 25 | 1.31 | 9.00 to 19.99 |
  | Bambu Lab | PETG Basic | 13 | 1.25 | 8.47 to 18.99 |
  | Bambu Lab | PETG Translucent | 9 | 1.25 | 9.00 to 19.99 |
  | SUNLU | PLA, PLA+, PLA+ 2.0 | 54, 35, 27 | 1.21 to 1.23 | about 10.2 to 13.99 |
  | SUNLU | PLA Matte | 16 | 1.31 | about 10.2 to 12.99 |
  | SUNLU | PETG | 35 | 1.27 | 10.20 to 12.99 |

  Low is the best bulk price on the EU stores on 2026-11-12, high is one
  roll at list price. Bambu's low end is its sale tier for 14 or more
  refills, which runs to 2026-12-01; four refills cost 12.74 each. That
  spread is the "huge range" and the estimate shows it as one.
- **Where the colours come from.** Bambu publishes its hex codes in the
  Bambu Studio repository (`filaments_color_codes.json`), so a script can
  rebuild that half of the catalogue. SUNLU publishes none: its values are
  sampled from the store's product pictures and marked approximate, to be
  corrected against real spools. Bambu's PETG HF is no longer sold in the
  EU; PETG Basic replaced it.
- **Wording.** Brand and colour names only, no logos, and a line saying
  the site is not affiliated with either maker.
- **Weight and time:** from the sliced numbers in `parts.json`, a straight
  line through the three heights, scaled by the material's density. Until
  a part has sliced numbers: volume and the real rates from section 1.
- **Cost:** grams times the low and the high price, shown as a range, with
  a waste allowance. Electricity and a machine rate are optional settings.
- **Print plan:** which parts go on which plate, hours per plate, and that
  the parts need a 256 mm bed.

### W4. Requests and the confirmation email (feasible, with conditions)

**Now (decision 7):** the request form, its checks and the pages around it
get built, and so do the stored-request and admin parts behind a switch.
The switch has three positions: `wip`, the default and the only one used
on apollo for now, where submitting a valid form shows a "work in
progress" notice and nothing is sent or stored; `open`, used in tests and
later, where the request is stored; and `off`. The email below is the
deferred part: a mailer interface with a do-nothing implementation holds
its place.

- **Flow.** Form with email and an optional name and note. The server
  stores the design, the estimate as shown, and an unguessable link. It
  sends one email with the full design summary and that link. Opening the
  link confirms the address and shows the request with its status.
- **The email.** HTML with a plain-text twin. Everything in it is written
  by the server from the checked design: the stack drawn as coloured table
  cells, each module with its height, pull, wedges and filaments, the
  parts list, weight, time and cost range, and the link. The visitor's
  name and note stay out of it, so the form cannot be used to send someone
  else's words.
- **Sending.** Mail straight from a home connection gets rejected, so it
  goes through a provider. The free tiers of Resend (100 a day) or Mailjet
  (200 a day) are far more than this needs; a mailbox Alex already has
  works too, over its SMTP submission port. The starter has no mail and
  its image has no TLS, so: a small plain SMTP client in the app, talking
  to a relay container in the same compose stack, which hands the mail on
  over TLS. A fake SMTP server in `tools/` for tests.
- **What Alex has to do:** pick the provider, add the SPF, DKIM and DMARC
  records (best on a sending subdomain), store the secret.
- **Abuse and privacy.** Rate limits per sender and per address, one open
  request per address, a daily cap below the provider's quota, a hidden
  trap field, the same answer whether or not a mail went out, unconfirmed
  requests deleted after a week, and a short note on what is stored and
  how to have it removed.
- **Statuses:** requested, confirmed, accepted, printing, ready, handed
  over, declined, cancelled.

### W5. Admin

- Requests list with filters; one request with its design in the viewer,
  the parts and print plan, internal notes, status changes with an optional
  email to the requester, and the design file for track C3.
- Filament prices and stock flags; estimator settings.
- A new admin permission; all admin routes `Lan_Only` and behind TOTP.

### W6. Hosting on apollo

- Compose service, data volume, backups, health check, release image.
- **Two addresses, one site.** Alex likes both names and chose Desk Stack
  as the main one (2026-11-13). The site is called Desk Stack and lives
  at `deskstack.alexh95.com`; `launchpad.alexh95.com` redirects there at
  the proxy. One address has
  to be the real one: designs are kept in the browser, per address, so a
  design saved under one name would be missing under the other. Share
  links and request links always carry the main address. Swapping which
  one is the main one is a setting, as long as it happens before people
  start saving designs.
- **Alex's steps:** two DNS records, a proxy host and certificate for the
  main address, a redirect for the other, the data folder, the admin and
  mail secrets.
- Promotion by script, run when Alex asks.

### W7. Worth adding

- A height helper: desk and eye height in, suggested total rise out.
- Print-plate view: the parts laid out on 256 mm beds.
- "Print it yourself": the STL set at the common heights and a link to
  this repository.
- A screenshot button, for sharing a design in chat.
- Live status on the request page (the starter has SSE).
- Later: exact STLs for any height made on the server, a gallery of
  printed risers, other monitors once `DESIGN.md` section 9 is built.

## 5. Track C: cydonia

Integration makes sense in a narrow form: cydonia keeps pulling, the site
never reaches a printer, and nothing typed into the site is read out or
shown on cydonia.

| # | Link | Direction | Effort | When |
|---|---|---|---|---|
| C0 | Printer facts as design limits (section 1) | read by hand | done | now |
| C1 | The site's health on flightd's GO/NO-GO board | cydonia pulls | small; one check, the CYD tile, the help page | after W6 |
| C2 | "A riser request is waiting": the site mails Alex through the relay it already has (with no TLS it cannot push to ntfy itself). Later cydonia may poll a bare count, say a fixed line and push it to the phone | site to mailbox, or cydonia pulls | small | after W4 |
| C3 | From a request to plates: a script on the dev PC turns the design file into STLs, slices them with `slice-plate`, copies them to cydonia and runs the send check. `--go` stays with Alex | by hand, existing path | medium | after M1 and W5 |
| C4 | Estimates against reality: compare each printed riser part with FABRICATOR's job history and correct the estimator | read by hand | small | after the first prints |

Not recommended: showing live printer state on a public site, any way in
to cydonia from apollo, and any button on the site that starts a print.

## 6. What can run at the same time

| Session | Repository | Can start | Needs from Alex |
|---|---|---|---|
| A. Model: top plate, then module, then export (M2, M1, M3) | `3d-models` | started 2026-11-13 | fit feedback, test prints |
| B. Site: skeleton, viewer, editor, catalogue, estimate, form, admin (W0 to W5) | `riser-designer` | started 2026-11-13 | a look at the prices |
| D. Mail: SMTP client, relay, fake server (rest of W4) | `riser-designer` | deferred by Alex | provider choice |
| E. cydonia links (C1, C3) | `cydonia` | after W6 | nothing |

A and B share no files, so they run together. B uses a placeholder
bundle from the block model until M3 delivers the real one.

Milestones:

1. **Something to show:** the site live with viewer, editor and estimate
   (W0 to W3, W6).
2. **Taking requests:** form, email, admin (W4, W5).
3. **Printing a request:** the model's ready-made set and the path from a
   request to plates (M1 to M3, C3).

## 7. Risks

- **OpenSCAD 2021.01.** The dev PC builds with a 2026 nightly. A feature
  that only the nightly has would show Alex an empty preview again. Step
  M1.7 guards against it.
- **Warping.** Half modules and plates are large flat parts. PLA first;
  PETG only after a test.
- **Estimates.** Block-model weights run heavy and nothing has been sliced.
  The site should call its numbers rough until C4 has real prints.
- **Email.** Deliverability depends on the DNS records, and a public form
  that sends mail invites abuse. Hence the confirm link and the limits.
- **A public service on apollo.** One more host open to the internet;
  admin stays LAN-only.
- **The starter.** Extending its fixed static-file list is a local change
  to carry through every starter update, unless it goes upstream.
- **Prices.** Filament prices move; each carries its date and shows as a
  range.
