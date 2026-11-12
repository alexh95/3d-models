// Interface check: the Dell U3421WE stand base and the seat it drops into.
// Nothing here is the riser design yet; this is only the monitor's base as
// measured, and the top few millimetres of the part it will sit on.
//
// Open in OpenSCAD, press F5, and switch "view" in the Customizer panel
// (Window > Customizer).

use <outline.scad>

/* [What to show] */
view = "exploded"; // [exploded, seated, section, seat only, dell base only]

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
eps = 0.01;

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
} else {
    dell_base();
}

echo(str("Clearance under the overhang: ", dell_black_h - seat_lip_h, " mm"));
echo(str("Side play of the black body in the pocket: ", dell_overhang - seat_lip_w, " mm each side"));
