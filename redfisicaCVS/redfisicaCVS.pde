
/*-----------------------------------
 Library: ComputationalGeometry
 lIBRARY: oscP5
 lIBRARY: netP5
 //Modificado el 14/11/2014 
 Para Potencaial de acción 
 //lIBR
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
  size(750, 750, P3D);
  puerto = 11111;
  oscP5 = new OscP5(this, puerto);
  
  // Create iso-skeleton 
  for (int i = 0; i <= 13; i++)

    skeleton = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[150];
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
  background(255,255,255);
  lights();  
  float zm = 150;
  float sp = 0.02 * frameCount*(24);
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);

  stroke(0);
    fill(45, random(4, 232), 9);

  for (int i = 0; i <= 5; i++) {
    skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY/8) / (2.0*height));  // Thickness as parameter
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/AF3")==true) { // si la dirección es "x"
    if (theOscMessage.checkTypetag("f")) {          // si el dato que trae el mensaje es un float
      AF3 = theOscMessage.get(0).floatValue();      // extraemos el primer dato (0) y se lo asignamos a x 
      println("Recibiendo--> val AF3: "+ AF3);
      return;
    }
  }
  
  
  if (theOscMessage.checkAddrPattern("/F7")==true) { // si la dirección es "y"
    if (theOscMessage.checkTypetag("f")) {              // si el dato que trae el mensaje es un float
      F7 = theOscMessage.get(0).floatValue();      // extraemos el primer dato (0) y se lo asignamos a y 
      println("Recibiendo--> val F7: "+ F7);
      return;
    }
  }
}

