import java.io.FileReader;
import java.io.FileNotFoundException;
import oscP5.*; 
import netP5.*;

OscP5 oscP5; 
NetAddress direccionRemota;

BufferedReader mBr;
int lastFileRead;
 
void setup() {
  size(500, 300);
  background(200);
  try {
    mBr = new BufferedReader(new FileReader(dataPath("Eliazabeth-04-18.11.2014.14.23.45.csv")));
    mBr.readLine();
  }
  catch(Exception e) {}
 
  lastFileRead = millis();
}
 
void draw() {
  // leer a cada 5ms
  if (millis()-lastFileRead > 5) {
    try {
      String line = mBr.readLine();
      if (line == null) {
        mBr.close();
        mBr = new BufferedReader(new FileReader(dataPath("Eliazabeth-04-18.11.2014.14.23.45.csv")));
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
}
