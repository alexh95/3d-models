// Rough proof-of-concept models: ways to join two printed parts at a seam.
//
// Each sample is a short piece of the seam where two parts meet: a strip of
// floor and a piece of wall on each side. They are block models for
// comparing strategies, and small enough to print as test coupons.
//
// This file is self-contained. Open it in OpenSCAD, press F5, and use the
// Customizer panel (Window > Customizer) to switch joint and view.
//
// Units: mm.  The seam is the plane X = 0.  Z = up.

/* [What to show] */
joint = "all"; // [all, dovetail, dowels, screws, keys, tongue]
view = "exploded"; // [assembled, exploded]
// One part on its own, for export
part = "both"; // [both, left, right, loose parts]

/* [Sample] */
// Length of each side of the sample, away from the seam
sample_l = 32;
// Depth of the floor strip
sample_d = 46;
// Wall height
sample_h = 40;
// Wall thickness
wall = 2.4;
// Floor thickness
floor_t = 1.6;

/* [Fits] */
// Gap around printed sliding or press fits
fit_gap = 0.2;
// Dowel diameter. 6 suits wooden or printed dowels.
dowel_d = 6;
// Screw size: 3 means M3
screw_d = 3;

/* [Hidden] */
eps = 0.01;
$fn = 40;
_block = 12;   // thickness of the reinforcing block beside the seam
_names = ["dovetail", "dowels", "screws", "keys", "tongue"];

// ------------------------------------------------------------ plain sample

// side = -1 left, +1 right. Floor strip plus a wall along the back.
module plain(side) {
    x0 = side < 0 ? -sample_l : 0;
    translate([x0, 0, 0]) cube([sample_l, sample_d, floor_t]);
    translate([x0, sample_d - wall, 0]) cube([sample_l, wall, sample_h]);
}

// Solid block against the wall next to the seam, to take a joint.
module seam_block(side, len = 10, h = sample_h) {
    translate([side < 0 ? -len : 0, sample_d - wall - _block + eps, 0])
        cube([len, _block, h]);
}

// Low block on the floor next to the seam, near the front.
module floor_block(side, len = 10, h = 9) {
    translate([side < 0 ? -len : 0, 4, 0]) cube([len, _block, h]);
}

module dovetail_2d(grow = 0, len = 7, neck = 3, head = 5) {
    offset(delta = grow)
        polygon([[-eps, -neck], [len, -head], [len, head], [-eps, neck]]);
}

// Hole along X, centred on the seam, with a flat roof so it prints cleanly.
module x_hole(d, len) {
    rotate([0, 90, 0]) cylinder(d = d, h = len, center = true);
}

// --------------------------------------------------- 1. printed dovetails
// Nothing to buy, nothing to glue, comes apart again. The tab in the floor
// is the joint already proven on the fit-test ring.

module dovetail_part(side) {
    yb = sample_d - wall - _block / 2;
    yf = 4 + _block / 2;
    if (side < 0) {
        plain(side);
        seam_block(side);
        translate([0, yb]) linear_extrude(sample_h) dovetail_2d();
        translate([0, yf]) linear_extrude(floor_t) dovetail_2d();
    } else {
        difference() {
            union() { plain(side); seam_block(side, len = 13); }
            translate([0, yb, -1]) linear_extrude(sample_h + 2) dovetail_2d(grow = fit_gap);
            translate([0, yf, -1]) linear_extrude(floor_t + 2) dovetail_2d(grow = fit_gap);
        }
    }
}

// ------------------------------------------------------ 2. dowels + glue
// Blind holes in both faces, loose dowels, glue on the faces. Permanent.

function dowel_zs() = [sample_h * 0.25, sample_h * 0.75];
dowel_len = 16;

module dowel_part(side) {
    yb = sample_d - wall - _block / 2;
    difference() {
        union() { plain(side); seam_block(side); floor_block(side); }
        for (z = dowel_zs()) translate([0, yb, z]) x_hole(dowel_d + fit_gap, dowel_len + 1);
        translate([0, 4 + _block / 2, 5]) x_hole(dowel_d + fit_gap, dowel_len + 1);
    }
}

module dowels_loose() {
    yb = sample_d - wall - _block / 2;
    for (z = dowel_zs()) translate([0, yb, z]) x_hole(dowel_d, dowel_len);
    translate([0, 4 + _block / 2, 5]) x_hole(dowel_d, dowel_len);
}

// ------------------------------------------------------------ 3. screws
// Screw from one side into a threaded insert (or straight into plastic) in
// the other. Strongest, pulls the seam tight, comes apart again.

screw_len = 16;

module screw_part(side) {
    yb = sample_d - wall - _block / 2;
    difference() {
        union() { plain(side); seam_block(side); floor_block(side); }
        for (p = [[yb, sample_h * 0.25], [yb, sample_h * 0.75], [4 + _block / 2, 5]])
            translate([0, p[0], p[1]]) {
                if (side < 0) {
                    // clearance hole and a pocket for the screw head
                    x_hole(screw_d + 0.4, 30);
                    translate([-10 - 5, 0, 0]) x_hole(screw_d * 2, 10 + eps);
                } else {
                    // hole for a heat-set insert
                    x_hole(screw_d + 1.2, 2 * 7);
                }
            }
    }
}

module screws_loose() {
    yb = sample_d - wall - _block / 2;
    for (p = [[yb, sample_h * 0.25], [yb, sample_h * 0.75], [4 + _block / 2, 5]])
        translate([-10 + screw_len / 2 - 3, p[0], p[1]]) {
            x_hole(screw_d, screw_len);
            translate([-screw_len / 2 - 1.5, 0, 0]) x_hole(screw_d * 1.8, 3);
        }
}

// -------------------------------------------------------- 4. loose keys
// Both parts get the same socket; a separate double-dovetail key slides in
// from above. The two parts stay exact mirror images.

module key_2d(grow = 0) {
    dovetail_2d(grow = grow, len = 6);
    mirror([1, 0]) dovetail_2d(grow = grow, len = 6);
}

module key_part(side) {
    yb = sample_d - wall - _block / 2;
    yf = 4 + _block / 2;
    difference() {
        union() { plain(side); seam_block(side, len = 12); }
        translate([0, yb, floor_t]) linear_extrude(sample_h) key_2d(grow = fit_gap);
        translate([0, yf, -1]) linear_extrude(floor_t + 2) key_2d(grow = fit_gap);
    }
}

module keys_loose() {
    yb = sample_d - wall - _block / 2;
    translate([0, yb, floor_t]) linear_extrude(sample_h - floor_t) key_2d();
    translate([0, 4 + _block / 2, 0]) linear_extrude(floor_t) key_2d();
}

// ------------------------------------------------- 5. tongue and groove
// A rib on one face sits in a slot on the other; glue holds it. Lightest
// and least visible, but relies entirely on the glue.

module tongue_part(side) {
    t = 6;      // wall and floor thicken to this beside the seam
    rib = 2;
    yw = sample_d - t;
    flange_l = 8;
    difference() {
        union() {
            plain(side);
            translate([side < 0 ? -flange_l : 0, yw, 0]) cube([flange_l, t, sample_h]);
            translate([side < 0 ? -flange_l : 0, 0, 0]) cube([flange_l, sample_d, 4]);
            if (side < 0) {
                translate([-eps, yw + (t - rib) / 2, 4]) cube([3, rib, sample_h - 4]);
                translate([-eps, 3, (4 - 1.6) / 2]) cube([3, yw - 3, 1.6]);
            }
        }
        if (side > 0) {
            translate([-eps, yw + (t - rib) / 2 - fit_gap, 4 - fit_gap])
                cube([3.4, rib + 2 * fit_gap, sample_h]);
            translate([-eps, 3 - fit_gap, (4 - 1.6) / 2 - fit_gap])
                cube([3.4, yw - 3 + 2 * fit_gap, 1.6 + 2 * fit_gap]);
        }
    }
}

// ---------------------------------------------------------------- views

module sample_part(name, side) {
    if (name == "dovetail") dovetail_part(side);
    else if (name == "dowels") dowel_part(side);
    else if (name == "screws") screw_part(side);
    else if (name == "keys") key_part(side);
    else tongue_part(side);
}

module sample_loose(name) {
    if (name == "dowels") dowels_loose();
    else if (name == "screws") screws_loose();
    else if (name == "keys") keys_loose();
}

module sample(name) {
    s = view == "exploded" ? 14 : 0;
    if (part != "right" && part != "loose parts")
        color("SteelBlue") translate([-s, 0, 0]) render() sample_part(name, -1);
    if (part != "left" && part != "loose parts")
        color("LightSkyBlue") translate([s, 0, 0]) render() sample_part(name, 1);
    if (part == "both" || part == "loose parts")
        color("Goldenrod")
            translate([0, 0, view == "exploded" && name == "keys" ? sample_h + 12 : 0])
                render() sample_loose(name);
}

if (joint == "all")
    for (i = [0 : len(_names) - 1])
        translate([i * (2 * sample_l + 46), 0, 0]) sample(_names[i]);
else
    sample(joint);
