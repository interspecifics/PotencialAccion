
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
IsoSkeleton skeleton;
IsoSkeleton skeleton1;
IsoSkeleton skeleton2;


Table table;

void setup() {
  table = loadTable("Recordings.csv", "header");
  println(table.getRowCount() + " total rows in table"); 

  size(1200, 900, P3D);

  // Create iso-skeleton 
  for (int i = 0; i <= 10; i++)
  
  skeleton = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[30];
  for (int i=0; i<pts.length; i++) {
    pts[i] = new PVector(random(-20, 50), random(-20, 50), random(-20, 50) );
  }  

  for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 50) {
        skeleton.addEdge(pts[i], pts[j]);
     
      }
    }
    
      // Create iso-skeleton 
  for (int ij = 0; ij <= 10; ij++)
  
  skeleton1 = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] ptsb = new PVector[30];
  for (int ij=0; ij<ptsb.length; ij++) {
    ptsb[ij] = new PVector(random(0, 90), random(0, 90), random(0, 90) );
  }  

  for (int ij=0; ij<ptsb.length; ij++) {
    for (int j=ij+1; j<ptsb.length; j++) {
      if (ptsb[ij].dist( ptsb[j] ) < 60) {
        skeleton1.addEdge(ptsb[ij], ptsb[j]);
     
      }
    }
  }
  // Create iso-skeleton 
  for (int ij = 0; ij <= 10; ij++)
  
  skeleton2 = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] ptsA = new PVector[20];
  for (int iC=0; iC<ptsA.length; iC++) {
    ptsA[iC] = new PVector(random(-10, 70), random(-10, 70), random(-10, 70) );
  }  

  for (int iC=0; iC<ptsA.length; iC++) {
    for (int j=iC+1; j<ptsA.length; j++) {
      if (ptsA[iC].dist( ptsA[j] ) < 60) {
        skeleton2.addEdge(ptsA[iC], ptsA[j]);
     
      }
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
  

  stroke(127,12,128);
  for (int i = 0; i <= 5; i++) {
  skeleton.plot(10.f * float(mouseX/32) / (0.1f*width/2), float(mouseY/32) / (0.1*height/2));  // Thickness as parameter
 }

  stroke(110,199,217);
  for (int ij = 0; ij <= 5; ij++) {
  skeleton1.plot(10.f * float(mouseX/32) / (0.1f*width/2), float(mouseY/32) / (0.1*height/2));  // Thickness as parameter
}

  stroke(21,130,129);
  for (int ij = 0; ij <= 5; ij++) {
  skeleton2.plot(10.f * float(mouseX/32) / (0.1f*width/2), float(mouseY/32) / (0.1*height/2));  // Thickness as parameter
}
}
