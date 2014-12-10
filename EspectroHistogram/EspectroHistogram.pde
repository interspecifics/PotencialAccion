import gab.opencv.*;

OpenCV opencv;
Histogram grayHist, rHist, gHist, bHist;

PImage img;

void setup() {
  size(1250, 700);
  img = loadImage("S1-ev1-F3-.png");
  opencv = new OpenCV(this, img);

  grayHist = opencv.findHistogram(opencv.getGray(), 256);
  rHist = opencv.findHistogram(opencv.getR(), 256);
  gHist = opencv.findHistogram(opencv.getG(), 256);
  bHist = opencv.findHistogram(opencv.getB(), 256);
}

void draw() {
  background(0);
//carga el espectrograma
  image(img, 10, 10, 700, 390);
 
 stroke(225); fill(225);  
  rect(10, 398, 700, 4);
 
  stroke(0); fill(0);  
  rect(40, 398, 4, 4);  
 
//dibuja el canal gris
  stroke(125); noFill();  
  rect(720, 10, 510, 390);  
  fill(125); noStroke();
  grayHist.draw(720, 10, 510, 390);

//dibuja el canal rojo
  stroke(255, 0, 0); noFill();  
  rect(10, height - 280, 400, 240);
  fill(255, 0, 0); noStroke();
  rHist.draw(10, height - 280, 400, 240);

//dibuja canal verde
  stroke(0, 255, 0); noFill();  
  rect(420, height - 280, 400, 240);
  fill(0, 255, 0); noStroke();
  gHist.draw(420, height - 280, 400, 240);

  stroke(0, 0, 255); noFill();  
  rect(830, height - 280, 400, 240);
  fill(0, 0, 255); noStroke();
  bHist.draw(830, height - 280, 400, 240);
  
  println("X = "+ img.height);
  println("Y = " +img.width); 
}


