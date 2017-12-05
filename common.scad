//-------------------------------------------------------------------------
// IP64 Waterproof Case for generic Smartphone:
// OpenSCAD source files for 3D-Print and laser cut.
//
// This is the common parts source file.
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

// Interference for solid intersections and differences.
interf = 0.1;

// Smoothness of rounded angles.
rounded_fn = 32;

// Smoothness of small diameters (pin and holes).
smalld_fn = 18;

// Size of the O-Ring retaining rim.
or_rim = 1.0;

// O-Ring for sealing cable grommet, see static seal tables.
o_ring_cable_grommet_inner_diam   = 37.82;
o_ring_cable_grommet_cross_sect   =  1.78;
o_ring_cable_grommet_groove_depth =  1.34;
o_ring_cable_grommet_groove_width =  2.50;

// Diamter of the power cable passing through the cable grommet.
power_cable_d = 3.5;

//-------------------------------------------------------------------------
// Approximate a circle with the circumscribed or mid polygon.
//-------------------------------------------------------------------------
module cylinder_outer(radius, height, fn) {
    fudge = 1 / cos (180 / fn);
    cylinder(h = height, r = radius * fudge, $fn = fn);
}
module cylinder_mid(radius, height, fn) {
   fudge = (1 + 1 / cos(180 / fn)) / 2;
   cylinder(h = height, r = radius * fudge, $fn = fn);
}

//-------------------------------------------------------------------------
// 2D rectangle with rounded corners:
// rounded_square(size = [x, y], center = true/false)
//-------------------------------------------------------------------------
module rounded_square(size, r, center=false) {
    if (center) {
        translate([-size[0] / 2, -size[1] / 2]) rounded_square_(size, r);
    } else {
        rounded_square_(size, r);
    }
}
module rounded_square_(size, r) {
    $fn = rounded_fn;
    x = size[0];
    y = size[1];
    r1 = r + interf;
    difference() {
        square([x, y]);
        translate([-interf, -interf]) square([r1, r1]);
        translate([x - r, -interf])   square([r1, r1]);
        translate([-interf, y - r])   square([r1, r1]);
        translate([x - r, y - r])     square([r1, r1]);
    }
    translate([r, r])         circle(r=r);
    translate([x - r, r])     circle(r=r);
    translate([r, y - r])     circle(r=r);
    translate([x - r, y - r]) circle(r=r);
}

//-------------------------------------------------------------------------
// A cube with beveled edges obtained by rounded_square() extrusion.
//-------------------------------------------------------------------------
module rounded_cube(size, radius, center = false) {
    linear_extrude(height=size[2])
        rounded_square(size, radius, center);
}

//-------------------------------------------------------------------------
// Washer-like thickness under the screw head, without the engraved hole.
//-------------------------------------------------------------------------
module screw_washer(screw_head_d, screw_head_h) {
    $fn = smalld_fn;
    r1 = screw_head_d * 1.7 / 2;
    r2 = screw_head_d * 1.4 / 2;
    h1 = 0.8; // Washer thickness.
    h2 = screw_head_h * 0.5;
    translate([0, 0, -interf]) cylinder(r = r1, h = h1 + interf * 2);
    translate([0, 0, h1]) cylinder(r1 = r1, r2 = r2, h = h2);
}

//------------------------------------------------------------------------
// The rounded corner of o_ring_rounded_square() module.
//------------------------------------------------------------------------
module o_ring_rounded_corner(cs, radius) {
    cx = radius + cs / 2 + interf;
    cz = cs + interf * 2;
    tx = cs / 2 + interf;
    intersection() {
      translate([radius, radius, 0]) rotate_extrude(convexity = 10)
        translate([radius, 0, 0])
          circle(r = cs / 2, $fn = smalld_fn);
      translate([-tx, -tx, -tx]) cube(size = [cx, cx, cz]);
    }
}

//------------------------------------------------------------------------
// An O-Ring shaped as a rectangle with rounded corners.
//------------------------------------------------------------------------
module o_ring_rounded_square(x, y, cs, radius) {
    $fn = rounded_fn;
    o_ring_rounded_corner(cs, radius);
    translate([x, 0, 0]) rotate(a =  90, v=[0, 0, 1]) o_ring_rounded_corner(cs, radius);
    translate([x, y, 0]) rotate(a = 180, v=[0, 0, 1]) o_ring_rounded_corner(cs, radius);
    translate([0, y, 0]) rotate(a = 270, v=[0, 0, 1]) o_ring_rounded_corner(cs, radius);
    translate([radius - interf, 0, 0]) rotate(a =  90, v=[0, 1, 0]) cylinder(r = cs / 2, h = x - (radius - interf) * 2);
    translate([radius - interf, y, 0]) rotate(a =  90, v=[0, 1, 0]) cylinder(r = cs / 2, h = x - (radius - interf) * 2);
    translate([0, radius - interf, 0]) rotate(a = 270, v=[1, 0, 0]) cylinder(r = cs / 2, h = y - (radius - interf) * 2);
    translate([x, radius - interf, 0]) rotate(a = 270, v=[1, 0, 0]) cylinder(r = cs / 2, h = y - (radius - interf) * 2);
}

//------------------------------------------------------------------------
// Rectangular groove with rounded corner for O-Ring, size width x depth.
//------------------------------------------------------------------------
module groove_rounded_square(x, y, r, width, depth) {
    w2 = width / 2;
    translate([0, 0, -depth / 2])
      linear_extrude(height = depth)
      difference() {
        translate([-w2, -w2]) rounded_square([x + width, y + width], r + w2);
        translate([+w2, +w2]) rounded_square([x - width, y - width], r - w2);
      }
}

//-------------------------------------------------------------------------
// O-Ring
//-------------------------------------------------------------------------
module o_ring(inside_diam, cross_section) {
    rotate_extrude(angle=10, convexity=10, $fn = rounded_fn)
        translate([(inside_diam + cross_section) / 2, 0])
            circle(r=(cross_section / 2), $fn = smalld_fn);
}

//-------------------------------------------------------------------------
// https://www.pivotpins.com/products/bc-clevis-pins-with-grooves.html
//-------------------------------------------------------------------------
module clevis_pin(
    pin_diam, pin_length, pin_length_effective, pin_chamfer, pin_chamfer_angle,
    head_diam, head_height, head_chamfer, head_chamfer_angle,
    groove_d, groove_width) {
    $fn=48;
    color(c=[200/255, 200/255, 200/255]) rotate_extrude(angle=360)
      difference() {
        union() {
          difference() {
            translate([0, -interf]) square(size = [pin_diam / 2, pin_length + interf]);
            translate([pin_diam / 2, pin_length - pin_chamfer])
              rotate(a=pin_chamfer_angle, v=[0, 0, 1])
                square(size=[pin_chamfer * tan(pin_chamfer_angle), pin_chamfer / sin(90 - pin_chamfer_angle)]);
          }
          difference() {
            translate([0, -head_height]) square(size = [head_diam / 2, head_height]);
            translate([head_diam / 2, -head_height])
              translate([-head_chamfer * tan(head_chamfer_angle), 0])
                rotate(a=-head_chamfer_angle, v=[0, 0, 1])
                  square(size=[head_chamfer * tan(head_chamfer_angle), head_chamfer / sin(90 - head_chamfer_angle)]);
          }
        }
        translate([groove_d / 2, pin_length_effective])
          square(size=[(pin_diam - groove_d) / 2 + interf, groove_width]);
      }
}

//-------------------------------------------------------------------------
// Hole to let the Clevis Pin operate as a button.
// or_cs = O-Ring cross-section.
//-------------------------------------------------------------------------
module clevis_pin_hole(pin_diam, head_diam, head_height, lenght, or_cs) {

    // O-Ring groove for dynamic seal. TODO: get real measure!
    g_depth = or_cs * 1.0;
    g_width = or_cs * 1.0;
    g_diam  = pin_diam + g_depth * 2;
    pin_clearance  = 0.1;
    head_clearance = 0.3;

    // Main hole with clevis pin head seat.
    translate([0, 0, -interf]) cylinder_outer((pin_diam  + pin_clearance)  / 2, lenght + interf * 2, smalld_fn);
    translate([0, 0, -interf]) cylinder_outer((head_diam + head_clearance) / 2, head_height + interf, smalld_fn);

    // O-Ring seats.
    translate([0, 0, head_height + or_rim]) cylinder_mid(g_diam / 2, g_width, smalld_fn);
    translate([0, 0, lenght - g_width - or_rim]) cylinder_mid(g_diam / 2, g_width, smalld_fn);
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
module clevis_pin_hole_3_16(lenght, or_cs) {
    A   = 3 / 16 * 25.4;	// pin_diam
    B   = 0.310 * 25.4;		// head_diam
    C   = 0.040 * 25.4;		// head_height
    clevis_pin_hole(A, B, C, lenght, or_cs);
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
module clevis_pin_3_16() {
    A   = 3 / 16 * 25.4;	// pin_diam
    L   = 18;			// pin_length
    LE  = 15;			// pin_length_effective
    PC  = 0.030 * 25.4;		// pin_chamfer
    PCA = 45;			// pin_chamfer_angle
    B   = 0.310 * 25.4;		// head_diam
    C   = 0.040 * 25.4;		// head_height
    D   = 0.020 * 25.4;		// head_chamfer
    HCA = 45;			// head_chamfer_angle
    DG  = 0.148 * 25.4;		// groove_d
    G   = 0.030 * 25.4;		// groove_width
    clevis_pin(A, L, LE, PC, PCA, B, C, D, HCA, DG, G);
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
module clevis_pin_1_4() {
    A   = 1 / 4 * 25.4;		// pin_diam
    L   = 26;			// pin_length
    LE  = 22;			// pin_length_effective
    PC  = 0.030 * 25.4;		// pin_chamfer
    PCA = 45;			// pin_chamfer_angle
    B   = 0.370 * 25.4;		// head_diam
    C   = 0.090 * 25.4;		// head_height
    D   = 0.030 * 25.4;		// head_chamfer
    HCA = 45;			// head_chamfer_angle
    DG  = 0.212 * 25.4;		// groove_d
    G   = 0.030 * 25.4;		// groove_width
    clevis_pin(A, L, LE, PC, PCA, B, C, D, HCA, DG, G);
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
module clevis_pin_3mm() {
    A   = 3.0;			// pin_diam
    L   = 26;			// pin_length
    LE  = 22;			// pin_length_effective
    PC  = 0.030 * 25.4;		// pin_chamfer
    PCA = 45;			// pin_chamfer_angle
    B   = 5;			// head_diam
    C   = 0.090 * 25.4;		// head_height
    D   = 0.030 * 25.4;		// head_chamfer
    HCA = 45;			// head_chamfer_angle
    DG  = 0;			// groove_d
    G   = 0;			// groove_width
    clevis_pin(A, L, LE, PC, PCA, B, C, D, HCA, DG, G);
    color("silver") translate([0, 0, LE])
      rotate(a = 90, v = [1, 0, 0])
        cylinder(r=1/2, h = A + 2, center = true, $fn = smalld_fn);
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
module clevis_pin_hole_3mm(lenght, or_cs) {
    A   = 3.0;			// pin_diam
    B   = 5.0;			// head_diam
    C   = 0.040 * 25.4;		// head_height
    clevis_pin_hole(A, B, C, lenght, or_cs);
}

//-------------------------------------------------------------------------
// Cable grommet profile, with groove for O-Ring seal.
//-------------------------------------------------------------------------
module cable_grommet_2d(x, y, g_width, g_depth) {
    rim = 2;
    g_spacing = (y - g_width * 2) / 3;
    difference() {
      union() {
        translate([0, -rim]) square([x / 2, y + rim]);
        translate([0, -rim]) rounded_square([x / 2 + rim, rim], rim / 2);
      }
      translate([x / 2, y]) rotate(a = 45, v = [0, 0, 1]) square(0.7, center = true);
      translate([x / 2 - g_depth, g_spacing + (g_spacing + g_width) * 0]) square([g_depth + interf, g_width]);
      translate([x / 2 - g_depth, g_spacing + (g_spacing + g_width) * 1]) square([g_depth + interf, g_width]);
    }
}

//-------------------------------------------------------------------------
// Grommet for power cable pass-through.
// The X axis is along the stright edge, the Y is on the rounded edge,
// the Z axis is along the power cable.
//-------------------------------------------------------------------------
module cable_grommet(x, y, z) {
    cable_d = power_cable_d;
    g_depth = o_ring_cable_grommet_groove_depth;
    g_width = o_ring_cable_grommet_groove_width;
    d2 = cable_d * 1.4;
    rim = 2;
    $fn = rounded_fn;
    difference() {
      union() {
        translate([(y - x) / 2, 0, 0]) rotate_extrude(convexity = 10) cable_grommet_2d(y, z, g_width, g_depth);
        translate([(x - y) / 2, 0, 0]) rotate_extrude(convexity = 10) cable_grommet_2d(y, z, g_width, g_depth);
        translate([0, 0, z / 2])  cube(size = [x - y, y - g_depth * 2, z], center = true);
        translate([(y -x) / 2, 0, 0]) rotate(a =  90, v = [0, 0, 1]) rotate(a = 90, v = [1, 0, 0]) linear_extrude(height = x - y, convexity = 10) cable_grommet_2d(y, z, g_width, g_depth);
        translate([(x -y) / 2, 0, 0]) rotate(a = 270, v = [0, 0, 1]) rotate(a = 90, v = [1, 0, 0]) linear_extrude(height = x - y, convexity = 10) cable_grommet_2d(y, z, g_width, g_depth);
        translate([0, 0, -rim]) o_ring(d2, rim);
      }
      // The hole.
      translate([0, 0, (z - rim) / 2]) cylinder(r = cable_d / 2, h = (z + rim + interf * 2), center = true, $fn = smalld_fn);
      translate([0, 0, -(rim + interf)]) cylinder(r1 = d2 / 2, r2 = cable_d / 2, h = rim + 2.0 + interf, $fn = smalld_fn);
    }
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
module cable_grommet_half(x, y, z) {
    rim = 2;
    x1 = x + rim * 2 + interf;
    y1 = y / 2 + rim + interf;
    z1 = z + rim * 1.5 + interf * 2;
    difference() {
        cable_grommet(x, y, z);
        translate([-x1 / 2, 0, -rim * 1.5 - interf]) cube(size = [x1, y1 ,z1]);
    }
}

//-------------------------------------------------------------------------
// Generic bolt with self-locking nut.
//-------------------------------------------------------------------------
module bolt(screw_d, screw_l, head_d, head_l, nut_wrench, nut_l) {
    // Nut diameter from wrench size. Metric nuts: M2.5 = 5, M3 = 5.5
    nut_d = nut_wrench * (2 / 3 * sqrt(3));
    nut_hexagon_h = screw_d / 1.25;
    translate([0, 0, screw_l / 2 - interf])
        cylinder(r =  screw_d / 2, h = screw_l + interf, center = true, $fn = smalld_fn);
    translate([0, 0, -head_l / 2])
        cylinder(r = head_d / 2, h = head_l, center = true, $fn = smalld_fn);
    translate([0, 0, screw_l - nut_l - 0.65])
        cylinder(r = nut_d / 2, h = nut_hexagon_h, $fn = 6);
    translate([0, 0, screw_l - nut_hexagon_h - 0.65 ]) {
        difference() {
            sphere(r = nut_wrench / 2, $fn = smalld_fn);
            translate([0, 0, -nut_wrench / 2]) cube(size = nut_wrench, center = true);
        }
    }
}


//-------------------------------------------------------------------------
// Specific bolt: M2.5, with 5 mm head diam, nut wrench 5 mm.
//-------------------------------------------------------------------------
module bolt_m2p5(lenght) {
    bolt(2.5, lenght, 5, 2, 5, 3.5);
}
