# Do It Yourself, 3D-Print, IP64 Waterproof Case for generic Smartphone

An OpenSCAD model of a smartphone case, suitable for motorbike mounting and GPS navigation.

* Main body and front frame made with 3d-printed nylon; allow GPS signal reception.
* Aluminium back panel (laser cut) and silicone padding for heat dissipation; should operate under summer direct sunlight.
* The screen is protected by a PETG sheet (laser cut).
* At least IP64 protection: dust proof and water splashing from any directions.
* Customizable for any smartphone, just input the measures and 3D-print it!
* Passthrough hole for power cable.
* Operating smartphone side buttons.

**NOTICE**: This project is still in beta stage, the object was not actually build yet.

## The OpenSCAD model

![Rendering](./img/proj-assembling-test.png)

### Parametric Project

You should set at least the size of your device (smartphone) and the position of
the side buttons (at the moment only le right side is coded). Browse the
**ip64-smartphone-case.scad** and search for **phone_x**, **phone_y**, **phone_z**
variables. Buttons coordinates are **btn_power_y**, **btn_vol_up_y** and **btn_vol_down_y**.

### Exploded View

Open the **proj-assembling-test.scad** file and see the preview. To see an exploded
view, set the **exploded** variable to a value greather than zero (it is millimters,
try with 20).

* 2D print test.

## 3D Printed parts

* Main body.
* Front frame.

## Laser cut parts

* Aluminium back panel.
* PETG screen cover sheet.

## Miscellaneus parts to be purchased separately

* Clevis pins to operate the smartphone side buttons.
* O-Rings for clevis pins.
* O-Rings for power cable grommet.
* O-Ring cord for main body seal.
* Nuts and bolts for main body assembly.
* Thermally conductive silicone rubber.
