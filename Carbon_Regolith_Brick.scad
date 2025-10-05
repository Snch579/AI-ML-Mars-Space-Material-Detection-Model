brick_w = 12;
brick_d = 6;
brick_h = 4;
layer_thicknesses = [0.4, 0.5, 1.0, 0.5, 0.5, 0.4];
layer_colors = [
    [0.45,0.43,0.40,0.4],
    [0.38,0.36,0.33,0.6],
    [0.20,0.20,0.22,1.0],
    [0.32,0.30,0.28,0.8],
    [0.32,0.30,0.28,0.8],
    [0.45,0.43,0.40,0.6]
];
bevel = 0.3;
interlock_offset = 0.2;

module interlocked_brick() {
    zpos = -brick_h/2;
    for(i=[0:len(layer_thicknesses)-1]) {
        t = layer_thicknesses[i];
        col = layer_colors[i];
        x_off = (i % 2 == 0) ? interlock_offset : -interlock_offset;
        y_off = (i % 2 == 0) ? interlock_offset : -interlock_offset;
        color(col)
        translate([x_off, y_off, zpos + t/2])
        minkowski() {
            cube([brick_w - bevel, brick_d - bevel, t], center=true);
            sphere(r=bevel, $fn=16);
        }
        for(s=[-t/2 + 0.1 : 0.2 : t/2 - 0.1]) {
            color([0,0,0,0.05])
            translate([0,0,zpos+s])
                cube([brick_w*0.95, brick_d*0.95, 0.05], center=true);
        }
        zpos = zpos + t;
    }
}

module base_platform() {
    base_thick = 0.5;
    color([0.1,0.1,0.1])
        translate([0,0,-brick_h/2 - base_thick])
            cube([brick_w+1, brick_d+1, base_thick], center=true);
}

union() {
    base_platform();
    interlocked_brick();
}
