# Riser for the Dell U3421WE

A stackable, 3D-printed riser with the same footprint as the monitor's stand
base, to be printed on a Bambu Lab P1S. Work in progress: so far only the
monitor's base and the seat it sits in are modelled. The riser itself is not
designed yet.

## Files

| File | What it is |
|---|---|
| `outline.scad` | Outline of the Dell base plate, 357.5 x 235 mm overall. Everything else is built from this. |
| `interface_check.scad` | The Dell base as measured, and the seat on top of the riser that it drops into. |
| `docs/outline-u3421we.png` | Dimensioned drawing of the outline. |
| `docs/outline-u3421we-1to1-A4.pdf` | 1:1 paper template of the outline, two A4 pages. Print at 100 %. |
| `docs/seat-section.png` | Cross-section of the seat with dimensions. |

## Viewing the models

1. Install [OpenSCAD](https://openscad.org/downloads.html).
2. Open a `.scad` file and press **F5** to preview. Drag to rotate, scroll to zoom.
3. Open **Window > Customizer** to change the measurements or switch views
   without editing code.
4. **F6** then **File > Export > STL** produces a file for Bambu Studio.
