//-------------------------------------------------------------------------
// CC-By-SA Niccolo Rigacci <niccolo@rigacci.org>
//-------------------------------------------------------------------------

include <ip64-smartphone-case.scad>;

// Smoothness of rounded angles.
rounded_fn = 92;

// Smoothness of small diameters (pin and holes).
smalld_fn = 64;

//-------------------------------------------------------------------------
// The main body, with pin button holes.
//-------------------------------------------------------------------------
difference() {
  body();
  translate([margin + phone_x, margin + connector_space_y + padding_thick, btn_z]) {
    rotate(a=90, v=[0, 1, 0]) {
      for (y = btn_right_pos_y) {
        translate([0, y, 0]) clevis_pin_hole_3mm(margin, or_pins_cs);
      }
    }
  }
}

//-------------------------------------------------------------------------
// The front cover with screw head seats and reinforcing profile.
//-------------------------------------------------------------------------
translate([0, 0, case_z + 1]) {
    difference() {
        front_panel();
        translate([case_x / 2, margin, top_thick - 0.2])
            linear_extrude(height = interf + 0.2, convexity = 20)
                text("OpenStreetMap.Org", font = "Liberation Sans", size = 5, valign = "bottom", halign = "center", $fn = 32);
    }
}

//-------------------------------------------------------------------------
// Power connector grommet.
//-------------------------------------------------------------------------
translate([case_x / 2, case_y * 0.3, case_z / 2])
  rotate(a = -90, v=[1, 0, 0])
    cable_grommet(connector_space_x, connector_space_z, margin);
