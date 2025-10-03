use <cube_on_z0.scad>

$fn = 100;


module claw_mount(
    claw_hole_width  = 9,
    claw_hole_depth  = 6,
    claw_hole_height = 4,
    claw_hole_offset = 2.2,
    wall_thickness   = 1.5,
    total_height     = 10,
    screw_diameter   = 3.5,
    nut_diameter     = 6.7,
    nut_thickness    = 3
) {

    base_z = nut_thickness + wall_thickness;
    total_y_size = claw_hole_width + 2 * wall_thickness;
    total_x_size = claw_hole_depth + wall_thickness;

    difference() {
        cube_on_z0(width = total_x_size, height = total_y_size, thickness = total_height);


        // Access hole
        translate(v = [-wall_thickness, 0, base_z]) {
            cube_on_z0(width = total_x_size, height = total_y_size - 2 * wall_thickness, thickness = total_height);
        }

        // Claw hole
        translate(v = [wall_thickness, 0, base_z+claw_hole_offset]) {
            cube_on_z0(width = total_x_size, height = claw_hole_width, thickness = claw_hole_height);
        }

        // Screw hole
        cylinder(h = total_height+2*wall_thickness, r = screw_diameter/2, center = true);

        // Nut hole
        cylinder(h = nut_thickness, r = nut_diameter/2, center = true, $fn = 6);
    }
}

// Preview example
// Uncomment to visualize:
claw_mount();
