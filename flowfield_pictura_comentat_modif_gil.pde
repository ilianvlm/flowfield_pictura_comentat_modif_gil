// Flow Field Following
// Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

import java.io.*;


boolean debug = false;
PImage fundal;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

void setup() {
  fundal=loadImage ("europa.jpg");
  size(fundal.width, fundal.height, P3D);
  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehicle>();
  incarca();
}
int k=1;
void draw() {
  background(0);
    //image (fundal,0,0);
  if (vehicles.size()<35520) { //35520 
    for (int i=0; i<k;i++) {

      vehicles.add(new Vehicle(new PVector(random(800,885), random(570,635)), random(2, 5), random(0.1, 2)));
    }
    frame.setTitle("nr particule:"+vehicles.size());
    if (frameCount %9==0){k++;}
  }
  //image (fundal,0,0);
  // Display the flowfield in "debug" mode
  if (debug) flowfield.display();
  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run();
  }

  fill(0);
  
}


void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

void incarca ()
{
  try {
    FileInputStream saveFile = new FileInputStream(sketchPath("flowfield.sav"));
    ObjectInputStream save = new ObjectInputStream(saveFile);
    flowfield.resolution = (Integer) save.readObject();
    flowfield.cols = (Integer) save.readObject();
    flowfield.rows = (Integer) save.readObject();
    flowfield.field = (PVector[][]) save.readObject();
    save.close();
  }
  catch(Exception exc) {
    exc.printStackTrace(); // If there was an error, print the info.
    println ("failure to load");
  }
}

