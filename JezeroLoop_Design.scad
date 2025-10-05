// Jezero loop
central_radius = 25;
central_height = 25;

num_modules = 6;
module_radius = 10;
module_height = 20;

connector_radius = 3;
connector_length = 45;
ring_thickness = 4;
spacing = 55;

layer_thickness_eva = 1.2;
layer_thickness_mesh = 1.0;
layer_thickness_carbon = 1.3;
total_layer = layer_thickness_eva + layer_thickness_mesh + layer_thickness_carbon;

groove_count = 6;
groove_depth = 0.4;


module habitat_module(r, h, col) {
    color(col)
    cylinder(r=r, h=h, center=true, $fn=60);

    color([0.25,0.25,0.25])
    difference() {
        cylinder(r=r+total_layer, h=h+2, center=true, $fn=60);
        cylinder(r=r, h=h+3, center=true, $fn=60);
    }
}

module internal_robotics() {
    z_center = 0;

    translate([0,0,z_center - central_height/2 + 2])
        color([0.45,0.45,0.45,0.9])
        cylinder(r=central_radius*0.8, h=1, center=false, $fn=80);

    translate([0,0,z_center])
        color([0.7,0.7,0.7,0.9])
        cylinder(r=central_radius*0.18, h=3, center=true, $fn=50);

    for(a=[0:60:300]) {
        angle = a;
        rotate([0,0,angle]) {
            translate([central_radius*0.2,0,z_center])
                color([0.8,0.8,0.8,0.9])
                cylinder(r=0.6, h=central_radius*0.45, center=false, $fn=24);

            translate([central_radius*0.65,0,z_center])
                color([0.9,0.9,0.9,0.9])
                sphere(r=1.0, $fn=30);
        }
    }

    translate([0,0,z_center - 3])
        color([0.5,0.5,0.5,0.9])
        difference() {
            cylinder(r=central_radius*0.75, h=0.8, center=true, $fn=80);
            cylinder(r=central_radius*0.7, h=1.0, center=true, $fn=80);
        }

    color([0.55,0.55,0.55,0.9])
    for(a=[0:60:300]) {
        rotate([0,0,a])
        translate([0,-0.4,z_center - central_height/2 + 2])
            cube([central_radius*0.75,0.8,0.3], center=false);
    }
}

module central_core() {
    color([0.6,0.6,0.6,0.25])
    cylinder(r=central_radius, h=central_height, center=true, $fn=80);

    color([0.2,0.2,0.2])
    difference() {
        cylinder(r=central_radius+3, h=central_height+2, center=true, $fn=80);
        cylinder(r=central_radius, h=central_height+3, center=true, $fn=80);
    }

    internal_robotics();

    translate([0, 0, central_height/2 + 4])
        label("Central Chamber", 0, 0, 0, 3);
}

module grooved_connector(length, radius) {
    color([0.55,0.55,0.55])
    cylinder(r=radius, h=length, center=true, $fn=50);

    for(i=[0:groove_count-1]) {
        translate([0,0,-length/2 + i*(length/groove_count)])
            color([0.4,0.4,0.4])
            cylinder(r=radius-groove_depth, h=0.2, center=true, $fn=50);
    }
}

module outer_loop_pipe(ring_r, pipe_r) {
    color([0.5,0.5,0.5])
    rotate_extrude($fn=120)
        translate([ring_r,0,0])
            circle(r=pipe_r, $fn=12);
}

module mini_loop_on_top(ring_r, pipe_r, height_offset=3) {
    color([0.5,0.5,0.5])
    rotate_extrude($fn=120)
        translate([ring_r,0,module_height/2 + height_offset])
            circle(r=pipe_r/1.5, $fn=12);
}

module outer_ring(ring_r, thickness, height) {
    color([0.4,0.4,0.4])
    difference() {
        cylinder(r=ring_r, h=height, center=true, $fn=80);
        cylinder(r=ring_r - thickness, h=height+1, center=true, $fn=80);
    }
}

module label(txt,x,y,z,size=3){
    translate([x,y,z])
        color("white")
        linear_extrude(height=0.5)
            text(txt, size=size, font="Ubuntu:style=Bold", halign="center", valign="center");
}

module jezero_loop() {
    central_core();

    module_angles = [0, 60, 120, 180, 240, 300];

    for(i=[0:num_modules-1]) {
        angle = module_angles[i];
        x = cos(angle)*spacing;
        y = sin(angle)*spacing;

        translate([cos(angle)*(spacing/2), sin(angle)*(spacing/2), 0])
            rotate([0,90,angle])
            grooved_connector(connector_length, connector_radius);

        is_green = (i<4);
        col = is_green ? [0.3,0.85,0.3] : [0.35,0.35,0.35];
        label_text = is_green ? "Recycling" : "Carbon Mgmt";

        translate([x, y, 0])
            habitat_module(module_radius, module_height, col);

        translate([x, y, module_height/2+3])
            label(label_text,0,0,0,3);
    }

    outer_ring(spacing, ring_thickness, module_height/2);
    outer_loop_pipe(spacing+ring_thickness+2, 1.5);
    mini_loop_on_top(spacing+ring_thickness+2, 1.5, 3);
}

jezero_loop();
