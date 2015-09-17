#pragma once

#include "ofMain.h"
#include "ofxOsc.h"

// listen on port 57110
#define PORT 57120
#define NUM_MSG_STRINGS 20

#ifndef _OF_EMOTIVE
#define _OF_EMOTIVE


class ofEmotive {
public:
    
    void setup();
    void update();
    void draw();
    void drawScene();
    
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    ofTrueTypeFont font;
    ofxOscReceiver receiver;
    
    int current_msg_string;
    string msg_strings[NUM_MSG_STRINGS];
    float timers[NUM_MSG_STRINGS];
    
    float AF3;
    float F7;
    float F3;
    float F4;
    float F8;
    float AF4;
    
private:
    
    
};
#endif
