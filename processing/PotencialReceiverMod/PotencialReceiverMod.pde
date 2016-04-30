import java.util.HashMap;
import controlP5.*;
import oscP5.*;
import netP5.*;

final static int OSC_IN_PORT = 8444;
final static String SENSOR_LIST = "AF3 F7 F3 F4 F8 AF4";
String sNames[];

OscP5 mOscP5;
ControlP5 mCp5;
ControlP5 cp5;

PrintWriter csvFile;
boolean bRecordSensors;

Textlabel titulo;
Textlabel logo;
Textlabel instructions;


HashMap<String, Sensor> mSensors = new HashMap<String, Sensor>();
long lastOscMillis;

void setup() {
  size(900, 720, P2D);
  mCp5 = new ControlP5(this);

  sNames = SENSOR_LIST.split(" ");
  for (int i=0; i<sNames.length; ++i) {
    mSensors.put(sNames[i], new Sensor(new PVector(20, i*height/5), new PVector((width-150)-20, height/7-5), sNames[i]));
  }
  lastOscMillis = millis();
  bRecordSensors = false;
  mOscP5 = new OscP5(this, OSC_IN_PORT);
  
  ///// Logo and title
  logo = mCp5.addTextlabel("label2")
    .setText("POTENCIAL DE ACCION")
      .setFont(createFont("Roboto-Light", 20))
        .setPosition(560, 57)
          .setColorValue(color( 255, 255, 255 ))
            ;
  titulo = mCp5.addTextlabel("label")
    .setText("EEG TO OSC FROM EMOKIT")
     .setFont(createFont("Roboto-Light", 14))
      .setPosition(560, 80)
        .setColorValue(color( 255, 0, 0 ))
          ;
          
   instructions = mCp5.addTextlabel("label3")
    .setText("1- Check emoOscServer.py for serial number, and id product")
      .setPosition(560, 250)
        .setColorValue(color( 255, 255, 255 ))
          ;   
     instructions = mCp5.addTextlabel("label4")
    .setText("2- In terminal: find PotencialAccion/python/emoOscServer")
      .setPosition(560, 260)
        .setColorValue(color(255, 255, 255 ))
          ;
          
    instructions = mCp5.addTextlabel("label5")
    .setText("3- In terminal run: python emoOscServer.py")
      .setPosition(560, 270)
        .setColorValue(color( 255, 255, 255 ))
          ;

  mCp5.addToggle("writeCSV")
    .setPosition(565, 110).setSize(80, 20)
      .setColorBackground(color( 255, 0, 0 )).setColorForeground(color(142, 17, 17)).setColorActive(color(142, 17, 17))
        .setCaptionLabel("REC-CSV")
          .setValue(bRecordSensors)
            .getCaptionLabel().align(CENTER,CENTER)
              .setSize(10).setColor(0xff000000);
              
              
}

// read input
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().startsWith("/emokit/")) {
    String addPat[] = theOscMessage.addrPattern().split("/");
    String sensorName = addPat[2];
    short sensorVal = (short)theOscMessage.get(0).intValue();
    int sensorQual = theOscMessage.get(1).intValue();
    mSensors.get(sensorName).addValue(sensorVal);
    mSensors.get(sensorName).setQuality(sensorQual);
    
  }
  else if(theOscMessage.addrPattern().startsWith("/brainWaves/")){
    String addPat[] = theOscMessage.addrPattern().split("/");
    String sensorName = addPat[2];
    
 mSensors.get(sensorName).setFrequency((short)theOscMessage.get(0).floatValue(),(short)theOscMessage.get(1).floatValue(),(short)theOscMessage.get(2).floatValue(),(short)theOscMessage.get(3).floatValue());
    
  //println( (short)theOscMessage.get(0).floatValue());
    
  }
}

void draw() {
  background(0);

  // write csv
  if (bRecordSensors) {
    csvFile.print(millis());
    for (String s:sNames) {
      if (mSensors.get(s).isRecording()) {
        csvFile.print(","+mSensors.get(s).getRawValue());
      }
      else {
        csvFile.print(","+"");
      }
    }
    csvFile.print("\n");
  }

  // write osc
  if (millis()-lastOscMillis > 100) {
    for (String k : mSensors.keySet()) {
      mSensors.get(k).sendOsc();
    }
    lastOscMillis = millis();
  }

  // draw
  for (String k : mSensors.keySet()) {
    mSensors.get(k).draw();
  }

  fill(255);
  rect(650, 110, 70, 19);
  fill(0);
  text(frameRate, 660, 125);
}

public void controlEvent(ControlEvent theEvent) {
  try {
    if (theEvent.getController().getName().equals("writeCSV")) {
      bRecordSensors = (theEvent.getController().getValue()>0.0);
      manageSensorWriter();
    }
    else {
      mSensors.get(theEvent.getController().getName()).setRecording(theEvent.getController().getValue()>0.0);
    }
  }
  // this catches some exceptions thrown during initialization,
  // due to Sensor objects not being in the HashMap when Toggle object is created
  catch(Exception e) {
  }
}

void manageSensorWriter() {
  if (!bRecordSensors) {
    csvFile.flush();
    csvFile.close();
  }
  else {
    String fname = year()+"";
    fname += (month()<10)?"0"+month():month();
    fname += (day()<10)?"0"+day():day();
    fname += "_";
    fname += (hour()<10)?"0"+hour():hour();
    fname += (minute()<10)?"0"+minute():minute();
    fname += (second()<10)?"0"+second():second();
    csvFile = createWriter(fname+".csv");
    csvFile.print("TIME");
    for (String s:sNames) {
      csvFile.print(","+s);
    }
    csvFile.print("\n");
  }
}

void dispose() {
  if (bRecordSensors) {
    csvFile.flush();
    csvFile.close();
  }
}

