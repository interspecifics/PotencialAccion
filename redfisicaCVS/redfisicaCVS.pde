
/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
//Modificado el 14/11/2014 
less
------------------------------------*/

// multiple channel clusters
// color per channel
// average count per dataset per channel 

import ComputationalGeometry.*;
import java.io.FileReader;
import java.io.FileNotFoundException;
BufferedReader mBr;
int lastFileRead;
IsoSkeleton skeleton;
Table table;

void setup() {
  size(650, 650, P3D);


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
  
  try {
    mBr = new BufferedReader(new FileReader(dataPath("gibran-03-18.11.2014.10.48.08.csv")));
    mBr.readLine();
  }
  catch(Exception e) {}
 
  lastFileRead = millis();
}

void draw() {
      background(220);




  if (millis()-lastFileRead > 5) {
    try {
      String line = mBr.readLine();
      if (line == null) {
        mBr.close();
        mBr = new BufferedReader(new FileReader(dataPath("gibran-03-18.11.2014.10.48.08.csv")));
        mBr.readLine();
      }
 
      // valArray es un array de Strings con los valores
      String[] valArray = line.trim().split("\\s*,\\s*");
      // aqui se saca los valores de float de los Strings
      for (int i=0; i<valArray.length; i++) {
        float f = Float.valueOf(valArray[i]);
        print(i+":"+f+ "   ");
      }
      println();
    }
    catch(Exception e) {}
 
    lastFileRead = millis();
  }
  lights();  
  float zm = 150;
  float sp = 0.02 * frameCount*(24);
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  stroke(0,0,0, 25);
  for (int i = 0; i <= 5; i++) {
  skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY/8) / (2.0*height));  // Thickness as parameter
 }
}
