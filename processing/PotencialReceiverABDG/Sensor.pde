import oscP5.*;
import netP5.*;

private static NetAddress oscOutAddress;
private static OscMessage mMessage;
private final static int QUALITY_COLORS[] = {
  #000000, #B22222, #EE8833, #FFCC11, #698B22};
private final static int FREQ_COLORS[] = {
  #9C3EDB, #8A57DE, #FC9800, #2C88F5, #2567AF, #0079FF, #FC0000, #000000};

public class Sensor {
  private static final short AVGSIZE = 4;
  private static final short DISPLAYSIZE = 300;
  private static final short RAWSIZE = 30000;

  private final static int OSC_OUT_PERIOD = 100;
  private final static int OSC_OUT_PORT = 8666;
  private final static String OSC_OUT_HOST = "localhost";
  private final static String OSC_OUT_PATTERN = "/potencial/";

  private final static short GUI_OFFSET = 5;
  private final static short QUALITY_WIDTH = 30;

  private short rawValues[] = new short[RAWSIZE+1];
  private short averageValues[] = new short[DISPLAYSIZE*2+1];
  private short currentRunningAverage[] = new short[AVGSIZE];
  private int averageSum;
  private short averageIndex;

  // begin/end indices for different things
  private short averageEnd, rawEnd;
  private float currentQuality;
  private float currentFreq;
  private boolean bRecordSensor;
  private String name;
  private PVector location, dimension;
  
  private short delta, theta, alpha, SMRbeta, Midbeta, Highbeta, gamma;

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

    averageSum = 0;
    averageIndex = 0;
    currentQuality = 0.0f;
    currentFreq = 0;
    bRecordSensor = true;
   
   //Basic Freqeuncy analysis of 7 different ranges 
    delta = 0;
    theta = 0;
    alpha = 0;
    SMRbeta = 0; 
    Midbeta = 0;
    Highbeta = 0;
    gamma = 0;


    // GUI for recording channels
    mCp5.addToggle(name)
      .setPosition(location.x+430, location.y)
        .setSize(QUALITY_WIDTH, (int)dimension.y)
          .setColorBackground(0xff646464).setColorForeground(0xffAAAAAA).setColorActive(0xffAAAAAA)
            .setCaptionLabel("REC")
              .setValue(true)
                .getCaptionLabel().align(CENTER, CENTER)
                  .setSize(10).setColor(0);
  }

  public String getName() {
    return name;
  }

  public void setQuality(float q) {
    currentQuality = (0.9f*currentQuality + 0.1f*q);
  }
  
  public void setFrequency(float q) {
    currentFreq = (0*currentFreq + 0.1f*q);
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
 
  public void setFrequency (short d, short t, short a, short sb, short mb, short hb, short g) {
    delta = d;
    theta = t;
    alpha = a;
    SMRbeta = sb;
    Midbeta = mb;
    Highbeta = hb;
    gamma = g;   
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
  }


  public void sendOsc() {
    String mAddrPatt = OSC_OUT_PATTERN+getName()+"/";

    // raw
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"crudo");
    mMessage.add(getRawValue());
    OscP5.flush(mMessage, oscOutAddress);

    // delta
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"d");
    mMessage.add(delta);
    OscP5.flush(mMessage, oscOutAddress);
    
    // THETA
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"t");
    mMessage.add(theta);
    OscP5.flush(mMessage, oscOutAddress);
    
    //ALPHA
     mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"a");
    mMessage.add(alpha);
    OscP5.flush(mMessage, oscOutAddress);
    
    //SMRBETA
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"sb");
    mMessage.add(SMRbeta);
    OscP5.flush(mMessage, oscOutAddress);
    
    //MIDBETA
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"mb");
    mMessage.add(Midbeta);
    OscP5.flush(mMessage, oscOutAddress);
    
    //HIGHBETA
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"hb");
    mMessage.add(Highbeta);
    OscP5.flush(mMessage, oscOutAddress);
    
    //GAMMA
    mMessage.clear();
    mMessage.setAddrPattern(mAddrPatt+"g");
    mMessage.add(gamma);
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
    noStroke();
    fill(color(QUALITY_COLORS[qci]));
    rect(QUALITY_WIDTH/2, dimension.y/2, QUALITY_WIDTH/3, dimension.y/2);

    // background rectangle
    pushMatrix();
    translate(QUALITY_WIDTH+GUI_OFFSET, 0);
    fill(100);
    rect(0, 0, dimension.x/2, dimension.y);

    // sensor title, alpha, beta, gamma, delta
    fill(255);
    textSize(9);
    textLeading(10);
    String ss = name+"\n"+getRawValue()+"\n"+SMRbeta+"\n"+gamma;
    text(ss, 9, 9);

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
    fill(62,62,62);
    noStroke();
    rect(0, 0, gwidth/2, gheight);

    // graph
    int qfi = 0;
    PVector lastP = new PVector(0, gheight/2);
    if ((delta <= 0.5) || (delta >= 3)) qfi = 0;
    else if ((theta <= 4) || (theta >= 7)) qfi = 1;
    else if ((alpha <= 8) || (alpha >= 12)) qfi = 2;
    else if ((SMRbeta <= 12.5) || (SMRbeta >= 15)) qfi = 3;
    else if ((Midbeta <= 16) || (Midbeta >= 18)) qfi = 4;
    else if ((Highbeta <= 28) || (Highbeta >= 30)) qfi = 5;
    else if ((gamma <= 35) || (gamma >= 60)) qfi = 6;
    else qfi = 7;
    stroke(color(FREQ_COLORS[qfi]));
    for (int x=1, i=(int)(lastIndex-gwidth); x<gwidth/2; ++x, ++i) {
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

