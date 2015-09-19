//
//  ofxVboParticles.h
//
//  Created by Atsushi Tadokoro on 8/14/14.
//
//

#pragma once
#include "ofMain.h"
#include "boost/circular_buffer.hpp"

class ofxVboParticles {
public:
    ofxVboParticles(int maxParticles = 10000, float pointSize = 1000);
    void update();
    void draw();
    void addParticle(ofVec3f position = ofVec3f(0, 0, 0),
                     ofVec3f velocity = ofVec3f(0, 0, 0),
                     ofColor color = 0xffffff);
    
    int maxParticles;
    float pointSize;

    int numParticles;
    
    boost::circular_buffer<ofVec3f> positions;
    boost::circular_buffer<ofVec3f> velocitys;
    //boost::circular_buffer<ofVec3f> forces;
    boost::circular_buffer<ofColor> colors;
    
    float friction;
    float fade;
    
    ofShader billboardShader;
    ofImage texture;
    ofVboMesh billboards;
};


