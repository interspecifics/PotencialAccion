import java.io.FileReader;
import java.io.FileNotFoundException;
import oscP5.*; 
import netP5.*;

OscP5 oscP5; 
NetAddress direccionRemota;

BufferedReader mBr;
int lastFileRead;

int puerto;
String ip;

 
void setup() {
  size(500, 300);
  background(200);
 
  ip = "127.0.0.1"; //localhost
  puerto = 11112;
  oscP5 = new OscP5(this, puerto);
  direccionRemota = new NetAddress(ip, puerto);
  
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
        
       //separar datos por columna para transmitir individualmente

        // lista de mesajes por electrodos
  OscMessage mensaje1 = new OscMessage("/csv/AF3"); 
  OscMessage mensaje2 = new OscMessage("/csv/F7"); 
  OscMessage mensaje3 = new OscMessage("/csv/F3"); 
  OscMessage mensaje4 = new OscMessage("/csv/FC5"); 
  OscMessage mensaje5 = new OscMessage("/csv/T7"); 
  OscMessage mensaje6 = new OscMessage("/csv/P7"); 
  OscMessage mensaje7 = new OscMessage("/csv/O1"); 
  OscMessage mensaje8 = new OscMessage("/csv/O2"); 
  OscMessage mensaje9 = new OscMessage("/csv/P8"); 
  OscMessage mensaje10 = new OscMessage("/csv/T8"); 
  OscMessage mensaje11 = new OscMessage("/csv/FC6"); 
  OscMessage mensaje12 = new OscMessage("/csv/F4"); 
  OscMessage mensaje13 = new OscMessage("/csv/F8"); 
  OscMessage mensaje14 = new OscMessage("/csv/AF4"); 
  

  mensaje1.add(valArray); 
    //mensaje2.add(valArray); 
     // mensaje3.add(valArray); 


  

  oscP5.send(mensaje1, direccionRemota); 
  oscP5.send(mensaje2, direccionRemota);
        
      }
      println();
    }
    catch(Exception e) {}
 
    lastFileRead = millis();
  }
}
