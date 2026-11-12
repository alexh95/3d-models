// Interface check: the Dell U3421WE stand base and the seat it drops into.
// Nothing here is the riser design yet; this is only the monitor's base as
// measured, and the top few millimetres of the part it will sit on.
//
// This file is self-contained: it needs no other files next to it.
// Open it in OpenSCAD, press F5, and switch "view" in the Customizer panel
// (Window > Customizer).
//
// Units: mm.  X = left/right.  +Y = toward the wall (rear).
// The two front corners of the plate sit on Y = 0, centred on X = 0.

/* [What to show] */
view = "exploded"; // [exploded, seated, section, seat only, dell base only, outline only]

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

/* [Dell base, as measured] */
// The silver top plate overhangs the black lower body by about this much
dell_overhang = 2.0;
// Height of the black body below the overhang: 6 credit cards x 0.76 mm
dell_black_h = 4.56;
// Thickness of the top plate. Display only, nothing depends on it.
dell_plate_t = 6;

/* [Seat on the top module] */
// Width of the lip that tucks under the overhang. Kept well under the
// overhang so the black body cannot bind in the pocket.
seat_lip_w = 1.2;
// Height of the lip: 5 credit cards, leaving 1 card of air under the overhang
seat_lip_h = 3.8;
// Deck thickness. Display only for now.
seat_deck_t = 2.0;

/* [Hidden] */
_arc_steps = 96;

// ---------------------------------------------------------------- outline
// Widths and depth above are measured to the sharp corners, before the
// corner rounding. After rounding the plate is 357.5 x 235.0 overall,
// which is Dell's published size.

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

// ------------------------------------------------------------------ parts

// Slices the right-hand half away in the "section" view, so the edge
// profile can be seen end-on.
module section_cut() {
    if (view == "section")
        difference() {
            children();
            translate([0, -50, -50]) cube([400, 400, 200]);
        }
    else
        children();
}

// The Dell base, standing on Z = 0 (rubber feet ignored).
module dell_base() {
    color("DimGray") section_cut()
        linear_extrude(dell_black_h)
            plate_outline_2d(inset = dell_overhang);
    color("Silver") section_cut()
        translate([0, 0, dell_black_h])
            linear_extrude(dell_plate_t)
                plate_outline_2d();
}

// Top of the riser: a flat deck with a low lip round the edge.
// The outside of the lip is exactly the Dell plate outline.
module seat() {
    color("SteelBlue") section_cut() {
        translate([0, 0, -seat_deck_t])
            linear_extrude(seat_deck_t)
                plate_outline_2d();
        linear_extrude(seat_lip_h)
            difference() {
                plate_outline_2d();
                plate_outline_2d(inset = seat_lip_w);
            }
    }
}

if (view == "exploded") {
    seat();
    translate([0, 0, 40]) dell_base();
} else if (view == "seated") {
    seat();
    dell_base();
} else if (view == "section") {
    seat();
    dell_base();
} else if (view == "seat only") {
    seat();
} else if (view == "dell base only") {
    dell_base();
} else {
    plate_outline_2d();
}

echo(str("Clearance under the overhang: ", dell_black_h - seat_lip_h, " mm"));
echo(str("Side play of the black body in the pocket: ", dell_overhang - seat_lip_w, " mm each side"));
