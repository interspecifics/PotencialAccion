import java.io.FileReader;
import java.io.FileNotFoundException;
import oscP5.*; 
import netP5.*;
import controlP5.*;

ControlP5 cp5;

Textlabel titulo;
Textlabel logo;

ControlTimer c;
Textlabel t;

String portValue = "";


OscP5 oscP5; 
NetAddress direccionRemota;

BufferedReader mBr = null;
int lastFileRead;
String filename;

int puerto;
String ip;
String[] direccionOsc = {
  "/csv/AF3", "/csv/F7", "/csv/FC5", "/csv/T7", "/csv/O1", "/csv/T8", "/csv/FC6", "/csv/F8"
};
//String[] direccionOsc = {"/csv/AF3","/csv/F7","/csv/F3","/csv/FC5","/csv/T7","/csv/P7","/csv/O1","/csv/O2","/csv/P8","/csv/T8","/csv/FC6","/csv/F4","/csv/F8","/csv/AF4"};
//Envia al archivo OSCrecibe.pd


void setup() {
  size(400, 600);
  background(0);
  frameRate(30);

  ip = "127.0.0.1"; //localhost
  puerto = 11113;

  oscP5 = new OscP5(this, puerto);
  direccionRemota = new NetAddress(ip, puerto);

  cp5 = new ControlP5(this);

  logo = cp5.addTextlabel("label2")
    .setText("POTENCIAL DE ACCION")
      .setFont(createFont("Roboto-Light", 20))
        .setPosition(98, 57)
          .setColorValue(color( 255, 0, 0 ))
            ;


  titulo = cp5.addTextlabel("label")
    .setText("EEG TO OSC FROM CSV/TSV FILE")
      .setPosition(98, 80)
        .setColorValue(color( 255, 0, 0 ))
          ;

  Button b1 = cp5.addButton("Select a file to process:")
    .setValue(0)
      .setPosition(100, 100)
        .setSize(200, 19)
          .setColorBackground(color( 255, 0, 0 ))
            .setColorForeground(color(142, 17, 17))
              .setColorActive(color(142, 17, 17))
                .setColorLabel(color(0 ) )
                  .activateBy(ControlP5.PRESSED)
                    ;

  Button b2 = cp5.addButton("* Conect to port: 1113:")
    .setValue(0)
      .setPosition(100, 120)
        .setSize(100, 19)
          .setColorBackground(color( 255, 0, 0 ))
            .setColorForeground(color(142, 17, 17))
              .setColorActive(color(142, 17, 17))
                .setColorLabel(color(0 ) )
                  .activateBy(ControlP5.PRESSED)
                    ;

  Button b3 = cp5.addButton("* Conect to port: 1114:")
    .setValue(0)
      .setPosition(100, 140)
        .setSize(100, 19)
          .setColorBackground(color( 255, 0, 0 ))
            .setColorForeground(color(142, 17, 17))
              .setColorActive(color(142, 17, 17))
                .setColorLabel(color(0 ) )
                  .activateBy(ControlP5.PRESSED)
                    ;
  Button b4 = cp5.addButton("* Conect to port: 1115:")
    .setValue(0)
      .setPosition(100, 160)
        .setSize(100, 19)
          .setColorBackground(color( 255, 0, 0 ))
            .setColorForeground(color(142, 17, 17))
              .setColorActive(color(142, 17, 17))
                .setColorLabel(color(0 ) )
                  .activateBy(ControlP5.PRESSED)
                    ;

  cp5.addTextfield("portValue")
    .setPosition(100, 181)
      .setSize(100, 19)
        .setFont(createFont("arial", 9))
          .setColorBackground(color( 0 ))
            .setColorForeground(color(142, 17, 17))
              .setColorActive(color(142, 17, 17))
                .setAutoClear(false)
                  ;

  cp5.addBang("clear")
    .setPosition(200, 181)
      .setSize(100, 19)
        .setColorBackground(color( 255, 0, 0 ))
          .setColorForeground(color(142, 17, 17))
            .setColorActive(color(142, 17, 17))
              .setColorLabel(color(0 ) )
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;    
                  

  b1.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): 
        selectInput("Select a file to process:", "fileSelected");  
        println("User selected " + filename);
        break;
        case(ControlP5.ACTION_RELEASED):
        c = new ControlTimer();
        t = new Textlabel(cp5, "--", 100, 100);        
        c.setSpeedOfTime(1); 
        break;
      }
    }
  }
  );
  
  lastFileRead = millis();

}




void draw() {
  titulo.draw(this); 
  logo.draw(this); 


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
 t.setValue(c.toString());
 t.draw(this);
 t.setPosition(210,205);
    }
    catch(Exception e) {
    }

    lastFileRead = millis();
  }
   
}

public void clear() {
  cp5.get(Textfield.class, "portValue").clear();
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
      +theEvent.getName()+"': "
      +theEvent.getStringValue()
      );
  }
}

public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
}

