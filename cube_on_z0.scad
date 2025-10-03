module cube_on_z0 (width, height, thickness) {
    translate(v = [0,0,thickness/2]) {
        cube([width
             ,height
             ,thickness]
            ,center=true);
    }
}


