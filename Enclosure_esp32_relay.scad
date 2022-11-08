//$fa = 1;
//$fs = 0.4;

J = 0.001; //offset for join
wallT = 3;
//enclosure size
enclD = 120;
enclW = 70;
enclH = 45;//2*3+35+1.5;
//percLid = 0.28; //percentage of enclosure that is the lid height
//

//Box Enclosure
module enclosure(
    wallT = 0,
    enclD = 0,
    enclW = 0,
    enclH = 0,
    slide_tol = 1.1
){
    difference(){
        cube([enclD,enclW,enclH]); 
        translate([wallT,wallT,wallT])
        cube([enclD-2*wallT,enclW-2*wallT,enclH-wallT]);
        micro_usb_plug(wallT = wallT);
        relay_wire_holes(wallT = wallT);
        signal_wire_holes(wallT = wallT);
//    };
        //cutouts for lid_slide
        translate([wallT,wallT,enclH-wallT-J])
        cube([enclD,enclW-2*wallT,wallT+2*J]);

        //groove for lid slide
        rotate([90,0,90])
        translate([wallT,enclH-0.5*wallT,wallT])
        linear_extrude(enclD+J)
        circle(wallT*0.3*slide_tol);
        
        rotate([90,0,90])
        translate([enclW-wallT,enclH-0.5*wallT,wallT])
        linear_extrude(enclD+J)
        circle(wallT*0.3*slide_tol);       
    }; 
}

module lid_slide(
    //bring in global variables
    wallT = wallT,
    enclD = enclD,
    enclW = enclD,
    enclH = enclH,
    visZ = 70,       //Move the lid up for viewing purposes
    tol = 0.2
){
    translate([wallT,wallT+tol,enclH-wallT+visZ])
    cube([enclD-wallT,enclW-2*wallT-tol*2,wallT]);
    
    rotate([90,0,90])
    translate([wallT+tol,visZ+enclH-0.5*wallT,wallT])
    linear_extrude(enclD-wallT)
    circle(wallT*0.3);
    
    rotate([90,0,90])
    translate([enclW-wallT-tol,visZ+enclH-0.5*wallT,wallT])
    linear_extrude(enclD-wallT)
    circle(wallT*0.3);
}

//PCB Supports with cutout
module pcb_supports_cutout(
    //bring in global variables
    wallT = 0,
    enclD = 0,
    enclW = 0,
    enclH = 0,

    suppR = 0,      // support post radius
    bdCa = 0,      // Clearance above board
    bdCb = 0,      // Clearance below board
    bdT = 0,        //thickness of pcb
    bdW = 0,       //board Width
    bdD = 0,       //board Depth
    pinH = 0,       //pin Height to hold board
    pinR = 0,        //pin Radius to fit in mounting hole
    //all four posts are referenced to one post near the origin
    Xoff = 0,   //reference post X offset
    Yoff = 0,    //reference post Y offset
    betweenHdr = 0,   //distance between headers
    tol = 0.5
     ){   
    difference(){
        // reference post
        translate([Xoff+bdW*0.5-betweenHdr*0.5+suppR*0.5,
                    Yoff,
                    wallT-J])
        linear_extrude(bdCb) 
        circle(suppR);
        //subtract pcb shape
        translate([Xoff,Yoff+suppR*0.125-tol,wallT+bdCb-bdT])
        cube([bdW,bdD+0.5,bdT+2*J]);
    };
    difference(){
        // distant y post
        translate([Xoff+bdW*0.5-betweenHdr*0.5+suppR*0.5,
                    bdD+Yoff,
                    wallT-J])
        linear_extrude(bdCb)
        circle(suppR);
        //subtract pcb shape
        translate([Xoff,Yoff+suppR*0.125-tol,wallT+bdCb-bdT])
        cube([bdW,bdD+0.5,bdT+2*J]);
    };
    difference(){
        // distant xy post
        translate([Xoff+bdW*0.5+betweenHdr*0.5-suppR*0.5,
                    bdD+Yoff,
                    wallT-J])
        linear_extrude(bdCb)
        circle(suppR);
        //subtract pcb shape
        translate([Xoff,Yoff+suppR*0.125-tol,wallT+bdCb-bdT])
        cube([bdW,bdD+0.5,bdT+2*J]);
    };
    difference(){
        // distant x post
        translate([Xoff+bdW*0.5+betweenHdr*0.5-suppR*0.5,
                    Yoff,
                    wallT-J])
        linear_extrude(bdCb)
        circle(suppR);
        //subtract pcb shape
        translate([Xoff,Yoff+suppR*0.125-tol,wallT+bdCb-bdT])
        cube([bdW,bdD+0.5,bdT+2*J]);
    };
        
//        translate([Xoff,Yoff+suppR*0.125,wallT+bdCb-bdT])
//        cube([bdW,bdD,bdT+J]);
}

//PCB Support with posts
//****** Bottom support posts for corners of pcb
module pcb_supports_posts(
    //bring in global variables
    wallT = 0,
    enclD = 0,
    enclW = 0,
    enclH = 0,

    suppR = 0,      // support post radius
    bdCa = 0,      // Clearance above board
    bdCb = 0,      // Clearance below board
    bdT = 0,        //thickness of pcb
    bdW = 0,       //board Width
    bdD = 0,       //board Depth
    bdWh = 0,       //board Width hole centers
    bdDh = 0,       //board Depth hole centers
    pinH = 0,       //pin Height to hold board
    pinR = 0,        //pin Radius to fit in mounting hole
    //all four posts are referenced to one post near the origin
    Xoff = 0,   //reference post X offset
    Yoff = 0    //reference post Y offset
     ){   

    // reference post
    translate([Xoff,
                Yoff,
                wallT-J])
    linear_extrude(bdCb)
    circle(suppR);
    // distant y post
    translate([Xoff,
                bdDh+Yoff,
                wallT-J])
    linear_extrude(bdCb)
    circle(suppR);
    // distant xy post
    translate([bdWh+Xoff,
                bdDh+Yoff,
                wallT-J])
    linear_extrude(bdCb)
    circle(suppR);
    // distant x post
    translate([bdWh+Xoff,
                Yoff,
                wallT-J])
    linear_extrude(bdCb)
    circle(suppR);
    
    //mounting pins to hold board in place
    // reference post
    translate([Xoff,
                Yoff,
                wallT-J+bdCb])
    linear_extrude(pinH)
    circle(pinR);
    // distant y post
    translate([Xoff,
                bdDh+Yoff,
                wallT-J+bdCb])
    linear_extrude(pinH)
    circle(pinR);
    // distant xy post
    translate([bdWh+Xoff,
                bdDh+Yoff,
                wallT-J+bdCb])
    linear_extrude(pinH)
    circle(pinR);
    // distant x post
    translate([bdWh+Xoff,
                Yoff,
                wallT-J+bdCb])
    linear_extrude(pinH)
    circle(pinR);  
   
    //View board on supports
//    translate([Xoff,Yoff,wallT+bdCb])
//    cube([bdW,bdD,bdT+J]); 
}

module micro_usb_plug(
    //bring in global variables
    wallT = wallT,
    bot_to_cent = wallT+25+1.5+2.6*0.5,    //measure bottom of enclosure to center of hole
    side_to_cent = wallT+5+29*0.5, //measure side to center of hole
    radius = 7,                 //radius of opening
){
    rotate([90,0,0])
    translate([side_to_cent,bot_to_cent,-3*wallT])
    linear_extrude(3*wallT+J)
    circle(radius);
}

module relay_wire_holes(
    //bring in global variables
    wallT = wallT,
    bot_to_cent = wallT+5+1.5+3,    //measure bottom of enclosure to center of hole
    side_to_cent = wallT+5+29+35, //measure side to center of hole
    radius = 1,                 //radius of opening
    o = 5   //offset between holes
){
    for (i=[1:6]){
    rotate([90,0,0])
    translate([o*i+side_to_cent,bot_to_cent,-2*wallT])
    linear_extrude(2*wallT+J)
    circle(radius);
    }
}

module signal_wire_holes(
    //bring in global variables
    wallT = wallT,
    bot_to_cent = wallT+1,    //measure bottom of enclosure to center of hole
    side_to_cent = wallT+5+29+7, //measure side to center of hole
    radius = 2,                 //radius of opening
    o = 5   //offset between holes
){
    for (i=[1:4]){
    rotate([90,0,0])
    translate([side_to_cent,o*i+bot_to_cent,-2*wallT])
    linear_extrude(2*wallT+J)
    circle(radius);
    }
    
    for (i=[1:4]){
    rotate([90,0,0])
    translate([10+side_to_cent,o*i+bot_to_cent,-2*wallT])
    linear_extrude(2*wallT+J)
    circle(radius);
    }
}


//PCB Clamp
module pcb_clamp(
    wallT = 0,
    enclD = 0,
    enclW = 0,
    enclH = 0,
    Height = 13,
    visZ = 30,//-17,  //Move up for viewing, down for clamp location
    W = 4   //width of cube
){
    difference(){
        translate([wallT,wallT,enclH + visZ])
        cube([enclD-2*wallT,enclW-2*wallT,Height]); 
        translate([2*wallT,2*wallT,enclH + visZ-4*J])
        cube([enclD-4*wallT,enclW-4*wallT,Height+8*J]);
        micro_usb_plug(wallT = wallT);
    };
    
    // clamps over the supports with cutouts
    //Close Y
    L1 = 5;
    translate([wallT+5-0.5*W,
                2*wallT,
               enclH + visZ])
    cube([W,L1,Height]);

    translate([wallT+5+29-0.5*W,               
                2*wallT,
                enclH + visZ])
    cube([W,L1,Height]);

    //Distant Y
    L2 = 15;
    translate([wallT+5-0.5*W,
                enclW-2*wallT-L2,
               enclH + visZ])
    cube([W,L2,Height]);

    translate([wallT+5+29-0.5*W,               
                enclW-2*wallT-L2,
                enclH + visZ])
    cube([W,L2,Height]);
    
    
    // clamps over the supports with pins
    //Close Y
    Xoff = wallT+5+29+35;
    L1p = 5;
    E = 17.5;
    translate([Xoff-0.5*W,
                1.5*wallT,
               enclH + visZ-E])
    cube([W,L1p,Height+E]);

    translate([Xoff+33-0.5*W,               
                1.5*wallT,
                enclH + visZ-E])
    cube([W,L1p,Height+E]);

    //Distant Y
    L2p = 12;
    
    translate([Xoff-0.5*W,
                enclW-2*wallT-L2p,
               enclH + visZ-E])
    cube([W,L2p,Height+E]);

    translate([Xoff+33-0.5*W,               
                enclW-2*wallT-L2p,
                enclH + visZ-E])
    cube([W,L2p,Height+E]);
    
}




// *** Instantiation of modules below *******************************
/*
ESP32 with antenna
W = 29mm
D = 49
pcb 1.5mm
above pcb clearance: give 5mm
pins below: give 10mm, with wire, give 25mm total
corner clearance: none
move pins in to center of pcb: max 10mm out from center
    stay in from ends by 10mm to clear buttons and antenna connector

Relay Board
W = 39mm
D = 51mm
pcb = 1.5mm
above pcb clearance: 16mm
below pcb 4mm
corner clearance: 5mm
*/


enclosure(
    wallT = wallT,
    enclD = enclD,
    enclW = enclW,
    enclH = enclH
);

//ESP32 PCB support
//This board does not have corner holes
//locate the support pins between the side pins
pcb_supports_cutout(
    wallT = wallT,
    Xoff = wallT+5, //reference post X offset
    Yoff = wallT+2,    //reference post Y offset
    suppR = 3,      // support post radius
    bdCa = 10,      // Clearance above board
    bdCb = 25,      // Clearance below board
    bdT = 1.5,        //thickness of pcb
    bdW = 29,       //board Width
    bdD = 48.5,       //board Depth
    betweenHdr = 21   //distance between headers
);
//Relay PCB support
pcb_supports_posts(
    wallT = wallT,
    Xoff = wallT+5+29+35,
    Yoff = wallT+6,
    suppR = 2.5,      // support post radius
    bdCa = 20,      // Clearance above board
    bdCb = 5,      // Clearance below board
    bdT = 1.5,        //thickness of pcb
    bdW = 39,       //board Width
    bdD = 51,       //board Depth
    bdWh = 33,       //board Width hole centers
    bdDh = 45,       //board Depth hole centers
    pinH = 2.5,
    pinR = 1
);

 lid_slide(
    wallT = wallT,
    enclD = enclD,
    enclW = enclW,
    enclH = enclH// * percLid
    );

pcb_clamp(
    wallT = wallT,
    enclD = enclD,
    enclW = enclW,
    enclH = enclH
);
