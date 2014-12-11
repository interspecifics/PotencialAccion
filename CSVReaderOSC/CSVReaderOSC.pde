import java.io.FileReader;
import java.io.FileNotFoundException;
import oscP5.*; 
import netP5.*;
import controlP5.*;

ControlP5 cp5;

OscP5 oscP5; 
NetAddress direccionRemota;

BufferedReader mBr = null;
int lastFileRead;
String filename;

int puerto;
String ip;
String[] direccionOsc = {
  "/csv/AF3", "/csv/F7", "/csv/FC5", "/csv/T7", "/csv/O1", "/csv/T8", "/csv/FC6", "/csv/F8"};
//String[] direccionOsc = {"/csv/AF3","/csv/F7","/csv/F3","/csv/FC5","/csv/T7","/csv/P7","/csv/O1","/csv/O2","/csv/P8","/csv/T8","/csv/FC6","/csv/F4","/csv/F8","/csv/AF4"};
//Envia al archivo OSCrecibe.pd

PFont myFont;

void setup() {
  size(400, 300);
  background(0);
  
  selectInput("Select a file to process:", "fileSelected");

  ip = "127.0.0.1"; //localhost
  puerto = 11113;
  oscP5 = new OscP5(this, puerto);
  direccionRemota = new NetAddress(ip, puerto);
  
  cp5 = new ControlP5(this);

  Button b1 = cp5.addButton("(1) Select a file to process:")
    .setValue(0)
      .setPosition(100, 100)
        .setSize(200, 19)
          .activateBy(ControlP5.PRESSED)
            ;

  Button b2 = cp5.addButton("Conect to port: 1113:")
    .setValue(0)
      .setPosition(100, 120)
        .setSize(100, 19)
          .activateBy(ControlP5.PRESSED)
            ;

Button b3 = cp5.addButton("Conect to port: 1114:")
    .setValue(0)
      .setPosition(100, 140)
        .setSize(100, 19)
          .activateBy(ControlP5.PRESSED)
            ;
Button b4 = cp5.addButton("Conect to port: 1115:")
    .setValue(0)
      .setPosition(100, 160)
        .setSize(100, 19)
          .activateBy(ControlP5.PRESSED)
            ;

  b1.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): 
        selectInput("Select a file to process:", "fileSelected");
        case(ControlP5.ACTION_RELEASED): println("User selected " + filename);
        break;
      }
    }
  }
  );


  lastFileRead = millis();
}




void draw() {

  if (mBr == null) return;

  // leer a cada 5ms
  if (millis()-lastFileRead > 5) {
    try {
      String line = mBr.readLine();
      if (line == null) {
        mBr.close();
        mBr = new BufferedReader(new FileReader(filename));
        mBr.readLine();
      }

      // valArray es un array de Strings con los valores
      String[] valArray = line.trim().split("\\s*,\\s*");
      // aqui se saca los valores de float de los Strings
      for (int i=0; i<valArray.length; i++) {
        float f = Float.valueOf(valArray[i]);
        //separar datos por columna para transmitir individualmente
        OscMessage mensaje = new OscMessage(direccionOsc[i]);
        mensaje.add(f); 
        oscP5.send(mensaje, direccionRemota);
      }
      println();
    }
    catch(Exception e) {
    }

    lastFileRead = millis();
  }
}


