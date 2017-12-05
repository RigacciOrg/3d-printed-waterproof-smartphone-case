//-------------------------------------------------------------------------
// IP64 Waterproof Case for generic Smartphone:
// OpenSCAD source files for 3D-Print and laser cut.
//
// This is the project file for 2D print test and laser cut.
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

groove_x = case_x - margin_seal * 2;
groove_y = case_y - margin_seal * 2;
groove_depth = or_main_depth;
groove_width = or_main_width;

front_panel_2d();

// Main body outline, with the O-Ring position.
translate([(case_x + 5), 0]) {
  difference() {
    body_2d();
    translate([margin_seal, margin_seal])
      projection()
        groove_rounded_square(groove_x, groove_y, or_main_r, groove_width, groove_depth + interf);
  }
}

translate([(case_x + 5) * 2, 0]) back_panel_2d();
