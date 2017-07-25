// Static mounts for a HeNe tube
// (c) R Bowman 2017, released under CERN open hardware license

use <utilities.scad>;

tube_d = 44.5; //diameter of the tube we want to clamp

module tube_cutout(d=tube_d, h=999, center=true, roc=15, dr=1.5){
    // Something between a hexagon and a circle...
    r = tube_d/2 - roc;
    echo((r+dr - r*cos(60))/sin(60));
    hull(){
        for(a=[0,120,-120]) rotate(a) reflect([1,0,0]){
            translate([(r+dr - r*cos(60))/sin(60),tube_d/2-roc, 0]) cylinder(r=roc, h=h, center=center);
        }
    }
}

difference(){
    cube([100,100,10],center=true);
    tube_cutout();
}