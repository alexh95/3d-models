// Riser for the Dell U3421WE: the printable parts.
//
// One module of the riser (two body halves, a main drawer and two swivelling
// wedge drawers) and the stackable top plate. The height of a module is a
// parameter; everything else is tied either to the bottom or to the top of
// the module, so a taller module is the same shape with a longer straight
// middle section.
//
// This file is self-contained: it needs no other files next to it.
// Open it in OpenSCAD, press F5, and use the Customizer panel
// (Window > Customizer) to switch view, part and height. F6 is slow in
// OpenSCAD 2021.01; ready-made STLs are in the stl/ folder.
//
// Units: mm.  X = left/right.  +Y = toward the wall (rear).  Z = up.
// Z = 0 is the underside of a module or plate.

/* [What to show] */
view = "exploded"; // [assembled, exploded, open, stack, print plates]
// One part on its own, for export. "all" shows the view chosen above.
part = "all"; // [all, body_left, body_right, drawer, wedge_left, wedge_right, plate_left, plate_right, dell_black, dell_plate, test_step_left, test_step_right, test_hub_body, test_hub_drawer, test_front_left, test_front_right, test_front_drawer, test_stop_body, test_stop_drawer, test_seam_left, test_seam_right]

/* [Module] */
// Height from the underside of the module to the floor of its top pocket.
// This is also how much each stacked module adds.
module_h = 60; // [30:1:200]
// How the main drawer is opened
drawer_front = "scoop"; // [scoop, plain]
// What goes in the left wedge
wedge_left = "swivel"; // [swivel, open]
// What goes in the right wedge
wedge_right = "swivel"; // [swivel, open]

/* [Top plate] */
// Height from the underside of the plate to the floor of its top pocket.
// This is also how much each stacked plate adds. 7 is the least.
plate_h = 8; // [7:0.5:20]

/* [Stack view] */
// Number of modules in the "stack" view
stack_modules = 2; // [1:1:5]
// Number of top plates on the stack
stack_plates = 1; // [0:1:4]

/* [Walls and fits] */
// Wall thickness of the body
wall = 2.4;
// Floor thickness of the body
floor_t = 1.6;
// Half-width of the centre section, to the outside of the drawer bay walls
bay_half = 118;
// Play of a drawer against the walls beside it
slide_gap = 0.6;
// Play between the top of a drawer and whatever stands on the module
top_gap = 0.6;
// Gap left around the dovetails that join two halves
joint_gap = 0.2;
// Cut holes in the floor between the runners, to save filament
floor_lightening = true;

/* [Seat, from the fit tests] */
// Where the inside face of the lip sits, measured inward from the edge of
// the silver plate. The monitor's black body is 1.2 inside that edge, so
// 0.8 leaves 0.4 of play each side (0.2 was too loose, 1.2 had no play).
seat_lip_inner_inset = 0.8;
// Thickness of the lip
seat_lip_w = 1.8;
// Height of the lip above the pocket floor
seat_lip_h = 4.2;
// Radius of the two fillets on the inside of the lip
seat_fillet_r = 0.6;
// Shelf below the lip that the monitor's black body, or the next module,
// rests on
ledge_w = 5;
// Gap between a module's stepped-in bottom and the lip of the part below
stack_gap = 0.3;

/* [Main drawer] */
// Wall thickness of the drawer's sides and rear
drawer_wall = 1.2;
// Thickness of the drawer's front panel
drawer_front_t = 2.0;
// Floor thickness of the drawer
drawer_floor = 1.0;
// Width of the finger scoop in the top edge of the front panel
scoop_w = 40;
// Depth of the finger scoop
scoop_d = 14;
// Springy tongues near the back that stop the drawer from coming right out
drawer_stop = true;
// Where the stop grooves in the bay walls begin, from the front corners.
// Smaller lets the drawer come out further.
drawer_stop_y = 20;

/* [Wedge drawers] */
// Where the pivot sits along the side, from the front corners
wedge_pivot_y = 40;
// Radius of the round hub the drawer turns on
wedge_hub_r = 7;
// Diameter of the upright post in the body
wedge_post_d = 7.4;
// Length of side wall left standing at the rear corner
wedge_rear_wrap = 14;
// How far the drawer swings out, degrees
wedge_swing = 60;
// Wall thickness of the wedge drawer
wedge_wall = 1.8;
// Floor thickness of the wedge drawer
wedge_floor = 1.2;
// Width of the finger notch in the top edge of the outside wall
wedge_notch_w = 26;
// Depth of the finger notch
wedge_notch_d = 12;
// Height of the bump that holds a wedge drawer shut. 0 leaves it out.
wedge_detent_h = 0.4;

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
// The silver top plate overhangs the black lower body by this much
dell_overhang = 1.2;
// Height of the black body below the overhang
dell_black_h = 4.56;
// Thickness of the top plate. Display only.
dell_plate_t = 6;

/* [Printer] */
// Bed size, for the "print plates" view
bed = 256;

/* [Hidden] */
// Points along each arc of the outline
_arc_steps = 32;
// Facets of a full circle, for corners and offsets
_fn = 48;
// Height of the steps that 45 degree faces and fillets are built from.
// 0.2 is the layer height the parts are printed at.
_dz = 0.2;
BIG = 600;
// For the interference checks in tools/: "a|b" draws only what parts a and
// b have in common, with the drawers open by the fraction _f.
_check = "";
_f = 0;
// For the overhang check: instead of a part, draw every patch of it that
// has nothing underneath and is wider than twice _overhang_min.
_overhang = false;
_overhang_min = 0.35;

H = module_h;

// How far the drawers are drawn open: 0 closed, 1 fully open
_open = _check != "" ? _f : view == "open" ? 1 : 0;

// ================================================================ helpers

function _qsort(v) = len(v) <= 1 ? v :
    let (p = v[floor(len(v) / 2)])
    concat(_qsort([for (x = v) if (x < p) x]),
           [for (x = v) if (x == p) x],
           _qsort([for (x = v) if (x > p) x]));
function _uniq(v, tol = 0.001) =
    [for (i = [0 : len(v) - 1]) if (i == 0 || v[i] - v[i - 1] > tol) v[i]];
// The levels in v that lie between lo and hi, sorted, with lo and hi added
function _levels(v, lo, hi) =
    _uniq(_qsort(concat([lo, hi], [for (z = v) if (z > lo && z < hi) z])));
// z0 to z1 in steps of about dz
function _steps(z0, z1, dz = _dz) =
    z1 - z0 < 0.001 ? [z0] :
    let (n = max(1, ceil((z1 - z0) / dz - 0.001)))
    [for (i = [0 : n]) z0 + (z1 - z0) * i / n];

// Height z snapped to the middle of its step between z0 and z1, on the
// same steps as _steps(z0, z1). Every sloped or rounded feature reads its
// own height through this, so it comes out the same whatever else splits
// the slabs around it, and so at every module height.
function _q(z, z0, z1, dz = _dz) =
    z1 - z0 < 0.001 ? z0 :
    let (n = max(1, ceil((z1 - z0) / dz - 0.001)),
         k = min(n - 1, max(0, floor((z - z0) / (z1 - z0) * n))))
    z0 + (k + 0.5) * (z1 - z0) / n;

// A part is a pile of flat slabs. Each slab is the 2D shape its child
// draws for the height $z in the middle of the slab. Everything that
// changes with height (45 degree faces, fillets, grooves) is done this
// way, so the 3D tree is nothing but straight extrusions.
module slabs(levels) {
    for (i = [0 : len(levels) - 2]) {
        $z = (levels[i] + levels[i + 1]) / 2;
        translate([0, 0, levels[i]])
            linear_extrude(levels[i + 1] - levels[i])
                children();
    }
}

// What a part would need support for: at each level, the slab above
// minus the slab below, with thin slivers (the steps of a 45 degree face)
// removed.
module overhang_patches(levels) {
    for (i = [1 : len(levels) - 2]) {
        za = (levels[i - 1] + levels[i]) / 2;
        zb = (levels[i] + levels[i + 1]) / 2;
        translate([0, 0, levels[i]]) linear_extrude(0.05)
            offset(delta = -_overhang_min) difference() {
                union() { $z = zb; children(); }
                union() { $z = za; children(); }
            }
    }
}
module build(levels) {
    if (_overhang) overhang_patches(levels) children();
    else slabs(levels) children();
}

module x_range(x0, x1) { translate([x0, -BIG]) square([x1 - x0, 2 * BIG]); }
module y_range(y0, y1) { translate([-BIG, y0]) square([2 * BIG, y1 - y0]); }
module both_sides() { children(); mirror([1, 0]) children(); }

// Half-width of a slot with a rounded bottom, at height z. The slot is
// w wide and d deep, measured down from top, with bottom corners of
// radius r.
function slot_half_w(z, top, w, d, r) =
    z >= top - d + r ? w / 2 :
    z <= top - d ? 0 :
    w / 2 - r + sqrt(r * r - pow(top - d + r - _q(z, top - d, top - d + r), 2));

// ================================================================ outline
// Widths and depth are measured to the sharp corners, before the corner
// rounding. After rounding the plate is 357.5 x 235.0 overall.

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

// A band following the outline: from outer_inset inward by thickness t.
module band_2d(outer_inset, t) {
    difference() {
        plate_outline_2d(inset = outer_inset);
        plate_outline_2d(inset = outer_inset + t);
    }
}

// =================================================== the outside skin
// Every part that shows on the outside follows the same section. From
// the underside up: a stepped-in zone that drops inside the lip of the
// part below, a 45 degree flare out to the full outline, then the full
// outline.

// How far the body stands outside the edge of the silver plate
function body_out() = seat_lip_w - seat_lip_inner_inset;
// Inset of the stepped-in zone
function plug_inset() = seat_lip_inner_inset + stack_gap;
// Height of the stepped-in zone. Nothing that moves reaches below this.
function plug_h() = seat_lip_h + 0.4;
function step_w() = plug_inset() + body_out();
function flare_top() = plug_h() + step_w();
// Small 45 degree bevel on the bottom edge
foot_bevel = 0.6;

// Inset of the outside face at height z above the underside
function skin_inset(z) =
    z < foot_bevel ? plug_inset() + (foot_bevel - _q(z, 0, foot_bevel)) :
    z <= plug_h() ? plug_inset() :
    z >= flare_top() ? -body_out() :
    plug_inset() - (_q(z, plug_h(), flare_top()) - plug_h());
function skin_levels() =
    concat(_steps(0, foot_bevel), _steps(plug_h(), flare_top()));

// The lip that surrounds the monitor's black body, or the stepped-in
// zone of the next part. zl is the height above the pocket floor.
function lip_r() = max(0, min(seat_fillet_r, seat_lip_w - 0.4, seat_lip_h / 2));
function lip_inner_inset(zl) =
    let (r = lip_r(), top = seat_lip_h - r)
    zl < r ? seat_lip_inner_inset + r - sqrt(r * r - pow(r - _q(zl, 0, r), 2)) :
    zl > top ? seat_lip_inner_inset - (r - sqrt(r * r - pow(_q(zl, top, seat_lip_h) - top, 2))) :
    seat_lip_inner_inset;
function lip_levels(z0) =
    concat(_steps(z0, z0 + lip_r()), _steps(z0 + seat_lip_h - lip_r(), z0 + seat_lip_h));
module lip_2d(zl) {
    difference() {
        plate_outline_2d(inset = -body_out());
        plate_outline_2d(inset = lip_inner_inset(zl));
    }
}

// Dovetail pointing along +X from the origin.
module dovetail_2d(grow = 0, len = 7, neck = 3, head = 5) {
    offset(delta = grow)
        polygon([[-0.01, -neck], [len, -head], [len, head], [-0.01, neck]]);
}

// One half of a part that is split on the centre line. The child draws
// the whole part; the second child draws the dovetails that cross the
// seam at this height. side = -1: left half, with the tabs. side = +1:
// right half, with the sockets.
module half_2d(side) {
    if (side < 0) {
        intersection() { children(0); x_range(-BIG, 0); }
        children(1);
    } else {
        difference() {
            intersection() { children(0); x_range(0, BIG); }
            offset(delta = joint_gap) children(1);
        }
    }
}

// ============================================================ top plate

function plate_joint_ys() = [
    plate_front_y(0) + plug_inset() + 14,
    (plate_front_y(0) + plate_rear_y(0)) / 2,
    plate_rear_y(0) - plug_inset() - 14
];
function plate_levels() =
    _levels(concat(skin_levels(), lip_levels(plate_h)), 0, plate_h + seat_lip_h);

module plate_2d() {
    if ($z < plate_h) plate_outline_2d(inset = skin_inset($z));
    else lip_2d($z - plate_h);
}
module plate_joints_2d() {
    if ($z < plate_h) for (y = plate_joint_ys()) translate([0, y]) dovetail_2d();
}
module plate_half(side) {
    build(plate_levels()) half_2d(side) { plate_2d(); plate_joints_2d(); }
}

// ============================================================ the body

// Shelf under the lip. Its underside rises at 45 degrees from the wall.
shelf_t = 1.6;
function shelf_w() = seat_lip_w + ledge_w;
function shelf_z0() = H - shelf_t - (shelf_w() - wall);
function wall_w(z) =
    z <= shelf_z0() ? wall :
    z >= H - shelf_t ? shelf_w() :
    wall + (_q(z, shelf_z0(), H - shelf_t) - shelf_z0());

// Inside face of the drawer bay walls
function bay_in() = bay_half - wall;

// ---- wedge drawer geometry, right-hand side (the left is a mirror image)

function side_phi() = plate_side_angle();
// Along the side, toward the rear
function side_u() = [sin(side_phi()), cos(side_phi())];
// Square to the side, pointing out
function side_n() = [cos(side_phi()), -sin(side_phi())];
// X of the body's outside face at a given Y, along the straight side
function side_face_x(y) =
    plate_front_w / 2 + y * tan(side_phi()) + body_out() / cos(side_phi());
// Where the hub touches the outside face
function wedge_foot() = [side_face_x(wedge_pivot_y), wedge_pivot_y];
// Centre of the post
function wedge_pivot() = wedge_foot() - wedge_hub_r * side_n();
// Where the opening in the side wall ends, at the rear
function wedge_far() =
    let (y = plate_rear_corner_y() - wedge_rear_wrap) [side_face_x(y), y];
// Radius of the drawer's rear end, measured from the post
function wedge_R() = norm(wedge_far() - wedge_pivot());
// Length of the drawer's outside wall
function wedge_face_len() = norm(wedge_far() - wedge_foot());
// Play between the drawer and the body where one turns past the other
wedge_gap = 0.5;
// Play between the drawer and the bay wall when shut
wedge_side_gap = 0.4;
// The stop: a rib on the hub meets a buttress on the bay wall. stop_y is
// the buttress's front face, measured from the post toward the rear.
stop_y = 1.0;
stop_len = 3.5;
lug_t = 3.0;
function lug_len() = wedge_pivot()[0] - bay_half - wedge_hub_r - 0.8;
// The drawer's bay-side wall begins this far behind the post
function wedge_shoulder() = stop_y + stop_len + 1.0;
// Thin wall that closes the dead corner behind the drawer
arc_wall_t = 1.6;
// Runner rails under the wedge drawer, as fractions of its radius
function wedge_rail_rs() = [0.42 * wedge_R(), 0.78 * wedge_R()];
// The bump that holds the drawer shut sits on the outer rail, just
// inside the drawer's bay-side wall
function wedge_detent_at() =
    let (r = wedge_rail_rs()[1],
         x = -(wedge_pivot()[0] - bay_half - wedge_side_gap) + wedge_wall + 3.5)
    wedge_pivot() + [x, sqrt(r * r - x * x)];

module at_pivot() { translate(wedge_pivot()) children(); }
// Everything behind the line through the post, square to the side
module wedge_rear_half_2d() {
    at_pivot() rotate(-side_phi()) translate([-BIG, 0]) square([2 * BIG, BIG]);
}
// The drawer's hub and the first few millimetres of its outside wall, in
// a frame at the post with X pointing out and Y along the side. Only
// this much of the wall ever turns into the corner in front of the hub.
module wedge_heel_2d() {
    circle(r = wedge_hub_r, $fn = _fn);
    translate([-wedge_hub_r, 0])
        square([2 * wedge_hub_r, wedge_hub_r * tan(wedge_swing / 2) + 0.5]);
}
// What the turning drawer needs kept clear in the outside wall
module wedge_cut_2d() {
    n = ceil(wedge_swing / 3);
    intersection() {
        x_range(bay_half, BIG);
        union() {
            offset(delta = wedge_gap) at_pivot() rotate(-side_phi())
                for (k = [0 : n]) rotate(-wedge_swing * k / n) wedge_heel_2d();
            intersection() {
                at_pivot() circle(r = wedge_R() + wedge_gap, $fn = 4 * _fn);
                wedge_rear_half_2d();
            }
        }
    }
}

// ---- main drawer stop: a groove in each bay wall for the tongue's bump

// The drawer's rear is straight. It stops 1 mm short of the shelf on the
// rear wall, where that comes closest (beside the bay walls).
function drawer_rear_y() =
    plate_rear_y(bay_in())
    - (ledge_w + seat_lip_inner_inset) / cos(asin(bay_in() / plate_rear_arc_r))
    - 1.0;
// Centre of the tongue, along the drawer's side
function tongue_y() = drawer_rear_y() - 26;
tongue_w = 8;
tongue_len = 16;
tongue_slot = 1.0;
bump_h = 1.4;
bump_len = 5;
function tongue_z0() = plug_h() + drawer_floor + 0.8;
function tongue_z1() = tongue_z0() + tongue_len;
function bump_z0() = tongue_z1() - 6;
function bump_z1() = tongue_z1() - 1;
// Depth of the groove: the bump clears its floor by 0.2
function groove_d() = bump_h - slide_gap + 0.2;
function groove_z0() = bump_z0() - 0.5;
function groove_z1() = bump_z1() + 0.5;
function groove_y1() = tongue_y() + bump_len / 2 + 1.0;
// How far the main drawer comes out before the stop
function drawer_travel() =
    drawer_stop ? tongue_y() - bump_len / 2 - drawer_stop_y : drawer_rear_y() - 60;
// A small hump in the groove holds the drawer shut
detent_h = 0.6;

module groove_2d() {
    z = $z;
    d = z <= groove_z1() ? groove_d() :
        groove_d() - (_q(z, groove_z1(), groove_z1() + groove_d()) - groove_z1());
    if (drawer_stop && z > groove_z0() && z < groove_z1() + groove_d()) both_sides() {
        yd = tongue_y() - bump_len / 2 - 2.0;
        difference() {
            translate([bay_in() - 0.01, drawer_stop_y])
                square([d + 0.01, groove_y1() - drawer_stop_y]);
            polygon([[bay_in() + d + 0.01, yd - 2], [bay_in() + d - detent_h, yd],
                     [bay_in() + d + 0.01, yd + 2]]);
        }
    }
}

// ---- floor

rail_xs = [16, 48, 80];
rail_w = 2.4;

function floor_hole_y0() = plate_front_y(0) + plug_inset() + wall + 8;
function floor_hole_y1() = drawer_rear_y() - 10;

module floor_holes_2d() {
    edges = concat(rail_xs, [bay_in() - 5]);
    ya = floor_hole_y0();
    yb = floor_hole_y1();
    ym = (ya + yb) / 2;
    if (floor_lightening) both_sides()
        for (i = [0 : len(edges) - 2])
            for (seg = [[ya, ym - 6], [ym + 6, yb]])
                offset(r = 4, $fn = 24) offset(delta = -4)
                    translate([edges[i] + rail_w / 2 + 3, seg[0]])
                        square([edges[i + 1] - edges[i] - rail_w - 6, seg[1] - seg[0]]);
}

// ---- seam

function body_joint_ys() = [
    plate_front_y(0) + plug_inset() + wall + 12,
    (plate_front_y(0) + plate_rear_y(0)) / 2
];
// Full-height dovetail on a block at the rear wall
seam_block_d = 10;
function seam_block_y1() = plate_rear_y(0) - plug_inset() - wall;
function seam_joint_y() = seam_block_y1() - seam_block_d / 2;

module body_joints_2d() {
    if ($z < floor_t) for (y = body_joint_ys()) translate([0, y]) dovetail_2d();
    if ($z < H) translate([0, seam_joint_y()]) dovetail_2d(len = 5, neck = 2, head = 3.5);
}

// ---- the whole body at height $z

module openings_2d() {
    // The main drawer's front
    intersection() {
        x_range(-bay_in(), bay_in());
        y_range(-BIG, plate_rear_corner_y() / 2);
    }
    // The wedge drawers' sides
    wedge_cut_2d();
    mirror([1, 0]) wedge_cut_2d();
}

module body_inner_2d() {
    z = $z;
    inside = skin_inset(z) + wall / 2;
    // Drawer bay walls
    both_sides() intersection() {
        x_range(bay_in(), bay_half);
        plate_outline_2d(inset = inside);
    }
    // Block that carries the rear dovetail
    intersection() {
        translate([-4, seam_block_y1() - seam_block_d]) square([12, seam_block_d + wall]);
        plate_outline_2d(inset = inside);
    }
    both_sides() {
        // Stop buttress for the wedge drawer
        translate([bay_half - 0.1, wedge_pivot()[1] + stop_y])
            square([wedge_pivot()[0] - wedge_hub_r - wedge_gap - bay_half + 0.1, stop_len]);
        // Wall that closes the dead corner behind the wedge drawer
        intersection() {
            difference() {
                at_pivot() circle(r = wedge_R() + wedge_gap + arc_wall_t, $fn = 4 * _fn);
                at_pivot() circle(r = wedge_R() + wedge_gap, $fn = 4 * _fn);
            }
            x_range(bay_half - 0.1, BIG);
            wedge_rear_half_2d();
            plate_outline_2d(inset = inside);
        }
    }
}

module body_low_2d() {
    inside = plug_inset() + wall / 2;
    // Runners for the main drawer, and a ledge along each bay wall
    both_sides() intersection() {
        union() {
            for (x = rail_xs) x_range(x - rail_w / 2, x + rail_w / 2);
            x_range(bay_in() - 5, bay_in() + 0.1);
        }
        plate_outline_2d(inset = inside);
    }
    // Rails for the wedge drawers, on arcs about the post
    both_sides() intersection() {
        union() for (r = wedge_rail_rs()) difference() {
            at_pivot() circle(r = r + rail_w / 2, $fn = 4 * _fn);
            at_pivot() circle(r = r - rail_w / 2, $fn = 4 * _fn);
        }
        x_range(bay_half - 0.1, BIG);
        wedge_rear_half_2d();
        plate_outline_2d(inset = inside);
    }
}

module body_2d() {
    z = $z;
    post_top = H - 1.0;
    if (z < floor_t) difference() {
        plate_outline_2d(inset = skin_inset(z));
        floor_holes_2d();
    }
    if (z < plug_h()) {
        // Plinth: the stepped-in zone runs all the way round
        band_2d(skin_inset(z), wall);
        body_low_2d();
    } else if (z < H) {
        difference() { band_2d(skin_inset(z), wall_w(z)); openings_2d(); }
    } else {
        difference() { lip_2d(z - H); openings_2d(); }
    }
    if (z < H) difference() { body_inner_2d(); groove_2d(); }
    // Posts the wedge drawers turn on
    if (z < post_top) both_sides() at_pivot()
        circle(d = wedge_post_d - (z < post_top - 0.8 ? 0 :
            2 * (_q(z, post_top - 0.8, post_top) - (post_top - 0.8))), $fn = _fn);
    // Bumps that hold the wedge drawers shut
    if (wedge_detent_h > 0 && z > plug_h() && z < plug_h() + wedge_detent_h)
        both_sides() translate(wedge_detent_at())
            circle(r = rail_w / 2 - (_q(z, plug_h(), plug_h() + wedge_detent_h) - plug_h()), $fn = 24);
}

function body_levels() = _levels(concat(
    skin_levels(), [floor_t, plug_h()],
    _steps(groove_z0(), groove_z0()), [groove_z1()], _steps(groove_z1(), groove_z1() + groove_d()),
    _steps(shelf_z0(), H - shelf_t), _steps(H - 1.8, H - 1.0), [H],
    _steps(plug_h(), plug_h() + wedge_detent_h),
    lip_levels(H)), 0, H + seat_lip_h);

module body_half(side) {
    build(body_levels()) half_2d(side) { body_2d(); body_joints_2d(); }
}

// ========================================================== main drawer
// Rides on the runners, level with the top of the stepped-in zone, so it
// slides out over the lip of whatever the module stands on.

function drawer_half_w() = bay_in() - slide_gap;
function drawer_z0() = plug_h();
function drawer_z1() = H - top_gap;

module drawer_plan_2d(z) {
    intersection() {
        x_range(-drawer_half_w(), drawer_half_w());
        y_range(-BIG, drawer_rear_y());
        plate_outline_2d(inset = skin_inset(z));
    }
}

// The tongue on the right-hand side wall: slots, bump and finger tab
module tongue_slots_2d() {
    z = $z;
    x0 = drawer_half_w() - drawer_wall - 0.01;
    w = drawer_wall + 0.02;
    y0 = tongue_y() - tongue_w / 2;
    y1 = tongue_y() + tongue_w / 2;
    if (z > tongue_z0() && z < tongue_z1()) {
        translate([x0, y0 - tongue_slot]) square([w, tongue_slot]);
        translate([x0, y1]) square([w, tongue_slot]);
    } else if (z >= tongue_z1() && z < tongue_z1() + 1.2) {
        translate([x0, y0 - tongue_slot]) square([w, tongue_w + 2 * tongue_slot]);
    }
}
module tongue_adds_2d() {
    z = $z;
    xo = drawer_half_w();
    xi = drawer_half_w() - drawer_wall;
    yf = tongue_y() - bump_len / 2;
    // Bump on the outside: square face to the front, ramp to the rear,
    // 45 degrees underneath
    b = z > bump_z0() + bump_h ? bump_h : _q(z, bump_z0(), bump_z0() + bump_h) - bump_z0();
    if (z > bump_z0() && z < bump_z1())
        polygon([[xo - 0.01, yf], [xo + b, yf], [xo + b, yf + bump_len - b], [xo - 0.01, yf + bump_len]]);
    // Finger tab on the inside, at the tip
    t = z > tongue_z1() - 2.5 ? 2.5 : _q(z, tongue_z1() - 5, tongue_z1() - 2.5) - (tongue_z1() - 5);
    if (z > tongue_z1() - 5 && z < tongue_z1())
        translate([xi - t, tongue_y() - 3]) square([t + 0.01, 6]);
}

module drawer_2d() {
    z = $z;
    zr = z - drawer_z0();
    if (zr < drawer_floor) {
        // Floor, with a small bevel on its bottom edge
        offset(delta = -(zr > 0.4 ? 0 : 0.4 - (_q(z, drawer_z0(), drawer_z0() + 0.4) - drawer_z0())))
            drawer_plan_2d(z);
    } else {
        sw = drawer_front == "scoop" ? slot_half_w(z, drawer_z1(), scoop_w, scoop_d, 7) : 0;
        difference() {
            drawer_plan_2d(z);
            // Inside
            intersection() {
                x_range(-(drawer_half_w() - drawer_wall), drawer_half_w() - drawer_wall);
                y_range(-BIG, drawer_rear_y() - drawer_wall);
                plate_outline_2d(inset = skin_inset(z) + drawer_front_t);
            }
            // Finger scoop in the front panel
            if (sw > 0) translate([-sw, -BIG]) square([2 * sw, BIG + plate_front_y(0) + 12]);
            if (drawer_stop) both_sides() tongue_slots_2d();
        }
        if (drawer_stop) both_sides() tongue_adds_2d();
    }
}

function drawer_levels() = _levels(concat(
    skin_levels(), _steps(drawer_z0(), drawer_z0() + 0.4), [drawer_z0() + drawer_floor],
    [tongue_z0(), tongue_z1(), tongue_z1() + 1.2],
    _steps(bump_z0(), bump_z0() + bump_h), [bump_z1()],
    _steps(tongue_z1() - 5, tongue_z1() - 2.5),
    drawer_front == "scoop" ? concat(_steps(drawer_z1() - scoop_d, drawer_z1() - scoop_d + 7), []) : []
    ), drawer_z0(), drawer_z1());

module drawer() { build(drawer_levels()) drawer_2d(); }

// ========================================================= wedge drawer
// A pie-shaped drawer that turns on the post. Drawn shut, right-hand side.

function wedge_z0() = plug_h();
function wedge_z1() = H - top_gap;

// Footprint of the drawer, limited to the outline at inset i
module wedge_plan_2d(i) {
    difference() {
        intersection() {
            plate_outline_2d(inset = i);
            x_range(bay_half + wedge_side_gap, BIG);
            at_pivot() circle(r = wedge_R(), $fn = 4 * _fn);
            wedge_rear_half_2d();
        }
        // Stay clear of the stop buttress
        translate(wedge_pivot() + [-BIG, -BIG])
            square([BIG - wedge_hub_r + 0.8, BIG + wedge_shoulder()]);
    }
    intersection() {
        at_pivot() circle(r = wedge_hub_r, $fn = _fn);
        plate_outline_2d(inset = i);
    }
}

module wedge_cavity_2d(i) {
    difference() {
        offset(r = 1.5, $fn = 16) offset(delta = -1.5 - wedge_wall) wedge_plan_2d(i);
        at_pivot() circle(r = wedge_hub_r + 0.01, $fn = _fn);
    }
}

// The stop rib on the hub, drawn where it is when the drawer is shut
module wedge_lug_2d() {
    at_pivot() rotate(wedge_swing)
        translate([-(wedge_hub_r + lug_len()), stop_y - lug_t])
            square([lug_len() + 1, lug_t]);
}

// The finger notch in the top edge of the outside wall
module wedge_notch_2d(hw) {
    translate(wedge_foot()) rotate(-side_phi())
        translate([-(wedge_wall + 1.5), wedge_face_len() - 26 - hw])
            square([wedge_wall + 4, 2 * hw]);
}

module wedge_2d() {
    z = $z;
    zr = z - wedge_z0();
    i = skin_inset(z);
    difference() {
        union() {
            if (zr < wedge_floor) wedge_plan_2d(i);
            else difference() { wedge_plan_2d(i); wedge_cavity_2d(i); }
            wedge_lug_2d();
        }
        // Bore for the post
        at_pivot() circle(d = wedge_post_d + 0.6, $fn = _fn);
        // Dimple for the bump that holds it shut
        if (wedge_detent_h > 0 && zr < wedge_detent_h + 0.2)
            translate(wedge_detent_at())
                circle(r = rail_w / 2 + 0.5 - (_q(z, wedge_z0(), wedge_z0() + wedge_detent_h + 0.2) - wedge_z0()), $fn = 24);
        // Finger notch
        hw = slot_half_w(z, wedge_z1(), wedge_notch_w, wedge_notch_d, 5);
        if (hw > 0) wedge_notch_2d(hw);
    }
}

function wedge_levels() = _levels(concat(
    skin_levels(), [wedge_z0() + wedge_floor],
    _steps(wedge_z0(), wedge_z0() + wedge_detent_h + 0.2),
    _steps(wedge_z1() - wedge_notch_d, wedge_z1() - wedge_notch_d + 5)
    ), wedge_z0(), wedge_z1());

// side = +1: right, -1: left
module wedge_drawer(side) {
    if (side < 0) mirror([1, 0, 0]) build(wedge_levels()) wedge_2d();
    else build(wedge_levels()) wedge_2d();
}

// Turn a wedge drawer out by a fraction of its swing
module wedge_swung(side, f) {
    p = [side * wedge_pivot()[0], wedge_pivot()[1], 0];
    translate(p) rotate([0, 0, -side * wedge_swing * f]) translate(-p) children();
}

// ============================================================ test pieces
// Small prints that check one fit each before a whole part is printed.

module clip_box(x0, x1, y0, y1) {
    intersection() {
        children();
        translate([x0, y0, -1]) cube([x1 - x0, y1 - y0, 2 * BIG]);
    }
}
module clip_circle(c, r) {
    intersection() {
        children();
        translate([c[0], c[1], -1]) cylinder(r = r, h = 2 * BIG, $fn = 64);
    }
}

// The stepped-in bottom as a narrow ring, to drop into the fit-test ring
module test_step_half(side) {
    build(_levels(skin_levels(), 0, plug_h() + 1.2)) half_2d(side) {
        union() {
            band_2d(skin_inset($z), 5);
            intersection() {
                plate_outline_2d(inset = skin_inset($z));
                union() for (y = [plate_front_y(0) - 5, plate_rear_y(0) - 20])
                    translate([-14, y]) square([28, 25]);
            }
        }
        for (y = [plate_front_y(0) + plug_inset() + 9, plate_rear_y(0) - plug_inset() - 9])
            translate([0, y]) dovetail_2d();
    }
}

// ================================================================ views

// The monitor's base, standing on a pocket floor at Z = 0
module dell_black() { linear_extrude(dell_black_h) plate_outline_2d(inset = dell_overhang); }
module dell_plate() { translate([0, 0, dell_black_h]) linear_extrude(dell_plate_t) plate_outline_2d(); }
module show_dell() {
    color("DimGray", 0.5) dell_black();
    color("Silver", 0.5) dell_plate();
}

module show_module(spread = 0, open = 0) {
    color("SteelBlue") translate([-spread * 0.4, 0, 0]) body_half(-1);
    color("LightSkyBlue") translate([spread * 0.4, 0, 0]) body_half(1);
    color("Tomato") translate([0, -spread * 2.4 - open * drawer_travel(), 0]) drawer();
    if (wedge_right == "swivel") color("Goldenrod")
        translate([spread * 1.5, 0, 0]) wedge_swung(1, open) wedge_drawer(1);
    if (wedge_left == "swivel") color("Goldenrod")
        translate([-spread * 1.5, 0, 0]) wedge_swung(-1, open) wedge_drawer(-1);
}
module show_plate(spread = 0) {
    color("Khaki") translate([-spread * 0.4, 0, 0]) plate_half(-1);
    color("DarkKhaki") translate([spread * 0.4, 0, 0]) plate_half(1);
}

module bed_outline(n) {
    for (i = [0 : n - 1])
        translate([i * (bed + 30), 0, -0.6])
            color("Gainsboro") difference() {
                cube([bed, bed, 0.4]);
                translate([2, 2, -1]) cube([bed - 4, bed - 4, 3]);
            }
}

module show_plates() {
    pitch = bed + 30;
    cy = bed / 2 - plate_rear_y(0) / 2;
    bed_outline(6);
    color("SteelBlue") translate([bed / 2 + 92, cy]) body_half(-1);
    color("LightSkyBlue") translate([pitch + bed / 2 - 92, cy]) body_half(1);
    color("Tomato") translate([2 * pitch + bed / 2, cy, -drawer_z0()]) drawer();
    color("Goldenrod") translate([3 * pitch + bed / 2 - 185, cy, -wedge_z0()]) wedge_drawer(1);
    color("Goldenrod") translate([3 * pitch + bed / 2 + 185, cy, -wedge_z0()]) wedge_drawer(-1);
    color("Khaki") translate([4 * pitch + bed / 2 + 92, cy]) plate_half(-1);
    color("DarkKhaki") translate([5 * pitch + bed / 2 - 92, cy]) plate_half(1);
}

// ---- interference checks (see tools/check_riser.py)

module piece(name) {
    if (name == "body") { body_half(-1); body_half(1); }
    else if (name == "drawer") translate([0, -_open * drawer_travel(), 0]) drawer();
    else if (name == "wedge") wedge_swung(1, _open) wedge_drawer(1);
    else if (name == "plate") { plate_half(-1); plate_half(1); }
}
// A piece as it sits one level up (+1) or one level down (-1)
module piece_at(name, level) {
    below_h = name == "plate" ? plate_h : H;
    translate([0, 0, level > 0 ? H : level < 0 ? -below_h : 0]) piece(name);
}
function _split(s, c = "|") =
    let (i = search(c, s)[0])
    i == undef ? [s] : [str_sub(s, 0, i), str_sub(s, i + 1, len(s) - i - 1)];
function str_sub(s, start, n) =
    n <= 0 ? "" : str(s[start], str_sub(s, start + 1, n - 1));
// "body|drawer", "body|wedge", "body|plate+" (plate on top), "wedge|plate-"
// (plate underneath), "drawer|body-" and so on
module check_overlap() {
    ab = _split(_check);
    intersection() {
        for (i = [0]) check_piece(ab[0]);
        for (i = [0]) check_piece(ab[1]);
    }
}
module check_piece(tag) {
    n = len(tag);
    last = tag[n - 1];
    if (last == "+") piece_at(str_sub(tag, 0, n - 1), 1);
    else if (last == "-") piece_at(str_sub(tag, 0, n - 1), -1);
    else piece_at(tag, 0);
}

if (_check != "") check_overlap();
else if (part == "body_left") body_half(-1);
else if (part == "body_right") body_half(1);
else if (part == "drawer") drawer();
else if (part == "wedge_left") wedge_drawer(-1);
else if (part == "wedge_right") wedge_drawer(1);
else if (part == "plate_left") plate_half(-1);
else if (part == "plate_right") plate_half(1);
else if (part == "dell_black") dell_black();
else if (part == "dell_plate") dell_plate();
else if (part == "test_step_left") test_step_half(-1);
else if (part == "test_step_right") test_step_half(1);
else if (part == "test_hub_body")
    clip_circle(wedge_pivot() + [-4, 6], 34) body_half(1);
else if (part == "test_hub_drawer")
    clip_circle(wedge_pivot(), 46) wedge_drawer(1);
else if (part == "test_front_left")
    clip_box(-bay_half - 0.01, 10, -BIG, 48) body_half(-1);
else if (part == "test_front_right")
    clip_box(-10, bay_half + 0.01, -BIG, 48) body_half(1);
else if (part == "test_front_drawer")
    clip_box(-BIG, BIG, -BIG, 62) drawer();
else if (part == "test_stop_body")
    clip_box(bay_in() - 14, bay_half + 0.01, plate_front_y(bay_half) + 6, drawer_stop_y + 50) body_half(1);
else if (part == "test_stop_drawer")
    clip_box(drawer_half_w() - 40, BIG, tongue_y() - 22, BIG) drawer();
else if (part == "test_seam_left")
    clip_box(-30, 30, seam_block_y1() - 28, BIG) body_half(-1);
else if (part == "test_seam_right")
    clip_box(-30, 30, seam_block_y1() - 28, BIG) body_half(1);
else if (view == "print plates") show_plates();
else if (view == "stack") {
    for (i = [0 : stack_modules - 1]) translate([0, 0, i * H]) show_module();
    if (stack_plates > 0)
        for (i = [0 : stack_plates - 1])
            translate([0, 0, stack_modules * H + i * plate_h]) show_plate();
    translate([0, 0, stack_modules * H + stack_plates * plate_h]) show_dell();
} else if (view == "exploded") {
    show_module(spread = 40);
    translate([0, 0, H + 50]) show_plate(spread = 40);
} else {
    show_module(open = _open);
    if (view == "assembled") translate([0, 0, H]) { show_plate(); translate([0, 0, plate_h]) show_dell(); }
}

echo(str("NUM wedge_pivot_x ", wedge_pivot()[0]));
echo(str("NUM wedge_pivot_y ", wedge_pivot()[1]));
echo(str("NUM wedge_radius ", wedge_R()));
echo(str("NUM wedge_swing ", wedge_swing));
echo(str("NUM wedge_wall_len_inside ", wedge_face_len() - wedge_wall - wedge_hub_r));
echo(str("NUM drawer_travel ", drawer_travel()));
echo(str("NUM drawer_rear_y ", drawer_rear_y()));
echo(str("NUM drawer_inside_w ", 2 * (drawer_half_w() - drawer_wall)));
echo(str("NUM drawer_inside_h ", drawer_z1() - drawer_z0() - drawer_floor));
echo(str("NUM plug_h ", plug_h()));
echo(str("NUM flare_top ", flare_top()));
