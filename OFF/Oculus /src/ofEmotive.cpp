#include "ofEmotive.h"
bool show_port = true;



void ofEmotive::setup(){
    
    //osc
    cout << "listening for osc messages on port " << PORT << "\n";
    receiver.setup(PORT);
    current_msg_string = 0;
    current_msg_string = 0;
    AF3 = 0;
    AF4 = 0;
    F3 = 0;
    F4 = 0;
    F7 = 0;
    F8 = 0;
    
}

void ofEmotive::update(){
    
    //osc
    // hide old messages
    for (int i= 0; i < NUM_MSG_STRINGS; i++) {
        if (timers[i] < ofGetElapsedTimef()) {
            msg_strings[i] = "";
        }
    }
    
    //check for waiting messages
    while (receiver.hasWaitingMessages()){
        // get the next message
        ofxOscMessage m;
        receiver.getNextMessage(&m);
        
        // check sensor AF3
        if (m.getAddress() == "/AF3") {
            AF3 = m.getArgAsFloat(1);
        }
        // check sensor AF4
        else if (m.getAddress() == "/AF4"){
            AF4 = m.getArgAsFloat(0);
        }
        // check sensor F7
        else if (m.getAddress() == "/F7") {
            F7 = m.getArgAsFloat(0);
        }
        // check sensor F4
        else if (m.getAddress() == "/F4"){
            F4 = m.getArgAsFloat(0);
        }
        // check sensor F8
        else if (m.getAddress() == "/F8") {
            F8 = m.getArgAsFloat(0);
        }
        
        else{
            // unrecognized message: display on the bottom of the screen
            string msg_string;
            msg_string = m.getAddress();
            msg_string += ": ";
            for(int i = 0; i < m.getNumArgs(); i++){
                // get the argument type
                msg_string += m.getArgTypeName(i);
                msg_string += ":";
                // display the argument - make sure we get the right type
                if(m.getArgType(i) == OFXOSC_TYPE_INT32){
                    msg_string += ofToString(m.getArgAsInt32(i));
                }
                else if(m.getArgType(i) == OFXOSC_TYPE_FLOAT){
                    msg_string += ofToString(m.getArgAsFloat(i));
                }
                else if(m.getArgType(i) == OFXOSC_TYPE_STRING){
                    msg_string += m.getArgAsString(i);
                }
                else{
                    msg_string += "unknown";
                }
            }
            // add to the list of strings to display
            msg_strings[current_msg_string] = msg_string;
            timers[current_msg_string] = ofGetElapsedTimef() + 5.0f;
            current_msg_string = (current_msg_string + 1) % NUM_MSG_STRINGS;
            // clear the next line
            msg_strings[current_msg_string] = "";
        }
    
    }
}

void ofEmotive::draw(){
    
    string buf;
    buf = "listening for osc messages on port" + ofToString(PORT);
    ofDrawBitmapString(buf, 10, 180);
    
    //draw sensors
    buf = "AF3" + ofToString(AF3, 4);
    ofDrawBitmapString(buf, 10, 100);
    
    for(int i = 0; i < NUM_MSG_STRINGS; i++){
        ofDrawBitmapString(msg_strings[i], 10, 40 + 15 * i);
    }
}