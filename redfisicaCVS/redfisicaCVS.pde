
/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
//Modificado el 14/11/2014 
less
------------------------------------*/

import ComputationalGeometry.*;
IsoSkeleton skeleton;
Table table;

void setup() {
  color(23, 45, 68);
  table = loadTable("Recordings.csv", "header");
  println(table.getRowCount() + " total rows in table"); 

  size(650, 650, P3D);

  // Create iso-skeleton 
  for (int i = 0; i <= 13; i++)
  
  skeleton = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[300];
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
  float sp = 0.021 * frameCount*(24);
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  stroke(0,0,0, 25);
  fill(166,80,153, 25);
  for (int i = 0; i <= 5; i++) {
  skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY/8) / (2.0*height));  // Thickness as parameter
 }
}
