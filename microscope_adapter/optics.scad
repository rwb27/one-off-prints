/******************************************************************
*                                                                 *
* Raspberry Pi camera adapter for Motic BA210E Microscope         *
*                                                                 *
* This camera tube fits onto the camera port of a Motic BA210E
* and contains a lens to correct for the camera's small sensor.
*
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/



use <utilities.scad>;
use <picam_2_screw_on.scad>;

dt_bottom = -2; //where the dovetail starts (<0 to allow some play)
camera_mount_top = dt_bottom - 3;
bottom = camera_mount_top-camera_mount_height(); //nominal distance from PCB to microscope bottom
//Comar 40mm lens
tube_lens_ffd=38; //front focal distance (from flat side of lens to image
tube_lens_f=40; //nominal focal length of lens
//*/
tube_lens_r=16/2+0.1; //radius of lens
tube_lens_aperture=16/2-1; //clear aperture of lens

pedestal_h=2; //height of the pedestal on which the lens sits

d = 0.05;
$fn=24;

//////////////// Dovetail Geometry //////////////////////////////
//The camera port accepts a tube.  The fitting is cylindrical, 37.7mm OD (hole is 37.9) and 8mm deep, with no internal Z stop.  There's a taper for the mounting screw; the inserted part is 37.7mm for 2mm, then tapers over 3mm to 34.7, then maintains that for 2mm and has a 1mm bit next to the flange.  The outer diameter of the attachment is 50.7mm (2"?), so we'll need a flange about that size to set the position in Z.
    
///////////////// Lens position calculation //////////////////////////
// calculate the position of the tube lens based on a thin-lens approximation: the light is focussing from the microscope to a point ~80mm above the flange (I suspect this should be more like 70mm) which corresponds to z=-80mm here.  We want to place the lens such that the focal point is z=0, the camera sensor plane.
    // dos = distance from "objective" to sensor (i.e. from microscope to sensor
    // dts = distance from tube lens to sensor
    // ft = focal length of tube lens
    // fo = tube length of objective lens
    // then 1/dts = 1/ft + 1/(fo-dos+dts)
    // the solution to this, if b=fo-dos and a=ft, is:
    // dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b)
// here, we actually measure b (distance from the sensor plane to the image)
    a = tube_lens_f;
    b = 75-1; //distance from flange to image minus thickness of mount
    dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b);
    echo("Distance from tube lens principal plane to sensor:",dts);
    // that's the distance to the nominal "principal plane", in reality
    // we measure the front focal distance, and shift accordingly:
    tube_lens_z = dts - (tube_lens_f - tube_lens_ffd); //height of lens
    lens_assembly_z = tube_lens_z - pedestal_h; //height of lens assembly
    lens_assembly_r = tube_lens_r + 2;
    


module lens_gripper(lens_r=10,h=6,lens_h=3.5,base_r=-1,t=0.65,solid=false, flare=0.4){
    // This creates a tapering, distorted hollow cylinder suitable for
    // gripping a small cylindrical (or spherical) object
    // The gripping occurs lens_h above the base, and it flares out
    // again both above and below this.
    trylinder_gripper(inner_r=lens_r, h=h, grip_h=lens_h, base_r=base_r, t=t, solid=solid, flare=flare);
}

module tube_lens_gripper(){
    // This assembly holds a correcting "tube" lens at z=2mm.
    union(){
        lens_gripper(lens_r=tube_lens_r, base_r=lens_assembly_r, lens_h=3.5,h=pedestal_h+4);
        difference(){
            cylinder(r=tube_lens_aperture + 1.0,h=pedestal_h);
            cylinder(r=tube_lens_aperture,h=999,center=true);
        }
    }
}
    
difference(){
    /// Camera adapter tube for microscope
    union(){
        sequential_hull(){
            //this part mounts to the dovetail
            cylinder(d=50.8, h=1);
            translate([0,0,1]) cylinder(d=37.7, h=d);
            translate([0,0,2]) cylinder(d=37.7, h=d);
            translate([0,0,2]) cylinder(d=34.7, h=d);
            translate([0,0,4]) cylinder(d=34.7, h=d);
            translate([0,0,7]) cylinder(d=37.7, h=2);
        }
        //tube to mount the lens on
        cylinder(r=lens_assembly_r, h=lens_assembly_z+d);
        translate([0,0,lens_assembly_z]) tube_lens_gripper();
    }
    
    //cut-out for the camera
    picam2_cutout();
    
    //cut-out for the beam
    translate([0,0,8]) cylinder(r1=4, r2=tube_lens_aperture, h=lens_assembly_z+d-8);
                
    //rotate([90,0,0]) cylinder(r=999,h=999,$fn=8);
    //mirror([0,0,1]) cylinder(r=999,h=999,$fn=8);
}
