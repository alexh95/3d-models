# Riser for the Dell U3421WE

A stackable, 3D-printed riser with the same footprint as the monitor's stand
base, to be printed on a Bambu Lab P1S or P1P (256 mm bed). Work in progress:
the monitor's base, the seat it sits in and a fit-test ring are modelled, and
the way to split a module into parts is chosen. The riser itself is not
designed yet.

**[DESIGN.md](DESIGN.md) has the measurements, decisions, test history and
next steps.**

## Files

| File | What it is |
|---|---|
| `interface_check.scad` | The Dell base as measured (outline 357.5 x 235 mm overall), the seat on top of the riser that it drops into, and the fit-test ring. Self-contained: it needs no other files. |
| `split_concepts.scad` | Rough block models of three ways to split a module into printable parts, with exploded and print-plate views. Self-contained. |
| `joint_concepts.scad` | Rough samples of five ways to join two parts at a seam. Self-contained. |
| `docs/concepts-exploded.png`, `docs/concepts-print-plates.png`, `docs/joint-concepts.png` | Pictures of those concepts. |
| `stl/fit_test_left.stl`, `stl/fit_test_right.stl` | The fit-test ring, ready to slice. |
| `tools/` | Scripts that traced the outline, draw the diagrams and measure parts. |
| `docs/outline-u3421we.png` | Dimensioned drawing of the outline. |
| `docs/outline-u3421we-1to1-A4.pdf` | 1:1 paper template of the outline, two A4 pages. Print at 100 %. |
| `docs/seat-section.png` | Cross-section of the seat with dimensions. |

## Viewing the models

1. Install [OpenSCAD](https://openscad.org/downloads.html).
2. Open a `.scad` file and press **F5** to preview. Drag to rotate, scroll to zoom.
3. Open **Window > Customizer** to change the measurements or switch views
   without editing code.
4. **F6** then **File > Export > STL** produces a file for Bambu Studio.

## Fit-test ring

A thin ring with the same lip the riser will have, for checking the seat
against the real monitor base before anything bigger is printed. About 17 g
of filament per half.

- Print both halves as exported: band flat on the bed, lip up, no supports,
  0.2 mm layers. Each half needs its own plate.
- Press the halves together at the two dovetails, then set the monitor base
  into the ring.
- If the dovetails are too tight or too loose, change `test_joint_gap` in the
  Customizer and re-export.

### Test history

| Ring | Seat | Result |
|---|---|---|
| 1 | Lip 1.2 thick, 3.8 tall, inside face 1.2 inside the plate edge, outside face flush with it | Halves join well, base drops in, edges line up. No side play, and the air gap under the plate looked too big. |
| 2 | Lip 1.8 thick, 4.2 tall, inside face 0.2 inside the plate edge, outside face 1.6 outside it, 0.6 fillets on the inside top edge and foot | Not printed yet. |
