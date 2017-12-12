//-------------------------------------------------------------------------
// IP64 Waterproof Case for generic Smartphone:
// OpenSCAD source files for 3D-Print and laser cut.
//
// This is the project file for the whole assembling.
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

include <ip64-smartphone-case.scad>;

// Set greather than zero for an exploded view.
exploded = 0;

//-------------------------------------------------------------------------
// The main body, with pin button holes.
//-------------------------------------------------------------------------
difference() {
  body();
  translate([margin + phone_x, margin + connector_space_y + padding_thick, btn_z]) {
    rotate(a=90, v=[0, 1, 0]) {
      for (y = btn_right_pos_y) {
        translate([0, y, 0]) clevis_pin_hole_m3(margin, or_pins_cs);
      }
    }
  }
}

//-------------------------------------------------------------------------
// Power connector grommet.
//-------------------------------------------------------------------------
translate([case_x / 2, -exploded, case_z / 2])
  rotate(a = -90, v=[1, 0, 0])
    cable_grommet(connector_space_x, connector_space_z, margin);

//-------------------------------------------------------------------------
// Place the right-side clevis pins.
//-------------------------------------------------------------------------
translate([btn_x, margin + connector_space_y + padding_thick, btn_z]) {
  rotate(a = 90, v = [0, 1, 0]) {
    for (y = btn_right_pos_y) {
      translate([0, y, clevis_head_recess - exploded]) clevis_pin_m3();
    }
  }
}

//-------------------------------------------------------------------------
// Place the clevis pin O-Rings.
//-------------------------------------------------------------------------
x1 = phone_x + margin + or_pins_cs / 2 + or_rim - exploded * 0.5;
x2 = phone_x + margin * 2 - or_pins_cs / 2 - or_rim + exploded * 0.5;
for (x = [x1, x2]) {
  translate([x, margin + connector_space_y, btn_z]) {
    rotate(a=-90, v=[0, 1, 0]) {
      for (y = btn_right_pos_y) {
        translate([0, y, 0])
          color(c=[100/255, 100/255, 100/255])
            o_ring(or_pins_id, or_pins_cs);
      }
    }
  }
}

//-------------------------------------------------------------------------
// The front cover with screw head seats and reinforcing profile.
//-------------------------------------------------------------------------
translate([0, 0, case_z + exploded]) {
  color("white") {
    difference() {
      // Main panel, with the engraved writing.
      front_panel();
      translate([case_x / 2, margin, top_thick - 0.2])
        linear_extrude(height = interf + 0.2, convexity = 20)
          text("OpenStreetMap.Org", font = "Liberation Sans", size = 5, valign = "bottom", halign = "center", $fn = 32);
    }
  }
}

//-------------------------------------------------------------------------
// Main seal O-Ring
//-------------------------------------------------------------------------
translate([margin_seal, margin_seal, case_z + or_main_cs / 2 - or_main_depth + exploded * 0.6])
  color([100/255, 100/255, 100/255])
      o_ring_rounded_square(case_x - (margin_seal * 2), case_y - (margin_seal * 2), or_main_cs, or_main_r);

//-------------------------------------------------------------------------
// The bottom back panel.
//-------------------------------------------------------------------------
translate([0, 0, -3 - exploded]) color("silver") back_panel();

//-------------------------------------------------------------------------
// A body assembly screw, for size reference.
//-------------------------------------------------------------------------
corner_offset = case_r - ((case_r - margin_holes) / sqrt(2));
translate([corner_offset, corner_offset, case_z + top_thick + 0.8])
  rotate(a = 180, v = [0, 1, 0])
    color([190/255, 190/255, 190/255])
      bolt_m2p5(25);
