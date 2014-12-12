import oscP5.*;
import netP5.*;

private static NetAddress oscOutAddress;
private static OscMessage mMessage;
private final static int QUALITY_COLORS[] = {
  #000000, #B22222, #EE8833, #FFCC11, #698B22
};

public class Sensor {
  private static final short AVGSIZE = 4;
  private static final short DISPLAYSIZE = 300;
  private static final short RAWSIZE = 30000;

  private final static int OSC_OUT_PERIOD = 100;
  private final static int OSC_OUT_PORT = 8666;
  private final static String OSC_OUT_HOST = "localhost";
  private final static String OSC_OUT_PATTERN = "/potencial-accion/";

  private final static short GUI_OFFSET = 5;
  private final static short QUALITY_WIDTH = 30;

  private short rawValues[] = new short[RAWSIZE+1];
  private short averageValues[] = new short[DISPLAYSIZE*2+1];
  private short currentRunningAverage[] = new short[AVGSIZE];
  private int averageSum;
  private short averageIndex;

  // begin/end indices for different things
  private short averageEnd, rawEnd;
  private short maxValue, minValue;
  private float currentQuality;
  private boolean bRecordSensor;
  private String name;
  private PVector location, dimension;

  public Sensor(PVector _location, PVector _dimension, String _name) {
    oscOutAddress = new NetAddress(OSC_OUT_HOST, OSC_OUT_PORT);
    mMessage = new OscMessage(OSC_OUT_PATTERN);

    // set location/dimension of graphs and name of sensor
    location = _location;
    dimension = _dimension;
    name = _name;

    // initial end indices
    //   "end" points to one after the last value in range
    rawEnd = (short)((rawValues.length)-1);
    averageEnd = (short)((averageValues.length)-1);

    // init values
    for (int i=0; i<(rawValues.length); ++i) {
      rawValues[i] = 0;
    }
    for (int i=0; i<(averageValues.length); ++i) {
      averageValues[i] = 0;
    }
    for (int i=0; i<(currentRunningAverage.length); ++i) {
      currentRunningAverage[i] = 0;
    }

    minValue = 0;
    maxValue = 0;
    averageSum = 0;
    averageIndex = 0;

    currentQuality = 0.0f;
    bRecordSensor = false;

    // GUI
    mCp5.addToggle(name)
      .setPosition(location.x+dimension.x+2*GUI_OFFSET+QUALITY_WIDTH, location.y)
        .setSize(QUALITY_WIDTH, (int)dimension.y/2)
          .setColorBackground(0xff646464).setColorForeground(0xff8c0000).setColorActive(0xffcc1100)
            .setCaptionLabel("REC").setColorCaptionLabel(0xff000000)
              .setValue(true)
                .getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE)
                  .setSize(10).setColor(0xffcc1100);
  }

  public short getMin() {
    return minValue;
  }
  public short getMax() {
    return maxValue;
  }
  public String getName() {
    return name;
  }

  public void setQuality(float q) {
    currentQuality = (0.9f*currentQuality + 0.1f*q);
  }

  public boolean isRecording() {
    return bRecordSensor;
  }
  public void setRecording(boolean b) {
    bRecordSensor = b;
  }

  public short getRawValue() {
    // last written value is at end-1
    // make sure index is positive
    int getFromIndex = (rawEnd > 0)?(rawEnd-1):((rawValues.length)-1);
    return rawValues[getFromIndex];
  }

  public short getAverageValue() {
    // last written value is at end-1
    // make sure index is positive
    int getFromIndex = (averageEnd > 0)?(averageEnd-1):((averageValues.length)-1);
    return averageValues[getFromIndex];
  }
  public short getAverageValueNormalized() {
    return (short)constrain((short)map(getAverageValue(), getMin(), getMax(), 0, 1023), 0, 1023);
  }


  public void addValue(short val) {
    // write value to raw array and update end index
    rawValues[rawEnd] = val;
    rawEnd = (short)((rawEnd+1)%(rawValues.length));

    // update running average
    averageSum -= currentRunningAverage[averageIndex];
    currentRunningAverage[averageIndex] = val;
    averageSum += currentRunningAverage[averageIndex];
    averageIndex = (short)((averageIndex+1)%(currentRunningAverage.length));

    // write to average values
    averageValues[averageEnd] = (short)(averageSum/(currentRunningAverage.length));
    averageEnd = (short)((averageEnd+1)%(averageValues.length));

    // find min/max of current averages
    short thisMinValue = 9000;
    short thisMaxValue = -9000;
    for (int i=0; i<(averageValues.length); ++i) {
      if (averageValues[i] > thisMaxValue) {
        thisMaxValue = averageValues[i];
      }
      if (averageValues[i] < thisMinValue) {
        thisMinValue = averageValues[i];
      }
    }

    // if there's a new min/max, update immediately
    //    else, slowly approach current min/max
    if (thisMaxValue > maxValue) {
      maxValue = thisMaxValue;
    }
    else {
      maxValue = (short)(0.99*maxValue + 0.01*thisMaxValue);
    }

    if (thisMinValue < minValue) {
      minValue = thisMinValue;
    }
    else {
      minValue = (short)(0.99*minValue + 0.01*thisMinValue);
      minValue = (thisMinValue<minValue)?thisMinValue:minValue;
    }
  }

  public void sendOsc() {
    String mAddrPatt = OSC_OUT_PATTERN+getName()+"/";

    // min
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"min");
    mMessage.add(getMin());
    OscP5.flush(mMessage, oscOutAddress);

    // max
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"max");
    mMessage.add(getMax());
    OscP5.flush(mMessage, oscOutAddress);

    // filtered
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"filtrado");
    mMessage.add(getAverageValueNormalized());
    OscP5.flush(mMessage, oscOutAddress);

    // raw
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"crudo");
    mMessage.add(getRawValue());
    OscP5.flush(mMessage, oscOutAddress);
  }

  public void draw() {
    pushMatrix();
    translate(location.x, location.y);

    // sensor quality indicator
    int qci = 0;
    if (currentQuality < 2) qci = 0;
    else if (currentQuality < 5) qci = 1;
    else if (currentQuality < 8) qci = 2;
    else if (currentQuality < 11) qci = 3;
    else qci = 4;
    stroke(0);
    fill(color(QUALITY_COLORS[qci]));
    ellipse(QUALITY_WIDTH/2, dimension.y/2, QUALITY_WIDTH/2, dimension.y/2);

    // background rectangle
    pushMatrix();
    translate(QUALITY_WIDTH+GUI_OFFSET, 0);
    fill(100);
    rect(0, 0, dimension.x, dimension.y);

    // sensor title, current, min and max
    fill(255);
    textSize(11);
    textLeading(11);
    String ss = name+"\n"+getRawValue()+"\n"+minValue+"\n"+maxValue;
    text(ss, 10, 11);

    // raw graph
    pushMatrix();
    translate(dimension.x/10f, 0);
    drawGraph(rawValues, (short)(rawValues.length), rawEnd, dimension.x*9f/10f, dimension.y);
    popMatrix();

    popMatrix(); // background rectangle
    popMatrix(); // location
  }

  void drawGraph(short values[], short sizeOfValues, short lastIndex, float gwidth, float gheight) {
    // background rectangle
    fill(90);
    noStroke();
    rect(0, 0, gwidth, gheight);

    // graph
    PVector lastP = new PVector(0, gheight/2);
    stroke(255);
    for (int x=1, i=(int)(lastIndex-gwidth); x<gwidth; ++x, ++i) {
      int yIndex = i;
      while (yIndex<0) {
        yIndex += sizeOfValues;
      }
      yIndex = yIndex%sizeOfValues;

      short y0 = (short)map(values[yIndex], 8192, -8192, 0, gheight);
      line(lastP.x, lastP.y, x, y0);
      lastP.set(x, y0);
    }
  }
}

