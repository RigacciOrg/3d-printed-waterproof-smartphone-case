//-------------------------------------------------------------------------
// IP64 Waterproof Case for generic Smartphone:
// OpenSCAD source files for 3D-Print and laser cut.
//
// This is the main project source file.
//
// This is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ProTherm. If not, see <http://www.gnu.org/licenses/>.
//
// Author        Niccolo Rigacci <niccolo@rigacci.org>
// Version       0.1  2017-12-04
//-------------------------------------------------------------------------

include <common.scad>;

// Thickness of padding around the device.
padding_thick = 2.0;

// Space occupied by the device (smartphone),
// it is the actual size plus the padding material.
phone_x =  67.2 + padding_thick * 2;
phone_y = 140.2 + padding_thick * 2;
phone_z =  10.0 + padding_thick;
phone_r =   6.0; // Corner radius.

// Margin between outer case edges and phone edges.
// This is the thickness of the main body.
margin       = 13.0;
margin_holes =  5.0;
margin_seal  =  9.0;

// Space for the power connector.
// The Z dimension is the pass-through hole.
//connector_space_x = 14.0; // Calculated upon O-Ring size! See below.
connector_space_y = 25.0;
connector_space_z =  8.0;

// Power cable grommet: O-Ring squeezed outer diameter.
outer_diam = (o_ring_cable_grommet_inner_diam + o_ring_cable_grommet_groove_depth * 2);

// Calculate connector_space_x from O-Ring size, using formulae:
// outer_diam = connector_space_z * PI + (connector_space_x - connector_space_z) * 2
// connector_space_x = (outer_diam - connector_space_z * PI) / 2 + connector_space_z
connector_space_x = (outer_diam - connector_space_z * PI) / 2 + connector_space_z;
echo("Calculated connector_space_x=", connector_space_x);

// Overall case size.
case_x = phone_x + margin * 2;
case_y = phone_y + margin * 2 + connector_space_y;
case_z = phone_z +  1.0;
case_r = 12;

// Thickness of top an bottom panels.
top_thick    = 3.0;
bottom_thick = 3.0;

// Hole positions along the edges.
hole_pos_top    = [0];
hole_pos_bottom = [0, 1];
hole_pos_left   = [0, 1, 2];
hole_pos_right  = [0, 0.85];

// Device (smartphone) button positions.
btn_x = phone_x + margin;
btn_z = case_z / 2;
btn_power_y    =  87;
btn_vol_up_y   =  98;
btn_vol_down_y = 113;

// Bolts for body retain, M2.5.
bolt_d = 2.5;

// O-Ring cross-section and inner diameter.
or_pins_cs = 1.0;
or_pins_id = 3.0;
or_main_cs = 2.0;
or_main_depth = or_main_cs * 0.80; // See O-Ring groove dimensioning.
or_main_width = or_main_cs * 1.30;
or_main_r     = 10.0;

// Clevis pins size.
clevis_lenght = 18;
clevis_effective_lenght = 15;
clevis_head_height = 2; // TODO: use the actual size upon clevis used.

//-------------------------------------------------------------------------
// The main body, 2D shape.
//-------------------------------------------------------------------------
module body_2d() {
    difference() {
        // Main body.
        rounded_square([case_x, case_y], case_r);
        // Device main space.
        translate([(case_x - phone_x) / 2, (case_y + connector_space_y - phone_y) / 2])
            rounded_square([phone_x, phone_y], phone_r);
        // Power connector space.
        translate([(case_x - connector_space_x) / 2, margin])
            rounded_square([connector_space_x, connector_space_y + phone_r], 3);
        // More space (e.g. for silca-gel).
        translate([(case_x - phone_x / 2) / 2, margin + connector_space_y / 2])
            rounded_square([phone_x / 2, connector_space_y / 2 + 3.1], 3);
        // Screew holes.
        screw_holes_2d();
    }
}

//-------------------------------------------------------------------------
// The main body, 3D shape.
//-------------------------------------------------------------------------
module body() {
    groove_x = case_x - margin_seal * 2;
    groove_y = case_y - margin_seal * 2;
    groove_depth = or_main_depth;
    groove_width = or_main_width;
    // Hole for power cable grommet.
    cable_hole_x = connector_space_x + 0.1;
    cable_hole_y = connector_space_z + 0.1;
    cable_hole_z = margin + connector_space_y + interf;
    difference() {
        linear_extrude(height = case_z, convexity = 10) body_2d();
        // Groove for O-Ring seal.
        translate([margin_seal, margin_seal, case_z - (groove_depth / 2)])
            groove_rounded_square(groove_x, groove_y, or_main_r, groove_width, groove_depth + interf);
        // The power connector pass-through hole.
        translate([case_x / 2, -interf, case_z / 2])
          rotate(a = -90, v=[1, 0, 0])
            rounded_cube([cable_hole_x, cable_hole_y, cable_hole_z], cable_hole_y / 2, center = true);

    }
    // Reinforce pad.
    translate([(case_x - phone_x) / 2, margin, 0]) cube([phone_x, connector_space_y, padding_thick]);
}

//-------------------------------------------------------------------------
// The front panel, with the screen window, 2D shape.
//-------------------------------------------------------------------------
module front_panel_2d() {

    // Overlapping border.
    overlap_side   = padding_thick + 3.5;
    overlap_top    = padding_thick + 4.5;
    overlap_bottom = padding_thick + 4.5;

    // Actual size of window for the device screen.
    scr_w = phone_x - overlap_side * 2;
    scr_h = phone_y - overlap_top - overlap_bottom;
    scr_r = phone_r;
    scr_x = (case_x - scr_w) / 2;
    scr_y = margin + connector_space_y + overlap_bottom;

    difference() {
        rounded_square([case_x, case_y], case_r);
        translate([scr_x, scr_y]) rounded_square([scr_w, scr_h], scr_r);
        screw_holes_2d();
    }

    // Add four retaining pads at screen's corners.
    cnr_x1 = (case_x - scr_w) / 2;
    cnr_x2 = case_x - cnr_x1;
    cnr_y1 = margin + connector_space_y + overlap_bottom;
    cnr_y2 = case_y - margin - overlap_top;
    cnr_w  = 12;
    cnr_h  = 12;
    translate([cnr_x1, cnr_y1]) rounded_square([cnr_w * 2, cnr_h * 2], 3, center = true);
    translate([cnr_x2, cnr_y1]) rounded_square([cnr_w * 2, cnr_h * 2], 3, center = true);
    translate([cnr_x1, cnr_y2]) rounded_square([cnr_w * 2, cnr_h * 2], 3, center = true);
    translate([cnr_x2, cnr_y2]) rounded_square([cnr_w * 2, cnr_h * 2], 3, center = true);

}
module front_panel() {
    linear_extrude(height = top_thick) front_panel_2d();
}

//-------------------------------------------------------------------------
// The back panel. Simple aluminum plate, laser cut.
//-------------------------------------------------------------------------
module back_panel_2d() {
    difference() {
        rounded_square([case_x, case_y], case_r);
        screw_holes_2d();
    }
}
module back_panel() {
    linear_extrude(height = bottom_thick) back_panel_2d();
}

//-------------------------------------------------------------------------
// screw_head_seat() sized for an M2.5 bolt.
//-------------------------------------------------------------------------
module body_screw_seat() {
    screw_head_seat(5.1, 2.0, 2.5);
}

//-------------------------------------------------------------------------
// Housing for the head of the screws, with a washer-like thickness.
//-------------------------------------------------------------------------
module screw_head_seats() {

  corner_offset = case_r - ((case_r - margin_holes) / sqrt(2));

  translate([         corner_offset,          corner_offset, 0]) body_screw_seat();
  translate([case_x - corner_offset,          corner_offset, 0]) body_screw_seat();
  translate([         corner_offset, case_y - corner_offset, 0]) body_screw_seat();
  translate([case_x - corner_offset, case_y - corner_offset, 0]) body_screw_seat();
  for (p = hole_pos_top) {
    space = (case_x / (len(hole_pos_top) + 1));
    translate([space * (p + 1), case_y - margin_holes, 0]) body_screw_seat();
  }
  for (p = hole_pos_bottom) {
    space = (case_x / (len(hole_pos_bottom) + 1));
    translate([space * (p + 1), margin_holes, 0]) body_screw_seat();
  }
  for (p = hole_pos_left) {
    space = (case_y / (len(hole_pos_left) + 1));
    translate([margin_holes, space * (p + 1), 0]) body_screw_seat();
  }
  for (p = hole_pos_right) {
    space = (case_y / (len(hole_pos_right) + 1));
    translate([case_x - margin_holes, space * (p + 1), 0]) body_screw_seat();
  }
}

//-------------------------------------------------------------------------
// Make the screw holes into a 2D plane.
//-------------------------------------------------------------------------
module screw_holes_2d() {

  $fn = smalld_fn;
  corner_offset = case_r - ((case_r - margin_holes) / sqrt(2));
  hole_r = (bolt_d / 2) + 0.1;

  translate([         corner_offset,          corner_offset]) circle(r = hole_r);
  translate([case_x - corner_offset,          corner_offset]) circle(r = hole_r);
  translate([         corner_offset, case_y - corner_offset]) circle(r = hole_r);
  translate([case_x - corner_offset, case_y - corner_offset]) circle(r = hole_r);
  for (p = hole_pos_top) {
    space = (case_x / (len(hole_pos_top) + 1));
    translate([space * (p + 1), case_y - margin_holes]) circle(r = hole_r);
  }
  for (p = hole_pos_bottom) {
    space = (case_x / (len(hole_pos_bottom) + 1));
    translate([space * (p + 1), margin_holes]) circle(r = hole_r);
  }
  for (p = hole_pos_left) {
    space = (case_y / (len(hole_pos_left) + 1));
    translate([margin_holes, space * (p + 1)]) circle(r = hole_r);
  }
  for (p = hole_pos_right) {
    space = (case_y / (len(hole_pos_right) + 1));
    translate([case_x - margin_holes, space * (p + 1)]) circle(r = hole_r);
  }
}
