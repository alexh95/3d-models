# Riser for the Dell U3421WE: design notes and handoff

Everything decided, measured and learned so far, so the work can continue
from the repository alone. Last updated 2026-11-13.

**Status:** the monitor's base outline is confirmed and the seat it sits in
has been test-printed three times. The riser is designed in `riser.scad` on
option A: two body halves, a main drawer, two swivelling wedge drawers and
a stackable top plate, with the module's height as a parameter (section
12). Nothing of it has been printed yet. The seat is in its third version
(section 4), which fit-test ring 3 confirmed. Five small test pieces come
next, then a whole top plate as the final test of the seat.

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

Current version (third). The owner set the second version after the first
test, and after the second test asked for it 0.6 mm smaller each side:

| Parameter | Value, mm |
|---|---|
| `seat_lip_inner_inset`, inside face of the lip, inward from the silver plate edge | 0.8 |
| `seat_lip_w`, lip thickness | 1.8 |
| Outside face of the lip, outside the silver plate edge | 1.0 |
| `seat_lip_h`, lip height above the pocket floor | 4.2 |
| `seat_fillet_r`, round-over on the top inside edge and cove at the foot | 0.6 |
| Side play of the black body in the pocket | about 0.4 each side |

The lip keeps its thickness, so the whole riser shrinks with the pocket:
the body is 1.0 mm larger than the silver plate all round, about
359.4 x 237.0 mm overall (the second version was 1.6 larger).

The cove at the foot of the lip is 0.6 wide, which is now more than the
0.4 mm of play. So the black body rests on the coves all the way round and
centres itself, with no room to slide. If its bottom edge is sharp it
stands about 0.03 mm above the pocket floor. That is the seating effect
the owner asked for, and ring 3 confirmed the fit. Should a larger print
sit too tight, a smaller `seat_fillet_r` loosens it at the floor without
moving the lip.

See `docs/seat-section.png` and `interface_check.scad`.

### Fit-test history

| Ring | Seat | Result |
|---|---|---|
| 1 | Lip 1.2 thick, 3.8 tall, inside face 1.2 inside the plate edge, outside face flush with it, 0.4 bevel | Printed on the P1P. Halves press together nicely at the dovetails (0.2 gap). Base drops in. Silver edges line up. No side play. Air gap under the plate "perhaps too big". |
| 2 | Lip 1.8 thick, 4.2 tall, inside face 0.2 inside the plate edge, 0.6 fillets | Printed on the P1P on 2026-11-12. Tested by the owner on 2026-11-13: nicer than ring 1, but a bit too loose. 1 mm more each side was too much. |
| 3 | As ring 2, with the inside face 0.8 inside the plate edge: 0.6 mm tighter each side, 0.4 of play left | Printed and tested by the owner on 2026-11-13: confirmed. The final test of the seat is a whole top plate, after the test pieces. |

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
| 2026-11-13 | Fit-test ring 2 counts as passed (to be checked once more). | Owner |
| 2026-11-13 | Ring 2 tested: a bit too loose. The seat shrinks by 0.6 mm each side, in every model and every test piece (third version, section 4). | Owner |
| 2026-11-13 | The lip stays 1.8 thick, so the riser's outside shrinks by the same 0.6 mm each side. | Design, section 4 |
| 2026-11-13 | Print order: ring 3 and the test pieces, then a whole top plate as the final test. | Owner |
| 2026-11-13 | Ring 3 confirmed. The seat stays as in section 4 (third version). | Owner, after the test |
| 2026-11-13 | The wedge drawers swivel out by default and cannot be taken out in use. | Owner |
| 2026-11-13 | The finger scoop is the drawer pull for now; handles are planned, with a Gridfinity drawer, several drawers per module and inner drawers (`../PLAN.md`, M4). | Owner |
| 2026-11-13 | Top plate: 8 mm, two halves, seam on the centre line. | Owner, on the plan's recommendation |
| 2026-11-13 | Every drawer rides above the stepped-in zone (4.6 mm), so it opens over any lip underneath; that zone becomes a closed plinth. | Design, section 12 |
| 2026-11-13 | The recommended build puts a top plate under the monitor, so the rubber feet stand on a flat deck. | Design, section 12 |

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

- The third seat (0.4 mm of play) is confirmed with ring 3 only. A whole
  top plate is the final test.
- Nothing in `riser.scad` has been printed. The fits that are new, each
  with a test piece: the stacking step, the drawer's slide and scoop, the
  drawer stop, the wedge drawer's hub and stops, the rear seam.
- `riser.scad` has not been opened in OpenSCAD 2021.01 by the owner yet.
- Without a top plate the monitor's rubber feet hang over the drawers,
  0.6 mm above them. If the feet stand lower than the black body, they
  touch. With a top plate this does not arise.
- In a module taller than about 120 mm the wedge drawer's post is a long
  thin column (7.4 mm across). Untested.
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

The phases are laid out in `../PLAN.md`, with the owner's decisions of
2026-11-13 in its section 2. The brief they come from:

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
| `riser.scad` | **The riser:** module, drawers, top plate and test pieces (section 12) |
| `stl/module_60mm/`, `stl/plate_8mm/` | The ready-made set: a 60 mm module and an 8 mm top plate |
| `stl/tests/` | The test pieces |
| `web/` | Meshes and numbers for the designer website (`../PLAN.md`, M3) |
| `stl/fit_test_left.stl`, `stl/fit_test_right.stl` | Fit-test ring 3 (also written by `riser_build.py stl`) |
| `docs/outline-u3421we.png`, `.svg` | Dimensioned outline |
| `docs/outline-u3421we-1to1-A4.pdf` | 1:1 paper template, two A4 pages |
| `docs/seat-section.png`, `.svg` | Seat cross-section |
| `docs/concepts-exploded.png`, `docs/concepts-print-plates.png` | Split options |
| `docs/joint-concepts.png` | Seam joints |
| `tools/trace_dell_outline.py` | How the outline was traced from Dell's drawing |
| `tools/outline_drawings.py`, `tools/seat_drawing.py`, `tools/render_docs.js` | Regenerate the drawings and the template |
| `tools/measure_parts.py` | Export parts of the concept files and report size and weight |
| `tools/riser_build.py` | Check `riser.scad`, export its STLs, slice them, write the website bundle and the pictures |
| `tools/sliced.json` | Weights and print times from Bambu Studio, written by `riser_build.py slice` |
| `tools/openscad-2021/Dockerfile` | OpenSCAD 2021.01 in a container, to check the files still open in it |
| `docs/riser-*.png` | Pictures of the riser, written by `riser_build.py pictures` |

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

## 12. The riser as designed in `riser.scad` (2026-11-13)

Built on option A. Nothing has been printed yet; the test pieces at the
end of this section come first. Pictures: `docs/riser-exploded.png`,
`docs/riser-open.png`, `docs/riser-stack.png`, `docs/riser-hub.png`,
`docs/riser-print-plates.png`.

### One section for everything on the outside

From the underside up, measured from the edge of the silver plate:

| Zone | Height, mm | Outside face |
|---|---|---|
| Stepped-in zone | 0 to 4.6 | 1.1 inside, so 0.3 clear of the lip below; a 0.6 bevel on the bottom edge |
| Flare | 4.6 to 6.7 | 45 degrees, from 1.1 inside to 1.0 outside |
| Full outline | above 6.7 | 1.0 outside |

The body's walls, the drawer front, the outside walls of the wedge
drawers and the top plate all follow it.

### Nothing that moves reaches below 4.6 mm

Both kinds of drawer ride level with the top of the stepped-in zone. So
a drawer slides or swings out over the lip of whatever the module stands
on, a top plate included. That costs 3 mm of drawer depth. In return the
stepped-in zone runs all the way round as a closed plinth, which ties the
front corners together and stiffens the floor.

### Body halves

- Floor 1.6 thick, with six holes per half between the runners
  (`floor_lightening`).
- The plinth all round. Above it the rear wall and the four corner
  pieces, 2.4 thick, with the shelf and the lip of section 4 on top. The
  shelf is 5 mm wide and its underside rises at 45 degrees.
- Bay walls 2.4 thick and as tall as the module: with the rear wall and
  the corners they carry whatever stands on it.
- Runners for the main drawer: three rails per half and a ledge along the
  bay wall, tops at 4.6.
- Seam: two flat dovetails in the floor, as on the fit-test ring, and a
  full-height dovetail on a 10 mm block at the rear wall. The right half
  goes down onto the left half.
- The lip is missing along the drawer front and the two side openings.
  The corners and the rear hold the monitor, or the next part, in place.

### Main drawer

- 230 wide, straight at the rear, its front panel following the hollow
  front edge. Walls 1.2, front 2.0, floor 1.0.
- Inside: 227.6 wide, 200 deep on the centre line and 212 at the sides,
  and the module's height less 6.2 tall (53.8 in a 60 mm module).
- `drawer_front`: `scoop`, a finger scoop 40 wide and 14 deep in the top
  edge of the panel, or `plain`.
- Stop: a springy tongue in each side wall near the back, 16 long and 8
  wide, standing up from the floor so it prints without support. Its
  bump runs in a groove 1.0 deep in the bay wall. The groove begins 20 mm
  behind the front corners, which lets the drawer out by 170 mm
  (`drawer_stop_y`). A hump in the groove holds the drawer shut. A finger
  tab at the tip of each tongue pulls it in, to take the drawer out.

### Wedge drawers

- A pie-shaped drawer on an upright post, 7.4 across, that stands on the
  floor near the narrow front end of the wedge, at X = 128.6, Y = 41.8.
  The drawer's hub, radius 7, just touches the outside face, so the
  drawer's outside wall runs on from the hub and is the module's side
  wall there. Its rear end is an arc of radius 161.6 about the post.
- It swings out by 60 degrees (`wedge_swing`). At full swing everything
  further than about 18 mm from the post is outside the footprint.
- **It cannot be taken out in use.** It drops over the post before the
  next part goes on. After that it has 0.6 mm of lift against a post as
  tall as the module.
- Open stop: a rib on the hub meets a buttress on the bay wall. Both are
  as tall as the module, and they meet about 9 mm from the post. Closed stop:
  the bay wall, 0.4 mm from the drawer. A bump 0.4 high on the outer
  rail, with a dimple under the drawer, holds it shut.
- It rides on the plinth along the side and on two arc-shaped rails.
- Pull: a finger notch 26 wide and 12 deep in the top edge of the outside
  wall, near the far end.
- Inside it is 152 long along the outside wall, enough for one 150 mm
  pen; walls 1.8, floor 1.2.
- The corner in front of the hub is cut back just far enough for the
  first 4 mm of the outside wall to turn into it. The dead corner behind
  the drawer is closed by a thin curved wall, which also ties the rear
  corner piece to the bay wall.
- `wedge_left` and `wedge_right` can be `open` instead: no drawer, the
  same body.

### Top plate

- A slab with the same section: stepped-in zone and flare underneath,
  pocket floor at `plate_h` (8 by default, 7 at least), the full lip on
  top. It stands on a module, on another plate or on the desk.
- Two halves on the centre line, joined by three dovetails that go
  through the whole slab.
- **Recommended under the monitor.** It gives the rubber feet a flat
  deck, closes the drawers in from above and completes the lip along the
  front and sides.
- An off-centre seam, staggered like brickwork between stacked plates,
  was considered and dropped: the stepped-in zone of the upper part sits
  inside the lip of the lower one, so a lower half is never held in by
  what stands on it.

### How the parts are modelled

Every part is a pile of flat slabs. Each slab is a 2D shape, drawn for
the height in the middle of the slab and extruded straight up. Sloped
and rounded faces are steps 0.2 mm tall, the layer height. All cutting
and joining happens in 2D, so the F5 preview takes about 4 seconds in
OpenSCAD 2021.01. F6 is slow there; the STLs are made with the Manifold
backend of a current OpenSCAD.

Every feature is tied to the bottom or to the top of the module, and
each sloped feature reads its height on its own steps (`_q`). So a
module of another height is the same mesh with everything above the
straight middle section moved up or down. The website relies on that,
and `riser_build.py check` proves it at 30, 45, 90, 120 and 200 mm.

### Numbers

Sliced with Bambu Studio for the P1P on 2026-11-13: generic PLA, 0.20 mm
layers, 3 walls, 15 percent infill, one part per plate
(`tools/sliced.json`).

| Part | Size, mm | PLA | Print time |
|---|---|---|---|
| Body, left half | 187 x 237 x 64 | 144 g | 3 h 44 |
| Body, right half | 180 x 237 x 64 | 144 g | 3 h 48 |
| Main drawer, with scoop | 233 x 217 x 55 | 135 g | 3 h 04 |
| Wedge drawer, each | 59 x 171 x 55 | 58 g | 1 h 39 |
| **A 60 mm module** | 359 x 237 x 64 | **540 g** | **13 h 54** |
| Top plate, each half | 187 x 237 x 12 | 120 g | 2 h 50 |
| **An 8 mm top plate** | 359 x 237 x 12 | **239 g** | **5 h 40** |
| A 30 mm module | | 347 g | 9 h 23 |
| A 120 mm module | | 925 g | 22 h 51 |

A module gains about 6.4 g and 9 minutes for each millimetre of
height. A 60 mm module with a top plate is 779 g, which is 7 to
16 EUR of PLA at the prices in `../docs/filaments-2026-11-12.md`. The
two wedge drawers fit one plate, so a module is four plates and a top
plate two.

### Checks

`python tools/riser_build.py check` exports every part and checks:

- the numbers shared with the other `.scad` files are the same;
- every part fits a 256 mm bed, up to a 200 mm module;
- no two parts overlap: body, drawer, wedge drawer and plate, with the
  drawers from closed to fully open, on a plate, under a plate, on
  another module, at 30 and 60 mm;
- nothing needs support. What remains are two short bridges: 10 mm over
  the tip of each tongue, and a 2.4 mm dimple under each wedge drawer;
- the straight-middle rule above.

Also checked by hand on 2026-11-13: the file opens and previews in a real
OpenSCAD 2021.01 (`tools/openscad-2021/Dockerfile`).

### Test pieces, in `stl/tests/`

Each checks one new fit. Print these before a whole part.

| Pieces | PLA | What to look for |
|---|---|---|
| `test_step_left`, `test_step_right` | 42 g | The ring drops into fit-test ring 3 (not ring 2, which is 0.6 mm larger each side) with a little play all round and sits flat. This is the stacking fit |
| `test_hub_body`, `test_hub_drawer` | 24 g | The drawer end drops over the post, turns freely from shut to the stop, and its outside wall is flush when shut |
| `test_front_left`, `test_front_right`, `test_front_drawer` | 55 g | The two fronts press together at the dovetail; the drawer front slides between the bay walls on the runners; the panel is flush; the scoop is comfortable |
| `test_stop_body`, `test_stop_drawer` | 13 g | The tongue bends without cracking, its bump drops into the groove and holds against a pull, the tab frees it |
| `test_seam_left`, `test_seam_right` | 19 g | The right block slides down over the left one's dovetail and sits snug |

They are cut from 30 mm modules (the seam from a 40 mm one).

