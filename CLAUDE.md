# 3d-models

Parametric models for 3D printing, written in OpenSCAD.

## Projects

- `u3421we-riser/`: a stackable riser with drawers for the stand of a Dell
  U3421WE monitor. Read `u3421we-riser/DESIGN.md` first: it holds the
  measurements, the decisions made so far, the test-print history, open
  questions and what is planned next.

`PLAN.md` holds the phases: the riser model, the top plate, the designer
website and the links to cydonia. Its section 2 records Alex's decisions.
The website's code lives in its own repository, `riser-designer`; this
repository gives it the meshes and numbers in `u3421we-riser/web/`.

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
- After changing `u3421we-riser/riser.scad`, run
  `python u3421we-riser/tools/riser_build.py check`. It proves that parts
  fit the bed, never overlap, need no supports, and stay the same shape
  at every height apart from a straight middle section. The website
  depends on that last rule, so tie every new feature to the bottom or to
  the top of the module. Then `stl`, `slice` and `web` refresh the files
  made from it.
