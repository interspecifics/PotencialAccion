import java.util.Hashtable;
import oscP5.*;
import netP5.*;

final static int OSC_IN_PORT = 8444;
final static String SENSOR_LIST = "AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4";

OscP5 mOscP5;

Hashtable<String, Sensor> mSensors = new Hashtable<String, Sensor>();
long lastOscMillis;

void setup() {
  size(600, 700, P2D);
  String sNames[] = SENSOR_LIST.split(" ");
  for (int i=0; i<sNames.length; ++i) {
    mSensors.put(sNames[i], new Sensor(new PVector(20, 10+i*110), new PVector(560, 100), sNames[i]));
  }
  lastOscMillis = millis();
  mOscP5 = new OscP5(this, OSC_IN_PORT);
}

// read input (TODO: OSC !!!)
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().startsWith("/emokit/")) {
    String addPat[] = theOscMessage.addrPattern().split("/");
    println(addPat);
  }
}

void draw() {
  background(200);

  // write osc
  if (millis()-lastOscMillis > 100) {
    for (String k : mSensors.keySet()) {
      mSensors.get(k).sendOsc();
    }
  }

  // draw
  for (String k : mSensors.keySet()) {
    mSensors.get(k).draw();
  }
}

