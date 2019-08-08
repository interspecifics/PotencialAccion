import controlP5.*;        //se crea un comando para importar las librerias necesarias
import processing.net.*;
import oscP5.*;
import netP5.*;

String s="";

OscP5 oscP5;
/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation; 
ControlP5 controlP5;
ControlFont font;

Client myClient; 
Channel[] channels = new Channel[11];
Monitor[] monitors = new Monitor[10];
Graph graph;
ConnectionLight connectionLight;
int packetCount = 0;
int globalMax;
String scaleMode;

void setup() {
  size(1024, 768);
  smooth();
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,12000);
  /* create a new NetAddress. a NetAddress is used when sending osc messages
   * with the oscP5.send method.
   */
  /* the address of the osc broadcast server */
  myBroadcastLocation = new NetAddress("127.0.0.1",32000);

  // Set up the knobs and dials
  controlP5 = new ControlP5(this);
  controlP5.setColorLabel(color(0));
  // controlP5.setColorValue(color(0));	
  controlP5.setColorBackground(color(0));
  //controlP5.setColorForeground(color(130));
  // controlP5.setColorActive(color(0));	

  font = new ControlFont(createFont("DIN-MediumAlternate", 12), 12);


  // Connect to ThinkGear socket (default = 127.0.0.1:13854)
  // By default, Thinkgear only binds to localhost:
  // To allow other hosts to connect and run Processing from another machine, run ReplayTCP (http://www.dlcsistemas.com/html/relay_tcp.html)
  // OR, use netcat (windows or mac) to port forard (clients can now connect to port 13855).  Ex:  nc -l -p 13855 -c ' nc localhost 13854'

  String thinkgearHost = "127.0.0.1";
  int thinkgearPort = 13854;

  String envHost = System.getenv("THINKGEAR_HOST");
  if (envHost != null) {
    thinkgearHost = envHost;
  }
  String envPort = System.getenv("THINKGEAR_PORT");
  if (envPort != null) {
    thinkgearPort = Integer.parseInt(envPort);
  }

  println("Connecting to host = " + thinkgearHost + ", port = " + thinkgearPort);
  myClient = new Client(this, thinkgearHost, thinkgearPort);
  String command = "{\"enableRawOutput\": false, \"format\": \"Json\"}\n";
  print("Sending command");
  println (command);
  myClient.write(command);



  // Creat the channel objects
  // yellow to purple and then the space in between, grays for the alphas
  channels[0] = new Channel("Signal Quality", color(0), "");
  channels[1] = new Channel("Attention", color(100), "");
  channels[2] = new Channel("Meditation", color(50), "");
  channels[3] = new Channel("Delta", color(219, 211, 42), "Dreamless Sleep");
  channels[4] = new Channel("Theta", color(245, 80, 71), "Drowsy");
  channels[5] = new Channel("Low Alpha", color(237, 0, 119), "Relaxed");
  channels[6] = new Channel("High Alpha", color(212, 0, 149), "Relaxed");
  channels[7] = new Channel("Low Beta", color(158, 18, 188), "Alert");
  channels[8] = new Channel("High Beta", color(116, 23, 190), "Alert");
  channels[9] = new Channel("Low Gamma", color(39, 25, 159), "???");
  channels[10] = new Channel("High Gamma", color(23, 26, 153), "???");

  // Manual override for a couple of limits.
  channels[0].minValue = 0;
  channels[0].maxValue = 200;
  channels[1].minValue = 0;
  channels[1].maxValue = 100;
  channels[2].minValue = 0;
  channels[2].maxValue = 100;
  channels[0].allowGlobal = false;
  channels[1].allowGlobal = false;
  channels[2].allowGlobal = false;

  // Set up the monitors, skip the signal quality

  for (int i = 0; i < monitors.length; i++) {
    monitors[i] = new Monitor(channels[i + 1], i * (width / 10), height / 2, width / 10, height / 2, this);
  }

  monitors[monitors.length - 1].w += width % monitors.length;



  // Set up the graph
  graph = new Graph(0, 0, width, height / 2);

  connectionLight = new ConnectionLight(width - 98, 10, 20, this);

  globalMax = 0;
}

void draw() {

  // find the global max
  if(scaleMode == "Global") {
    if(channels.length > 3) {
      for(int i = 3; i < channels.length; i++) {
        if (channels[i].maxValue > globalMax) globalMax = channels[i].maxValue;
      }
    }
  }	

  background(255);

  graph.update();
  graph.draw();

  connectionLight.update();
  connectionLight.draw();

  for (int i = 0; i < monitors.length; i++) {
    monitors[i].update();
    monitors[i].draw();
  }
}

void clientEvent(Client  myClient) {
  OscMessage myOscMessage = new OscMessage("/continuo");
  //        myOscMessage.add(0);
  //        oscP5.send(myOscMessage, myBroadcastLocation);

  // Sample JSON data:
  // {"eSense":{"attention":91,"meditation":41},"eegPower":{"delta":1105014,"theta":211310,"lowAlpha":7730,"highAlpha":68568,"lowBeta":12949,"highBeta":47455,"lowGamma":55770,"highGamma":28247},"poorSignalLevel":0}

  if (myClient.available() > 0) {

    String data = myClient.readString();
    try {
      org.json.JSONObject json = new org.json.JSONObject(data);

      channels[0].addDataPoint(Integer.parseInt(json.getString("poorSignalLevel")));

      org.json.JSONObject esense = json.getJSONObject("eSense");
      //AQUI!!
      if (esense != null) {
        int valorAtencion = Integer.parseInt(esense.getString("attention"));
        int valorMed = Integer.parseInt(esense.getString("meditation"));
        channels[1].addDataPoint(valorAtencion);
        channels[2].addDataPoint(valorMed);  
        // ESTA ES LA PARTE DEL CODIGO QUE MANDA
        //        OscMessage myOscMessage = new OscMessage("/attention");
        myOscMessage = new OscMessage("/attention");
        myOscMessage.add(valorAtencion);
        oscP5.send(myOscMessage, myBroadcastLocation);
        // TERMINA

        // ESTA ES LA PARTE DEL CODIGO QUE MANDA
        myOscMessage = new OscMessage("/meditation");
        myOscMessage.add(valorMed);
        oscP5.send(myOscMessage, myBroadcastLocation);
        // TERMINA


        println("Atencion"+ Integer.parseInt(esense.getString("attention")));
        println("Meditacion"+ Integer.parseInt(esense.getString("meditation")));
        println("Meditacion"+ Integer.parseInt(esense.getString("meditation")));
      }

      org.json.JSONObject eegPower = json.getJSONObject("eegPower");
      if (eegPower != null) {
        channels[3].addDataPoint(Integer.parseInt(eegPower.getString("delta")));
        myOscMessage = new OscMessage("/delta");
        myOscMessage.add(Integer.parseInt(eegPower.getString("delta")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[4].addDataPoint(Integer.parseInt(eegPower.getString("theta"))); 
        myOscMessage = new OscMessage("/theta");
        myOscMessage.add(Integer.parseInt(eegPower.getString("theta")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[5].addDataPoint(Integer.parseInt(eegPower.getString("lowAlpha")));
        myOscMessage = new OscMessage("/lowAlpha");
        myOscMessage.add(Integer.parseInt(eegPower.getString("lowAlpha")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[6].addDataPoint(Integer.parseInt(eegPower.getString("highAlpha")));  
        myOscMessage = new OscMessage("/highAlpha");
        myOscMessage.add(Integer.parseInt(eegPower.getString("highAlpha")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[7].addDataPoint(Integer.parseInt(eegPower.getString("lowBeta")));
        myOscMessage = new OscMessage("/lowBeta");
        myOscMessage.add(Integer.parseInt(eegPower.getString("lowBeta")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[8].addDataPoint(Integer.parseInt(eegPower.getString("highBeta")));
        myOscMessage = new OscMessage("/highBeta");
        myOscMessage.add(Integer.parseInt(eegPower.getString("highBeta")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[9].addDataPoint(Integer.parseInt(eegPower.getString("lowGamma")));
        myOscMessage = new OscMessage("/lowGamma");
        myOscMessage.add(Integer.parseInt(eegPower.getString("lowGamma")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        channels[10].addDataPoint(Integer.parseInt(eegPower.getString("highGamma")));
        myOscMessage = new OscMessage("/highGamma");
        myOscMessage.add(Integer.parseInt(eegPower.getString("highGamma")));
        oscP5.send(myOscMessage, myBroadcastLocation);

        println("delta "+ Integer.parseInt(eegPower.getString("delta")));
        println("theta "+ Integer.parseInt(eegPower.getString("theta")));
        println("lowAlpha "+ Integer.parseInt(eegPower.getString("lowAlpha")));
        println("highAlpha "+ Integer.parseInt(eegPower.getString("highAlpha")));
        println("lowBeta "+ Integer.parseInt(eegPower.getString("lowBeta")));
        println("highBeta "+ Integer.parseInt(eegPower.getString("highBeta")));
        println("lowGamma "+ Integer.parseInt(eegPower.getString("lowGamma")));
        println("highGamma "+ Integer.parseInt(eegPower.getString("highGamma")));
      }



      packetCount++;
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject." + e);
    };
  }
}


// Extend core's Map function to the Long datatype.
long mapLong(long x, long in_min, long in_max, long out_min, long out_max) { 
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

long constrainLong(long value, long min_value, long max_value) {
  if(value > max_value) return max_value;
  if(value < min_value) return min_value;
  return value;
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
}

{
  // Se actualiza constantemente CSV
// Aqui en lugar de randoms pon los datos que quieras, y si quieres poner más sólo separalos por comas
  //s+=""+High Beta(100)+","+Low Beta(100)+","+High Alpha(100)+","+Low Alpha(100)+"-";
  // La rallita- sirve para indicar que hay un nuevo renglón
}

void mousePressed(){
  // Cuando presionas el mouse se graban los datos que van hasta ese momento
 println("Grabar archivo"); 
 // aquí el split le dice que separe los renglones cada que aparece un -
 saveStrings("datos.csv", split(s,'-'));
}
