// inflated pouches for part two
//params
pouch_count = 5;
base_radius = 5;
height = 8;
squish_factor = 0.8;     
valve_radius = 0.6;
valve_height = 1.8;

// single
module inflated_pouch(r=base_radius, h=height, col=[0.7,0.7,0.75,0.5]) {
// main
    color(col)
    scale([1,1,squish_factor])
        sphere(r=r, $fn=80);

// Weld
    color([0.5,0.5,0.55,0.7])
    difference() {
        scale([1,1,squish_factor])
            sphere(r=r*1.02, $fn=80);
        scale([1,1,squish_factor])
            sphere(r=r, $fn=80);
    }

 
    translate([0,0,r*squish_factor + valve_height/2])
        color([0.6,0.6,0.6])
        cylinder(r=valve_radius, h=valve_height, center=true, $fn=30);

  
    translate([0,0,r*squish_factor + valve_height])
        color([0.3,0.3,0.3])
        sphere(r=valve_radius*0.8, $fn=20);
}


module pouch_cluster() {
    for(i=[0:pouch_count-1]) {
        angle = i * 360/pouch_count;
        dist = base_radius*2.2;
        offset = (i % 2 == 0) ? 1 : -1;
        translate([cos(angle)*dist, sin(angle)*dist, offset])
            rotate([rand(-10,10), rand(-10,10), rand(0,360)])
                inflated_pouch(r=base_radius + rand(-0.8,0.8),
                               h=height + rand(-1,1));
    }
}


pouch_cluster();
