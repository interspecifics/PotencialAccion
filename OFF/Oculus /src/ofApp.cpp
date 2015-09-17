#include "ofApp.h"

bool show_demo = false;
bool show_particle = true;
bool color_on = true;
bool show_grid = true;

/*
 TODO:
 
 Get OSC data
 relate Particles to OSC data
 Add Particle behaviour i.e. fade out with time, camera distance
 Add Particle Tile that uses specific Sensordata and spawns Particles
 
 */

//--------------------------------------------------------------
void ofApp::setup()
{
    ofBackground(0);
    ofSetLogLevel( OF_LOG_VERBOSE );
    ofSetVerticalSync( true );
    
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    cam.setFov(80);
    
    // ofxVboParticles([max particle number], [particle size]);
    vboPartciles = new ofxVboParticles(50000, 500);
    
    // set friction (0.0 - 1.0);
    vboPartciles->friction = 0.00;
    
    //    ofSetWindowPosition(1920, 0);
    //    ofToggleFullscreen();
    showOverlay = false;
    predictive = true;
    
    ofHideCursor();
    
    oculusRift.baseCamera = &cam;
    oculusRift.setup();
    
    
    
    for(int i = 0; i < 20; i++){
        DemoSphere d;
        d.color = ofColor(ofRandom(255),
                          ofRandom(255),
                          ofRandom(255));
        
        d.pos = ofVec3f(ofRandom(-500, 500),0,ofRandom(-500,500));
        
        d.floatPos.x = d.pos.x;
        d.floatPos.z = d.pos.z;
        
        d.radius = ofRandom(2, 50);
        
        d.bMouseOver = false;
        d.bGazeOver  = false;
        
        demos.push_back(d);
    }
    
    //enable mouse;
    cam.begin();
    cam.end();
}

void ofApp::spawn_particle(int x, int y, int z, int num, float hue)
{
    for (int i = 0; i < num; i++)
    {
        ofVec3f position = ofVec3f(ofRandom(-50, 50), ofRandom(-200, 200), 100);
        ofVec3f velocity = ofVec3f(0, 0, -2);
        ofColor color;
        int sat;
        if(color_on) sat = 200;
        else sat = 0;
        color.setHsb(hue, sat, 255);
        
        
        position += ofVec3f( x , y, z);
        // add a particle
        vboPartciles->addParticle(position, velocity, color);
    }
}


//--------------------------------------------------------------
void ofApp::update()
{
    
    emotive.update();
    //particle
    spawn_particle(-175, 0, 0, 10, 0);
    spawn_particle(-125, 0, 0, 10, 40);
    spawn_particle( -25, 0, 0, 10, 80);
    spawn_particle(  25, 0, 0, 10, 120);
    spawn_particle( 125, 0, 0, 10, 160);
    spawn_particle( 175, 0, 0, 10, 220);

    vboPartciles->update();
    //magically enable mouserotation
    oculusRift.worldToScreen(ofVec3f(), true);
    
    //demo
    if (show_demo)
    {
        for(int i = 0; i < demos.size(); i++){
            demos[i].floatPos.y = ofSignedNoise(ofGetElapsedTimef()/10.0,
                                                demos[i].pos.x/100.0,
                                                demos[i].pos.z/100.0,
                                                demos[i].radius*100.0) * demos[i].radius*20.;
            
        }
        
        
        if(oculusRift.isSetup()){
            ofRectangle viewport = oculusRift.getOculusViewport();
            for(int i = 0; i < demos.size(); i++){
                // mouse selection
                float mouseDist = oculusRift.distanceFromMouse(demos[i].floatPos);
                demos[i].bMouseOver = (mouseDist < 50);
                
                // gaze selection
                ofVec3f screenPos = oculusRift.worldToScreen(demos[i].floatPos, true);
                float gazeDist = ofDist(screenPos.x, screenPos.y, viewport.getCenter().x, viewport.getCenter().y);
                demos[i].bGazeOver = (gazeDist < 25);
            }
        }
    }
}


//--------------------------------------------------------------
void ofApp::draw()
{
    
    
    if(oculusRift.isSetup()){
        
        if(showOverlay){
            
            oculusRift.beginOverlay(-230, 320,240);
            ofRectangle overlayRect = oculusRift.getOverlayRectangle();
            
            ofPushStyle();
            ofEnableAlphaBlending();
            ofFill();
            ofSetColor(255, 40, 10, 200);
            
            ofRect(overlayRect);
            
            ofSetColor(255,255);
            ofFill();
            ofDrawBitmapString(ofToString(ofGetFrameRate(), 4) + "fps", 10, 20);
            ofDrawBitmapString("particle num = " + ofToString(vboPartciles->numParticles) + "\nPredictive Tracking " + (oculusRift.getUsePredictiveOrientation() ? "YES" : "NO"), 10, 35);
            ofDrawBitmapString("[f] key : toggle fullscreen", 10, 60);
            emotive.draw();
            ofSetColor(0, 255, 0);
            ofNoFill();
            ofCircle(overlayRect.getCenter(), 20);
            
            ofPopStyle();
            oculusRift.endOverlay();
        }
        
        ofSetColor(255);
        glEnable(GL_DEPTH_TEST);
        
        
        oculusRift.beginLeftEye();
        drawScene();
        oculusRift.endLeftEye();
        
        oculusRift.beginRightEye();
        drawScene();
        oculusRift.endRightEye();
        
        oculusRift.draw();
        
        glDisable(GL_DEPTH_TEST);
    }
    else{
        cam.begin();
        drawScene();
        cam.end();
    }
    
}

//--------------------------------------------------------------
void ofApp::drawScene()
{
    if(show_grid)
    {
        ofPushMatrix();
        ofRotate(90, 0, 0, -1);
        
        ofDrawGridPlane(500.0f, 10.0f, false );
        ofPopMatrix();
    }
    
    
    ofPushStyle();
    ofNoFill();
    
    if (show_particle)
    {
        //cam.begin();
        //ofRotate(ofGetElapsedTimef() * 20, 1, 1, 0);
        
        // draw particles
        vboPartciles->draw();
        
        //cam.end();
    }
    
    if (show_demo)
    {
        
        for(int i = 0; i < demos.size(); i++){
            ofPushMatrix();
            //		ofRotate(ofGetElapsedTimef()*(50-demos[i].radius), 0, 1, 0);
            ofTranslate(demos[i].floatPos);
            //		ofRotate(ofGetElapsedTimef()*4*(50-demos[i].radius), 0, 1, 0);
            
            if (demos[i].bMouseOver)
                ofSetColor(ofColor::white.getLerped(ofColor::red, sin(ofGetElapsedTimef()*10.0)*.5+.5));
            else if (demos[i].bGazeOver)
                ofSetColor(ofColor::white.getLerped(ofColor::green, sin(ofGetElapsedTimef()*10.0)*.5+.5));
            else
                ofSetColor(demos[i].color);
            
            ofSphere(demos[i].radius);
            ofPopMatrix();
        }
    }
    
    
    
    
    //billboard and draw the mouse
    if(oculusRift.isSetup()){
        
        ofPushMatrix();
        oculusRift.multBillboardMatrix();
        ofSetColor(255, 0, 0);
        ofCircle(0,0,.5);
        ofPopMatrix();
        
    }
    
    ofPopStyle();
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key)
{
    if( key == 'f' )
    {
        //gotta toggle full screen for it to be right
        ofToggleFullscreen();
    }
    
    if (key == 'g')
    {
        //toggle grid
        show_grid = !show_grid;
    }
    
    if (key == 'c')
        
    {
        color_on = !color_on;
    }
    
    if(key == 's'){
        oculusRift.reloadShader();
    }
    
    if(key == 'l'){
        oculusRift.lockView = !oculusRift.lockView;
    }
    
    if(key == 'o'){
        showOverlay = !showOverlay;
    }
    if(key == 'r'){
        oculusRift.reset();
        
    }
    if(key == 'h'){
        ofHideCursor();
    }
    if(key == 'H'){
        ofShowCursor();
    }
    
    if(key == 'p'){
        predictive = !predictive;
        oculusRift.setUsePredictedOrientation(predictive);
    }
    if(key == '1')
    {
        show_particle= !show_particle;
    }
    if(key == '2')
    {
        show_demo= !show_demo;
    }
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key)
{
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y)
{
    //   cursor2D.set(x, y, cursor2D.z);
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button)
{
    //    cursor2D.set(x, y, cursor2D.z);
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button)
{
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button)
{
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h)
{
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg)
{
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo)
{
    
}
