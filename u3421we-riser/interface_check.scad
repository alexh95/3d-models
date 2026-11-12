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
view = "exploded"; // [exploded, seated, section, seat only, dell base only, outline only, fit test: assembled, fit test: with dell base, fit test: left half, fit test: right half]

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
// The silver top plate overhangs the black lower body by this much. Found
// with the first fit-test ring: a lip reaching 1.2 inside the plate edge
// touched the black body with no play.
dell_overhang = 1.2;
// Height of the black body below the overhang: 6 credit cards x 0.76 mm.
// The first fit test suggests it is really a little more than this.
dell_black_h = 4.56;
// Thickness of the top plate. Display only, nothing depends on it.
dell_plate_t = 6;

/* [Seat on the top module] */
// Where the inside face of the lip sits, measured inward from the edge of
// the silver plate. The black body is dell_overhang inside that edge, so
// the side play is dell_overhang minus this.
seat_lip_inner_inset = 0.2;
// Thickness of the lip. Its outside face ends up this much, minus the inset
// above, outside the edge of the silver plate.
seat_lip_w = 1.8;
// Height of the lip above the pocket floor
seat_lip_h = 4.2;
// Radius of the two fillets on the inside of the lip: a round-over on its
// top inside edge and a cove where it meets the pocket floor. They guide
// the base into place as it drops in.
seat_fillet_r = 0.6;
// Deck thickness. Display only for now.
seat_deck_t = 2.0;

/* [Fit-test ring] */
// Thickness of the flat band the lip stands on
test_band_t = 1.2;
// Width of the band, measured inward from the edge of the silver plate
test_band_w = 10;
// Radius of the wider patch at each corner, for the rubber feet to land on
test_corner_pad_r = 45;
// Gap left around the dovetail that joins the two halves. Raise it if the
// halves will not press together, lower it if they are loose.
test_joint_gap = 0.2;

/* [Hidden] */
_arc_steps = 96;
// Height of the slices the two fillets are built from
_fillet_dz = 0.1;

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

// Ring between two insets of the plate outline.
module outline_ring_2d(outer_inset, inner_inset) {
    difference() {
        plate_outline_2d(inset = outer_inset);
        plate_outline_2d(inset = inner_inset);
    }
}

// Outside face of the lip, as an inset from the edge of the silver plate.
// Negative means outside the plate edge. This is also the outline of the
// riser body.
function seat_lip_outer_inset() = seat_lip_inner_inset - seat_lip_w;

// The riser's own outline: the Dell plate outline grown to the outside
// face of the lip.
module body_outline_2d() {
    plate_outline_2d(inset = seat_lip_outer_inset());
}

// The lip that surrounds the black lower body of the Dell base.
// Stands on Z = 0, the pocket floor.
module seat_lip() {
    r = max(0, min(seat_fillet_r, seat_lip_w - 0.4, seat_lip_h / 2));
    n = r > 0 ? ceil(r / _fillet_dz) : 0;
    dz = n > 0 ? r / n : 0;
    outer = seat_lip_outer_inset();
    // Straight middle part
    translate([0, 0, r])
        linear_extrude(seat_lip_h - 2 * r)
            outline_ring_2d(outer, seat_lip_inner_inset);
    for (i = [0 : 1 : n - 1]) {
        zm = (i + 0.5) * dz;
        // Cove at the foot of the lip: reaches out over the pocket floor
        cove = r - sqrt(r * r - pow(r - zm, 2));
        translate([0, 0, i * dz])
            linear_extrude(dz)
                outline_ring_2d(outer, seat_lip_inner_inset + cove);
        // Round-over on the top inside edge
        back = r - sqrt(r * r - zm * zm);
        translate([0, 0, seat_lip_h - r + i * dz])
            linear_extrude(dz)
                outline_ring_2d(outer, seat_lip_inner_inset - back);
    }
}

// Top of the riser: a flat deck with the lip round the edge.
module seat() {
    color("SteelBlue") section_cut() {
        translate([0, 0, -seat_deck_t])
            linear_extrude(seat_deck_t)
                body_outline_2d();
        seat_lip();
    }
}

// ---------------------------------------------------------- fit-test ring
// A throw-away print for checking the seat against the real monitor base:
// the same lip as the riser will have, on a narrow flat band instead of a
// full deck. Split down the centre line so each half fits the P1S bed, and
// joined by a dovetail at the front and the rear.

_test_joint_len = 7;       // how far the dovetail reaches across the seam
_test_joint_neck = 3;      // half-width at the seam
_test_joint_head = 5;      // half-width at the far end
_test_seam_pad_w = 18;     // band width next to the seam
_test_seam_pad_l = 14;     // how far that wider band runs each side of the seam

function _test_joint_inset() = seat_lip_inner_inset + seat_fillet_r + 2 + _test_joint_head;
// Y of the two dovetails: [front, rear]
function _test_joint_ys() = [
    plate_front_y(0) + _test_joint_inset(),
    plate_rear_y(0) - _test_joint_inset()
];

module _test_dovetail_2d(grow = 0) {
    offset(delta = grow)
        polygon([
            [-0.01, -_test_joint_neck], [_test_joint_len, -_test_joint_head],
            [_test_joint_len, _test_joint_head], [-0.01, _test_joint_neck]
        ]);
}

// Flat band: narrow along the edges, wider at the corners and at the seam.
module _test_band_2d() {
    corners = [
        [-plate_rear_w / 2, plate_rear_corner_y()], [plate_rear_w / 2, plate_rear_corner_y()],
        [-plate_front_w / 2, 0], [plate_front_w / 2, 0]
    ];
    outline_ring_2d(seat_lip_outer_inset(), test_band_w);
    intersection() {
        body_outline_2d();
        union() {
            for (c = corners) translate(c) circle(r = test_corner_pad_r, $fn = 64);
            translate([-_test_seam_pad_l, plate_front_y(0) - 5])
                square([2 * _test_seam_pad_l, _test_seam_pad_w + 5]);
            translate([-_test_seam_pad_l, plate_rear_y(0) - _test_seam_pad_w])
                square([2 * _test_seam_pad_l, _test_seam_pad_w + 5]);
        }
    }
}

// One half of the ring. side = -1 is the left half (it carries the
// dovetail tabs), side = +1 the right half (it carries the sockets).
// The pocket floor is at Z = 0, as in the other views.
module test_ring_half(side) {
    big = plate_rear_w + plate_depth;
    translate([0, 0, -test_band_t])
        linear_extrude(test_band_t) {
            if (side < 0) {
                intersection() {
                    _test_band_2d();
                    translate([-big, -big]) square([big, 2 * big]);
                }
                for (y = _test_joint_ys()) translate([0, y]) _test_dovetail_2d();
            } else {
                difference() {
                    intersection() {
                        _test_band_2d();
                        translate([0, -big]) square([big, 2 * big]);
                    }
                    for (y = _test_joint_ys())
                        translate([0, y]) _test_dovetail_2d(grow = test_joint_gap);
                }
            }
        }
    intersection() {
        seat_lip();
        translate([side < 0 ? -big : 0, -big, -1]) cube([big, 2 * big, seat_lip_h + 2]);
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
} else if (view == "outline only") {
    plate_outline_2d();
} else if (view == "fit test: assembled") {
    color("SteelBlue") test_ring_half(-1);
    color("LightSkyBlue") test_ring_half(1);
} else if (view == "fit test: with dell base") {
    color("SteelBlue") test_ring_half(-1);
    color("LightSkyBlue") test_ring_half(1);
    %dell_base();
} else if (view == "fit test: left half") {
    // As printed: band flat on the bed, lip up
    translate([0, 0, test_band_t]) test_ring_half(-1);
} else if (view == "fit test: right half") {
    translate([0, 0, test_band_t]) test_ring_half(1);
}

echo(str("Air between the top of the lip and the overhang: at least ", dell_black_h - seat_lip_h, " mm"));
echo(str("Side play of the black body in the pocket: ", dell_overhang - seat_lip_inner_inset, " mm each side"));
echo(str("Lip stands ", -seat_lip_outer_inset(), " mm outside the edge of the silver plate"));
