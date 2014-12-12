
/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
//Modificado el 14/11/2014 
less
------------------------------------*/

import ComputationalGeometry.*;
IsoSkeleton skeleton;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;


void setup() {
  size(650, 650, P3D);
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[3], 57600);
  // Create iso-skeleton
  
  for (int i = 0; i <= 13; i++)
    arduino.pinMode(i, Arduino.INPUT);
  
  skeleton = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[100];
  for (int i=0; i<pts.length; i++) {
    pts[i] = new PVector(random(-100, 100), random(-100, 100), random(-100, 100) );
  }  

  for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 50) {
        skeleton.addEdge(pts[i], pts[j]);
      }
    }
  }
}

void draw() {

  
  background(220);
  lights();  
  float zm = 150;
  float sp = 0.001 * frameCount*(120);
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  noStroke();  
  for (int i = 0; i <= 5; i++) {
  skeleton.plot(10.f * float(arduino.analogRead(i)/16) / (2.0f*width), float(arduino.analogRead(i)/8) / (2.0*height));  // Thickness as parameter
 }
}
