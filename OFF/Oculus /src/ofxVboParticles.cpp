//
//  ofxVboParticles.cpp
//
//  Created by Atsushi Tadokoro on 8/14/14.
//
//

#include "ofxVboParticles.h"

ofxVboParticles::ofxVboParticles(int _maxParticles, float _pointSize){
    maxParticles = _maxParticles;
    pointSize = _pointSize;
    numParticles = 0;
    friction = 0.01;
    
    positions = boost::circular_buffer<ofVec3f>(maxParticles);
    velocitys = boost::circular_buffer<ofVec3f>(maxParticles);
    forces = boost::circular_buffer<ofVec3f>(maxParticles);
    colors = boost::circular_buffer<ofColor>(maxParticles);
    
    static GLfloat distance[] = { 0.0, 0.0, 1.0 };
    glPointParameterfv(GL_POINT_DISTANCE_ATTENUATION, distance);
    glPointSize(pointSize);
    
    ofDisableArbTex();
    texture.loadImage("Textures/Soft64.png");
    ofEnableArbTex();
    
    billboards.addTexCoord(ofVec2f(0.0,1.0));
    
    /*
    ofPrimitiveMode primitiveMode = OF_PRIMITIVE_POINTS;
    ofSpherePrimitive sphere(100.0, 100);
    ofMesh tmpMesh;
    tmpMesh = sphere.getMesh();
    billboards.append(tmpMesh);
    
    billboards.setUsage(GL_STATIC_DRAW);
    billboards.setMode(primitiveMode);
    */
    billboards.setUsage(GL_DYNAMIC_DRAW);
    billboards.setMode(OF_PRIMITIVE_POINTS);
    billboards.disableTextures();

    billboards.getVertices().resize(maxParticles);
    billboards.getColors().resize(maxParticles);
    billboards.getNormals().resize(maxParticles, ofVec3f(0));
}

void ofxVboParticles::update(){
    for(int i = 0; i < positions.size(); i++){
        forces[i] = ofVec3f(0, 0, 0);
        forces[i] -= velocitys[i] * friction;
        velocitys[i] += forces[i];
        positions[i] += velocitys[i];
        billboards.getVertices()[i].set(positions[i].x, positions[i].y, positions[i].z);
    }
    
}

void ofxVboParticles::draw(){
    ofPushStyle();
    ofEnableDepthTest();
    ofEnablePointSprites();
    billboards.draw();
    ofDisablePointSprites();
    ofPopStyle();
}

void ofxVboParticles::addParticle(ofVec3f _position, ofVec3f _velocity, ofColor _color){
    positions.push_back(_position);
    velocitys.push_back(_velocity);
    colors.push_back(_color);
    forces.push_back(ofVec3f(0, 0, 0));
    
    billboards.getVertices()[numParticles].set(positions[numParticles].x, positions[numParticles].y, positions[numParticles].z);
    billboards.getColors()[numParticles].set(colors[numParticles]);
    
    if(positions.size() != maxParticles) numParticles++;
    
    /*
     numParticles++;
     if (positions.size() > maxParticles) {
     positions.pop_front();
     colors.pop_front();
     velocitys.pop_front();
     forces.pop_front();
     for (int i = 0; i < numParticles-1; i++) {
     //billboards.getVertices()[i] = billboards.getVertices()[i + 1];
     billboards.getColors()[i] = billboards.getColors()[i + 1];
     }
     
     numParticles--;
     }
     */
    
}