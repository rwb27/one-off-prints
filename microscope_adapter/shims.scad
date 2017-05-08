/******************************************************************
*                                                                 *
* Raspberry Pi camera adapter for Motic BA210E Microscope         *
*                                                                 *
* This shim allows adjustment of the distance between the camera 
* and the lens.
*
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/



use <utilities.scad>;
use <picam_2_screw_on.scad>;

d = 0.05;
$fn=24;


thicknesses = [0.5, 0.75, 1.0, 2.0];
for(i=[0:3]) translate([i*26,0,0]){
    difference(){
        /// Camera adapter tube for microscope
        t = thicknesses[i];
        translate([0,2.4,t/2]) cube([24, 24, t],center=true);
        
        //cut-out for the camera
        picam2_cutout();
        
    }
}
