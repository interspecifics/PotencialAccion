#pragma once

#include "ofMain.h"
#include "ofxOculusDK2.h"
#include "ofxVboParticles.h"
#include "ofxOsc.h"

typedef struct{
    ofColor color;
    ofVec3f pos;
    ofVec3f floatPos;
    float radius;
    bool bMouseOver;
    bool bGazeOver;
} DemoSphere;

class ofApp : public ofBaseApp
{
public:
    
    void setup();
    void update();
    void draw();
    
    void drawScene();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y);
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    ofxOculusDK2		oculusRift;
    
    ofLight				light;
    ofEasyCam			cam;
    
    bool showOverlay;
    bool predictive;
    
    bool render_oculus;
    
    bool show_particle;
    bool color_on;
    bool show_port;
    
    ofVec3f cursor2D;
    ofVec3f cursor3D;
    
    ofVec3f cursorRift;
    ofVec3f demoRift;
    
    ofVec3f cursorGaze;
    
    //sensor
    float readingMin;
    float readingMax;
    vector<string> sensorList;
    vector<float> sensorReading;
    ofColor colorStart;
    ofColor colorEnd;
    
    //particle
    ofxVboParticles *vboParticles;
    vector<ofxVboParticles*> particleTiles;
    void spawn_particles(float reading, ofColor color, ofxVboParticles *particleTile);

    float tileWidth, tileHeight;
    float arcAngle;
    float distanceTiles;
    
    float particleSpread;
    float particleSpeed;
    
    //osc
    ofxOscReceiver receiver;    
    void get_osc_messages();
    int osc_port;
};
