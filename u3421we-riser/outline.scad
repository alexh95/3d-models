// Dell U3421WE stand base: outline of the top plate, seen from above.
// Confirmed against Dell's "Outline Dimension" drawing and the real part.
//
// Units: mm.  X = left/right.  +Y = toward the wall (rear).
// The two front corners sit on Y = 0, the plate is centred on X = 0.
//
// The widths/depth below are measured to the *sharp* corners, i.e. before the
// corner rounding is applied. After rounding, the plate measures
// 357.5 wide x 235.0 deep overall, which is Dell's published size.

/* [Dell plate outline] */
// Width across the rear corners, before rounding
plate_rear_w = 360.56;
// Width across the front corners, before rounding
plate_front_w = 247.0;
// Rear arc apex to front corners, before rounding
plate_depth = 235.75;
// Rear edge radius (bows out toward the wall)
plate_rear_arc_r = 640;
// Front edge radius (hollow, curves away from you)
plate_front_arc_r = 490;
// Rear corner radius
plate_rear_corner_r = 7;
// Front corner radius
plate_front_corner_r = 3.5;

/* [Hidden] */
_arc_steps = 96;

// How far the rear edge bows out past the rear corners
function plate_rear_sag() =
    plate_rear_arc_r - sqrt(pow(plate_rear_arc_r, 2) - pow(plate_rear_w / 2, 2));
// How far the front edge is hollowed in at the centre line
function plate_front_sag() =
    plate_front_arc_r - sqrt(pow(plate_front_arc_r, 2) - pow(plate_front_w / 2, 2));
// Y of the two rear corners
function plate_rear_corner_y() = plate_depth - plate_rear_sag();
// Y of the front edge at a given X (the hollow arc)
function plate_front_y(x) =
    sqrt(pow(plate_front_arc_r, 2) - x * x)
    - sqrt(pow(plate_front_arc_r, 2) - pow(plate_front_w / 2, 2));
// Y of the rear edge at a given X (the bowed arc)
function plate_rear_y(x) =
    plate_rear_corner_y()
    + sqrt(pow(plate_rear_arc_r, 2) - x * x)
    - sqrt(pow(plate_rear_arc_r, 2) - pow(plate_rear_w / 2, 2));
// Half-width of the plate at a given Y (the straight sides)
function plate_half_w(y) =
    plate_front_w / 2 + (plate_rear_w - plate_front_w) / 2 * y / plate_rear_corner_y();
// Angle of each side from the front-to-back direction, degrees
function plate_side_angle() =
    atan((plate_rear_w - plate_front_w) / 2 / plate_rear_corner_y());

module _plate_sharp_2d() {
    hr = plate_rear_w / 2;
    hf = plate_front_w / 2;
    polygon(concat(
        [for (i = [0 : _arc_steps]) let (x = -hr + 2 * hr * i / _arc_steps) [x, plate_rear_y(x)]],
        [for (i = [0 : _arc_steps]) let (x = hf - 2 * hf * i / _arc_steps) [x, plate_front_y(x)]]
    ));
}

module _round_corners(r) {
    offset(r = r, $fn = 64) offset(r = -r, $fn = 64) children();
}

// The plate outline. inset > 0 shrinks it evenly all round (inset < 0 grows it).
module plate_outline_2d(inset = 0) {
    mid = plate_rear_corner_y() / 2;
    big = plate_rear_w + plate_depth;
    offset(r = -inset, $fn = 64) union() {
        intersection() {
            _round_corners(plate_rear_corner_r) _plate_sharp_2d();
            translate([-big, mid]) square([2 * big, big]);
        }
        intersection() {
            _round_corners(plate_front_corner_r) _plate_sharp_2d();
            translate([-big, mid - big]) square([2 * big, big]);
        }
    }
}

// Opened on its own, this file just shows the outline.
plate_outline_2d();
