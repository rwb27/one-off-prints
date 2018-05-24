// Static mounts for a HeNe tube
// (c) R Bowman 2017, released under CERN open hardware license

use <utilities.scad>;

tube_d = 44.5; //diameter of the tube we want to clamp

module tube_cutout(d=tube_d, h=999, center=true, roc=15, dr=1.5){
    // Something between a hexagon and a circle...
    r = d/2 - roc;
    echo((r+dr - r*cos(60))/sin(60));
    hull(){
        for(a=[0,120,-120]) rotate(a) reflect([1,0,0]){
            translate([(r+dr - r*cos(60))/sin(60),tube_d/2-roc, 0]) cylinder(r=roc, h=h, center=center);
        }
    }
}

t = 10;
flat = t;

difference(){
    union(){
        hull(){
            s = (tube_d + 8)/tube_d;
            scale([s,s,1]) tube_cutout(d=tube_d, h=t);
            cube([tube_d + flat*2,8,t],center=true);
            translate([0,-75+1,0]) cube([40,2,t], center=true);
        }
        hull() reflect([1,0,0]){
            translate([-25-t/2,-75,-t/2]) cube([t,4,t]);//rotate([90,0,0]) cylinder(d=t, h=4);
        }
    }
    
    tube_cutout();
    reflect([1,0,0]) translate([tube_d/2+flat/2+0.5, 0,0]) pinch_y(3, top_access=true, screw_l=20);
    reflect([1,0,0]) translate([-25,-75,0]) rotate([90,0,0]) cylinder(d=6.6, h=10, center=true);
    translate([0,-75,0]) rotate([90,0,0]) cylinder(d=6.6, h=20, center=true);
    
    hull(){
        translate([0,-65,0]) cube([25,5,999],center=true);
        translate([0,-30,0]) cube([40,1,999],center=true);
    }
}