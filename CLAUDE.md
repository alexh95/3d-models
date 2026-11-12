# 3d-models

Parametric models for 3D printing, written in OpenSCAD.

## Projects

- `u3421we-riser/`: a stackable riser with drawers for the stand of a Dell
  U3421WE monitor. Read `u3421we-riser/DESIGN.md` first: it holds the
  measurements, the decisions made so far, the test-print history, open
  questions and what is planned next.

## Conventions

- Every `.scad` file is self-contained. Do not use `include` or `use`
  between files: they are downloaded and opened one at a time.
- Target OpenSCAD 2021.01. Expose the measurements as Customizer parameters
  with a comment line above each.
- Units are millimetres. X = left/right, +Y = toward the wall, Z = up.
- Parts must print without supports on a 256 mm bed (Bambu Lab P1S / P1P).
- Agree an outline, interface or concept with a drawing or rough model
  before building on it, and test each new fit with a small print before a
  large one.
- Record decisions and test results in the project's `DESIGN.md`.
