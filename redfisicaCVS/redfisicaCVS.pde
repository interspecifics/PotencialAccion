
/*-----------------------------------
 Library: ComputationalGeometry
 By: Mark Collins & Toru Hasegawa
 //Modificado el 14/11/2014 
 less
 ------------------------------------*/

import oscP5.*; 
import netP5.*; 
import ComputationalGeometry.*;

OscP5 oscP5;
IsoSkeleton skeleton;

int puerto;
float AF3;
float F7;
float F4;
float F8;

void setup() {
  size(650, 650, P3D);
  puerto = 11111;
  oscP5 = new OscP5(this, puerto);
  
  // Create iso-skeleton 
  for (int i = 0; i <= 13; i++)

    skeleton = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[200];
  for (int i=0; i<pts.length; i++) {
    pts[i] = new PVector(random(-90, 90), random(-90, 90), random(-90, 90) );
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
  float sp = 0.02 * frameCount*(24);
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);

  stroke(0, 0, 0, 25);
  for (int i = 0; i <= 5; i++) {
    skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY/8) / (2.0*height));  // Thickness as parameter
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/AF3")==true) { // si la dirección es "x"
    if (theOscMessage.checkTypetag("f")) {          // si el dato que trae el mensaje es un float
      AF3 = theOscMessage.get(0).floatValue();        // extraemos el primer dato (0) y se lo asignamos a x 
      println("Reciviendo--> val AF3: "+ AF3);
      return;
    }
  }
  
  if (theOscMessage.checkAddrPattern("/F7")==true) { // si la dirección es "y"
    if (theOscMessage.checkTypetag("f")) {              // si el dato que trae el mensaje es un float
      F7 = theOscMessage.get(0).floatValue();      // extraemos el primer dato (0) y se lo asignamos a y 
      println("Reciviendo--> val F7: "+ F7);
      return;
    }
  }
}

