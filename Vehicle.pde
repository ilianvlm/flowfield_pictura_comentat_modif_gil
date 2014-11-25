// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

class Vehicle {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  color culoare;

    Vehicle(PVector l, float ms, float mf) {
    location = l.get();
    r =10;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    color cul =fundal.get(int(location.x),int(location.y));
    culoare=cul;
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    PVector t=force;
    t.div(30);         // mass
    acceleration.add(t);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D();
    //fill(175);
    //stroke(0);
    color pix =fundal.get(int(location.x),int(location.y));
    color pixfinal=lerpColor(culoare,pix,0.04);
    culoare=pixfinal;
    fill (pixfinal,130);
    noStroke();
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    //rect (0,0,r,r);
    ellipse (0,0,r*1.5,r);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
}


