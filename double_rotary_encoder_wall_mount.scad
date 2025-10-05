use <cube_on_z0.scad>
use <claw_mount.scad>

$fn=100;
// Mounting part

face_height           = 65;
face_width            = 81;
mount_total_thickness = 6;
mount_cut_thickness   = 1.5;

faceplate_thickness   = 2;

payload_cutout_width     = 50;
payload_cutout_height    = 27;
payload_cutout_thickness = mount_total_thickness - mount_cut_thickness + 3;

encoder_shaft_diameter = 7;
encoder_shaft_distance = 24.5;
encoder_pin_diameter = 2.5;
encoder_pin_distance = 6;

claw_mount_distance = 42;
claw_mount_height_from_base = 9.5;
claw_mount_total_height = mount_total_thickness + claw_mount_height_from_base;
claw_mount_offset = 4;

tolerance = 0.5;

module claw_mount_y_pos_base() {
    translate(v = [0, claw_mount_distance/2, claw_mount_total_height]) {
        mirror(v = [0,0,1]) {
            rotate(a = [0,0,90]) {
                claw_mount(total_height = claw_mount_total_height);
            }
        }
    }
}

module claw_mount_y_neg_base() {
    mirror(v = [0,1,0]) {
        claw_mount_y_pos();
    }
}

module claw_mount_y_pos() {
    translate(v = [0,-claw_mount_offset,0]) {
        claw_mount_y_pos_base();
    }
}

module claw_mount_y_neg() {
    translate(v = [0,-claw_mount_offset,0]) {
        claw_mount_y_neg_base();
    }
}

module mount_base () {
    cube_on_z0(width = face_width, height = face_height, thickness = mount_total_thickness);
}

module electronics_cutout() {
    translate(v = [0,0,mount_cut_thickness]){
        cube_on_z0(width = payload_cutout_width, height = payload_cutout_height, thickness = payload_cutout_thickness);
    }
}

module encoder_cutout(x, y, pin_distance) {
    translate([x, y, 0]){
        // Shaft hole
        cylinder(h = mount_total_thickness*2, r = encoder_shaft_diameter/2 + tolerance, center=true);
        // Pin hole
        translate([0, pin_distance, 0]){
            cylinder(h = mount_total_thickness*2, r = encoder_pin_diameter/2, center=true);
        }
    }
}

module wall_mount() {
    difference() {
        mount_base();
        electronics_cutout();
        // Space for encoders
        encoder_cutout(x =  encoder_shaft_distance/2, y = 0, pin_distance =  encoder_pin_distance);
        encoder_cutout(x = -encoder_shaft_distance/2, y = 0, pin_distance = -encoder_pin_distance);
        hull() {
            translate(v = [0,0,-claw_mount_total_height/2]) {
                scale(v = [1,1,2]) {
                    claw_mount_y_neg();
                }
            }
        }
        hull() {
            translate(v = [0,0,-claw_mount_total_height/2]) {
                scale(v = [1,1,2]) {
                    claw_mount_y_pos();
                }
            }
        }
    }
    claw_mount_y_neg();
    claw_mount_y_pos();
}

module faceplate() {
    difference() {
        cube_on_z0(width = face_width, height = face_height, thickness = faceplate_thickness);
        translate([encoder_shaft_distance/2, 0, 0]) {
            cylinder(h = mount_total_thickness*2, r = encoder_shaft_diameter/2 + tolerance, center=true);
        }
        translate([-encoder_shaft_distance/2, 0, 0]) {
            cylinder(h = mount_total_thickness*2, r = encoder_shaft_diameter/2 + tolerance, center=true);
        }
    }
}

wall_mount();
// faceplate();