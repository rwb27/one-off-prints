use <utilities.scad>;

well_plate_size = [127.8, 85.5] + [1,1]*0.5; //it's half a millimetre too big for ease of insertion/removal
wall_t = 1.5;
lip_t = 3;
holder_h = 3;
wall_h = 3;
bucket_h = 22;
d=0.05;

top_part = false;
bottom_part = true;

module well_plate(){
    difference(){
        square(well_plate_size, center=true);
        
        translate(well_plate_size/2) rotate(45) square(7, center=true);
    }
}

module finger_slots(){
    slot = [30,10+wall_t*2,0];
    sr = max(slot)/2;
    reflect([0,1,0]) translate([0,well_plate_size[1]/2+wall_t,0]) resize(slot) union(){
        translate([0,0,2]) cylinder(r1=d, r2=sr, h=bucket_h-2+d);
        translate([0,0,bucket_h]) cylinder(r=sr, h=999);
    }
}

    
module plate_holder() {
    // a thin plastic tray that fits under a multi well plate
    difference(){
        linear_extrude(holder_h + wall_h) offset(wall_t) well_plate();
        
        translate([0,0,holder_h]) linear_extrude(999) well_plate(); //this is where the well plate sits
        translate([0,0,0.75]){
            linear_extrude(999) offset(-lip_t) well_plate(); //this is the hollow under the plate
            intersection(){
                linear_extrude(999) well_plate(); //this is the wider hollow under the middle of the plate
                cube(well_plate_size[0]-30, center=true);
            }
        }
        
        translate([0,0,-bucket_h]) finger_slots();
    }
}
module plate_holder_silhouette(){
    // 2D projection of the above
    projection() plate_holder();
}

module bucket(){
    difference(){
        bwh = wall_h - 1; //height of the wall around the top of the bucket
        linear_extrude(bucket_h + bwh) offset(wall_t) plate_holder_silhouette();
        
        translate([0,0,bucket_h]) linear_extrude(999) offset(0.25) plate_holder_silhouette(); //this is where the holder sits
        translate([0,0,0.75]){
            linear_extrude(999) offset(-1) plate_holder_silhouette(); //this is the hollow under the plate
        }
    }
}

if(top_part) translate([0,0,bucket_h]) plate_holder();
if(bottom_part) bucket();
