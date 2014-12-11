import java.util.HashMap;
import oscP5.*;
import netP5.*;

final static int OSC_IN_PORT = 8444;
final static String SENSOR_LIST = "AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4";
String sNames[];

OscP5 mOscP5;
PrintWriter csvFile;
boolean bRecordSensors;

HashMap<String, Sensor> mSensors = new HashMap<String, Sensor>();
long lastOscMillis;

void setup() {
  size(700, 720, P2D);
  sNames = SENSOR_LIST.split(" ");
  for (int i=0; i<sNames.length; ++i) {
    mSensors.put(sNames[i], new Sensor(new PVector(20, i*height/14), new PVector((width-100)-20, height/14-5), sNames[i]));
  }
  lastOscMillis = millis();
  bRecordSensors = false;
  mOscP5 = new OscP5(this, OSC_IN_PORT);
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
}

void draw() {
  background(200);

  // write csv
  if (bRecordSensors) {
    csvFile.print(millis());
    for (String s:sNames) {
      csvFile.print(","+mSensors.get(s).getRawValue());
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

  fill(0);
  text(frameRate, width-50, 20);
}

void keyPressed() {
  if (key == ' ') {
    bRecordSensors = !bRecordSensors;

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
}

void dispose() {
  if (bRecordSensors) {
    csvFile.flush();
    csvFile.close();
  }
}

