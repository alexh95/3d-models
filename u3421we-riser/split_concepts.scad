// Rough proof-of-concept models: ways to split one riser module into
// printable parts and put them back together.
//
// These are block models for comparing strategies. Walls, joints, drawer
// and wedge inserts are placeholders, not the final design.
//
// This file is self-contained. Open it in OpenSCAD, press F5, and use the
// Customizer panel (Window > Customizer) to switch concept and view.
//
// Units: mm.  X = left/right.  +Y = toward the wall (rear).  Z = up.

/* [What to show] */
concept = "A"; // [A:A - two halves, B:B - centre piece and two pods, C:C - two closed halves printed on end]
view = "exploded"; // [assembled, exploded, print plates]
// Add a separate drop-in deck plate under the monitor (concepts A and B)
with_deck = false;
// Show the placeholder drawer and wedge inserts
show_contents = true;
// One part on its own, for export and measuring
part = "all"; // [all, A_left, A_right, B_centre, B_pod, C_left, C_right, deck_left, drawer]

/* [Module] */
// Height from the bottom of the module to the floor of its top pocket.
// This is also how much each stacked module adds.
module_h = 60;
// Wall thickness
wall = 2.4;
// Floor thickness
floor_t = 1.6;
// Half-width of the centre section, to the outside of the drawer bay walls
bay_half = 118;
// Deck thickness, for the drop-in plate and for concept C's built-in deck
deck_t = 2.0;
// Printer bed size, for the "print plates" view
bed = 256;

/* [Seat, from the fit tests] */
// Inside face of the lip, measured inward from the edge of the silver plate
seat_lip_inner_inset = 0.8;
// Lip thickness
seat_lip_w = 1.8;
// Lip height above the pocket floor
seat_lip_h = 4.2;
// Shelf below the lip that the monitor's black body, or the next module, rests on
ledge_w = 5;
// Gap between a module's stepped-in bottom and the lip of the module below
stack_gap = 0.3;

/* [Dell plate outline] */
plate_rear_w = 360.56;
plate_front_w = 247.0;
plate_depth = 235.75;
plate_rear_arc_r = 640;
plate_front_arc_r = 490;
plate_rear_corner_r = 7;
plate_front_corner_r = 3.5;

/* [Hidden] */
_arc_steps = 48;
_fn = 32;
BIG = 500;
eps = 0.01;
joint_gap = 0.2;

// ---------------------------------------------------------------- outline

function plate_rear_sag() =
    plate_rear_arc_r - sqrt(pow(plate_rear_arc_r, 2) - pow(plate_rear_w / 2, 2));
function plate_rear_corner_y() = plate_depth - plate_rear_sag();
function plate_front_y(x) =
    sqrt(pow(plate_front_arc_r, 2) - x * x)
    - sqrt(pow(plate_front_arc_r, 2) - pow(plate_front_w / 2, 2));
function plate_rear_y(x) =
    plate_rear_corner_y()
    + sqrt(pow(plate_rear_arc_r, 2) - x * x)
    - sqrt(pow(plate_rear_arc_r, 2) - pow(plate_rear_w / 2, 2));

module _plate_sharp_2d() {
    hr = plate_rear_w / 2;
    hf = plate_front_w / 2;
    polygon(concat(
        [for (i = [0 : _arc_steps]) let (x = -hr + 2 * hr * i / _arc_steps) [x, plate_rear_y(x)]],
        [for (i = [0 : _arc_steps]) let (x = hf - 2 * hf * i / _arc_steps) [x, plate_front_y(x)]]
    ));
}

module _round_corners(r) {
    offset(r = r, $fn = _fn) offset(r = -r, $fn = _fn) children();
}

// Edge of the Dell's silver plate. inset > 0 shrinks it, inset < 0 grows it.
module plate_outline_2d(inset = 0) {
    mid = plate_rear_corner_y() / 2;
    offset(r = -inset, $fn = _fn) union() {
        intersection() {
            _round_corners(plate_rear_corner_r) _plate_sharp_2d();
            translate([-BIG, mid]) square([2 * BIG, BIG]);
        }
        intersection() {
            _round_corners(plate_front_corner_r) _plate_sharp_2d();
            translate([-BIG, mid - BIG]) square([2 * BIG, BIG]);
        }
    }
}

// --------------------------------------------------------- derived sizes

// How far the riser body stands outside the edge of the silver plate
function body_out() = seat_lip_w - seat_lip_inner_inset;
// Inset of a module's stepped-in bottom, so it drops inside the lip below
function plug_inset() = seat_lip_inner_inset + stack_gap;
// With a drop-in deck the lip has to be taller by the deck's thickness
function lip_h() = seat_lip_h + (with_deck && concept != "C" ? deck_t : 0);
// Height of the stepped-in zone at the bottom of a module
function plug_h() = lip_h() + 0.4;
// Where the wedge sides are left open, front to back
function side_open_y0() = 30;
function side_open_y1() = plate_rear_corner_y() - 30;
// Inside face of the rear wall on the centre line
function rear_inner_y() = plate_rear_y(0) - plug_inset() - wall;

// ------------------------------------------------------------ 2D helpers

module x_range(x0, x1) { translate([x0, -BIG]) square([x1 - x0, 2 * BIG]); }
module y_range(y0, y1) { translate([-BIG, y0]) square([2 * BIG, y1 - y0]); }
module clip_x(x0, x1) {
    intersection() {
        children();
        translate([x0, -BIG, -BIG]) cube([x1 - x0, 2 * BIG, 2 * BIG]);
    }
}

module body_2d() { plate_outline_2d(inset = -body_out()); }
module plug_2d() { plate_outline_2d(inset = plug_inset()); }

// A band following the outline: from outer_inset inward by thickness t.
module band_2d(outer_inset, t) {
    difference() {
        plate_outline_2d(inset = outer_inset);
        plate_outline_2d(inset = outer_inset + t);
    }
}

// Where the outside wall is left open: the drawer front and the wedge sides.
module openings_2d() {
    intersection() {
        x_range(-(bay_half - wall), bay_half - wall);
        y_range(-BIG, plate_rear_corner_y() / 2);
    }
    for (m = [0, 1]) mirror([m, 0])
        intersection() {
            x_range(bay_half, BIG);
            y_range(side_open_y0(), side_open_y1());
        }
}

// Dovetail pointing along +X from the origin.
module dovetail_2d(grow = 0, len = 7, neck = 3, head = 5) {
    offset(delta = grow)
        polygon([[-eps, -neck], [len, -head], [len, head], [-eps, neck]]);
}

// ------------------------------------------------- the module, unsplit

// One whole module: floor, outside walls, bay walls, shelf and lip.
// built_in_deck adds a full deck at pocket-floor level (concept C).
module shell(built_in_deck = false) {
    // Floor, stepped in so it drops inside the lip of the module below
    linear_extrude(floor_t) plug_2d();
    // Outside wall, stepped-in zone
    linear_extrude(plug_h())
        difference() { band_2d(plug_inset(), wall); openings_2d(); }
    // Outside wall, main zone
    translate([0, 0, plug_h() - eps])
        linear_extrude(module_h - plug_h() + eps)
            difference() { band_2d(-body_out(), wall); openings_2d(); }
    // Shelf under the lip
    translate([0, 0, module_h - 4])
        linear_extrude(4)
            difference() {
                band_2d(-body_out(), seat_lip_w + ledge_w);
                openings_2d();
            }
    // Lip
    translate([0, 0, module_h - eps])
        linear_extrude(lip_h() + eps)
            difference() { band_2d(-body_out(), seat_lip_w); openings_2d(); }
    // Drawer bay walls
    for (m = [0, 1]) mirror([m, 0])
        linear_extrude(module_h)
            intersection() { x_range(bay_half - wall, bay_half); plug_2d(); }
    if (built_in_deck)
        translate([0, 0, module_h - deck_t])
            linear_extrude(deck_t) plate_outline_2d(inset = -body_out() + 0.1);
}

// ------------------------------------------- concepts A and C: two halves

// Thick block at the rear where the two halves meet
module seam_block_2d() {
    intersection() {
        translate([-11, rear_inner_y() - 16]) square([22, 40]);
        plug_2d();
    }
}

function seam_joint_ys() = [plate_front_y(0) + plug_inset() + 9, rear_inner_y() - 8];

// side = -1: left half, carries the dovetail tabs. side = +1: right half.
module half(side, built_in_deck = false) {
    ys = seam_joint_ys();
    if (side < 0) {
        clip_x(-BIG, 0) {
            shell(built_in_deck);
            linear_extrude(module_h) seam_block_2d();
        }
        // Flat tab in the floor at the front, full-height tab at the rear
        translate([0, ys[0]]) linear_extrude(floor_t) dovetail_2d();
        translate([0, ys[1]]) linear_extrude(module_h) dovetail_2d();
        if (built_in_deck)
            translate([0, ys[0], module_h - deck_t]) linear_extrude(deck_t) dovetail_2d();
    } else {
        difference() {
            clip_x(0, BIG) {
                shell(built_in_deck);
                linear_extrude(module_h) seam_block_2d();
            }
            translate([0, ys[0], -1]) linear_extrude(floor_t + 2) dovetail_2d(grow = joint_gap);
            translate([0, ys[1], -1]) linear_extrude(module_h + 2) dovetail_2d(grow = joint_gap);
            if (built_in_deck)
                translate([0, ys[0], module_h - deck_t - 1])
                    linear_extrude(deck_t + 2) dovetail_2d(grow = joint_gap);
        }
    }
}

// --------------------------------- concept B: centre piece and two pods

function pod_joint_ys() = [70, 150];
pod_gap = 0.3;

// The drawer bay: floor, two walls, the middle of the rear wall.
module centre_piece() {
    clip_x(-bay_half, bay_half) shell();
    // Upright dovetail rails the pods slide down onto
    for (m = [0, 1]) mirror([m, 0])
        for (y = pod_joint_ys())
            translate([bay_half, y]) linear_extrude(module_h) dovetail_2d(len = 5);
}

// One wedge pod (the right-hand one; mirror it for the left).
module pod() {
    difference() {
        union() {
            clip_x(bay_half + pod_gap, BIG) shell();
            // Low rail along the centre piece
            linear_extrude(module_h / 2)
                intersection() {
                    x_range(bay_half + pod_gap, bay_half + pod_gap + 2);
                    plug_2d();
                }
            // Full-height bosses that carry the dovetail sockets
            for (y = pod_joint_ys())
                translate([bay_half + pod_gap, y - 10])
                    cube([9, 20, module_h]);
        }
        for (y = pod_joint_ys())
            translate([bay_half, y, -1])
                linear_extrude(module_h + 2) dovetail_2d(grow = joint_gap, len = 5.4);
    }
}

// ------------------------------------------------------- drop-in deck

// side = -1 left, +1 right. Lies in the top pocket, on the shelf.
module deck_half(side) {
    ys = [plate_front_y(0) + plug_inset() + 9, plate_rear_y(0) - plug_inset() - 9];
    translate([0, 0, module_h])
        linear_extrude(deck_t)
            if (side < 0) {
                intersection() { plug_2d(); x_range(-BIG, 0); }
                for (y = ys) translate([0, y]) dovetail_2d();
            } else {
                difference() {
                    intersection() { plug_2d(); x_range(0, BIG); }
                    for (y = ys) translate([0, y]) dovetail_2d(grow = joint_gap);
                }
            }
}

// ------------------------------------------------ placeholder contents

// Plain box standing in for the main drawer.
module drawer() {
    h = module_h - floor_t - (concept == "C" ? deck_t : 0) - 1.5;
    translate([0, 0, floor_t + 0.5])
        difference() {
            linear_extrude(h) drawer_2d();
            translate([0, 0, 1.2]) linear_extrude(h) offset(delta = -1.6) drawer_2d();
        }
}
module drawer_2d() {
    intersection() {
        x_range(-(bay_half - wall - 0.6), bay_half - wall - 0.6);
        plate_outline_2d(inset = plug_inset() + wall + 0.6);
        // The front panel sits flush with the body outline
        union() {
            plug_2d();
            y_range(-BIG, 40);
        }
        body_2d();
    }
}

// Plain block standing in for whatever goes in a wedge (right-hand one).
module wedge_insert() {
    translate([0, 0, floor_t + 0.5])
        linear_extrude(module_h - floor_t - 6)
            intersection() {
                x_range(bay_half + pod_gap + 3, BIG);
                y_range(side_open_y0() + 1, side_open_y1() - 1);
                plate_outline_2d(inset = plug_inset() + 0.5);
            }
}

module contents(spread = 0) {
    if (show_contents) {
        color("Tomato") render() translate([0, -spread * 1.2, 0]) drawer();
        color("DarkSeaGreen", 0.6)
            for (m = [0, 1]) mirror([m, 0]) translate([spread * 1.3, 0, 0]) wedge_insert();
    }
}

// --------------------------------------------------------------- views
// Each part is wrapped in render() so the preview shows true solid shapes.
// It makes F5 take a little longer (up to half a minute).

module bed_outline(n) {
    for (i = [0 : n - 1])
        translate([i * (bed + 30), 0, -0.6])
            color("Gainsboro") difference() {
                cube([bed, bed, 0.4]);
                translate([2, 2, -1]) cube([bed - 4, bed - 4, 3]);
            }
}

// Stand a half on its front end, as concept C prints it.
module on_end() {
    translate([0, 0, body_out() + 0.9]) rotate([90, 0, 0]) children();
}

module show_concept() {
    s = view == "exploded" ? 35 : 0;
    lift = view == "exploded" ? 45 : 0;
    if (concept == "A" || concept == "C") {
        color("SteelBlue") render() translate([-s, 0, 0]) half(-1, concept == "C");
        color("LightSkyBlue") render() translate([s, 0, 0]) half(1, concept == "C");
    } else {
        color("SteelBlue") render() centre_piece();
        color("Goldenrod") render() translate([s * 1.6, 0, lift]) pod();
        color("Goldenrod") render() translate([-s * 1.6, 0, lift]) mirror([1, 0]) pod();
    }
    if (with_deck && concept != "C") {
        color("Khaki") render() translate([-s, 0, lift * 1.6]) deck_half(-1);
        color("Khaki") render() translate([s, 0, lift * 1.6]) deck_half(1);
    }
    contents(spread = view == "exploded" ? 90 : 0);
}

module show_plates() {
    pitch = bed + 30;
    cy = bed / 2 - 118;
    if (concept == "A") {
        bed_outline(with_deck ? 4 : 2);
        color("SteelBlue") render() translate([bed / 2 + 87, cy]) half(-1);
        color("LightSkyBlue") render() translate([pitch + bed / 2 - 90, cy]) half(1);
        if (with_deck) {
            color("Khaki") render() translate([2 * pitch + bed / 2 + 87, cy, -module_h]) deck_half(-1);
            color("Khaki") render() translate([3 * pitch + bed / 2 - 90, cy, -module_h]) deck_half(1);
        }
    } else if (concept == "B") {
        bed_outline(with_deck ? 4 : 2);
        color("SteelBlue") render() translate([bed / 2, cy]) centre_piece();
        color("Goldenrod") render() translate([pitch + bed / 2 - 110, cy]) pod();
        color("Goldenrod") render() translate([pitch + bed / 2 + 110, cy]) mirror([1, 0]) pod();
        if (with_deck) {
            color("Khaki") render() translate([2 * pitch + bed / 2 + 87, cy, -module_h]) deck_half(-1);
            color("Khaki") render() translate([3 * pitch + bed / 2 - 90, cy, -module_h]) deck_half(1);
        }
    } else {
        bed_outline(1);
        color("SteelBlue") render() translate([bed / 2 + 87, 100]) on_end() half(-1, true);
        color("LightSkyBlue") render() translate([bed / 2 - 90, 215]) on_end() half(1, true);
    }
}

if (part == "A_left") half(-1);
else if (part == "A_right") half(1);
else if (part == "B_centre") centre_piece();
else if (part == "B_pod") pod();
else if (part == "C_left") half(-1, true);
else if (part == "C_right") half(1, true);
else if (part == "deck_left") deck_half(-1);
else if (part == "drawer") drawer();
else if (view == "print plates") show_plates();
else show_concept();
