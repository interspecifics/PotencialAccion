/**
 *
 * OFDevCon Example Code Sprint
 *
 * This example shows building a mesh, texturing it with a webcam, and extruding the vertices based on the pixel brightness
 * Moving the mouse also rotates the mesh to see it at different angles
 *
 * Created by Tim Gfrerer and James George for openFrameworks workshop at Waves Festival Vienna sponsored by Lichterloh and Pratersauna
 * Adapted during ofDevCon on 2/23/2012
 */


#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    isShaderDirty = true;
    ofEnableDepthTest(); //make sure we test depth for 3d
    myC=ofColor(100,100,100);
    ofSetVerticalSync(true);
    ofEnableLighting();
    ofEnableAlphaBlending();
    ofEnableSmoothing();
    ofHideCursor();
    glShadeModel(GL_FLAT);
    debugger = 1;
    ofSetFrameRate(40);
    ofBackground(6,6,6);
    updateFrameRate = 1;
    mainMesh.enableIndices();
    
    
    spacing=110;  //spacing multiplication to adjust the size of the mesh
    width = 400/10; //ammount of vertex in the width
    height = 500/10; //ammount of vertex in the height
    
    for (int y = 0; y < height; y++){ //generating the bath mesh
        for (int x = 0; x<width; x++){
            float a = x * .01;
            float b = y * .01-ofGetFrameNum() / 200.0;
            //float c = ofGetFrameNum() / 150.0;
            float c=50;
            float noise = exp(abs(ofNoise(a,b,c))) * 25;
            
            
            mainMesh.addVertex(ofPoint(x*spacing,y*spacing,noise));	// mesh index = x + y*width
												// this replicates the pixel array within the camera bitmap...
            mainMesh.addColor(ofFloatColor(1,1,1,1));  // placeholder for colour data, we'll get this from the camera
            mainMesh.addNormal(ofVec3f(0,ofRandom(1),-ofRandom(1)));
        }
    }
    
    for (int y = 0; y<height-1; y++){//generating the faces in the mesh i.e. connecting always three points to a triangle
        for (int x=0; x<width-1; x++){
            mainMesh.addIndex(x+y*width);				// 0
            mainMesh.addIndex((x+1)+y*width);			// 1
            mainMesh.addIndex(x+(y+1)*width);			// 10
            
            mainMesh.addIndex((x+1)+y*width);			// 1
            mainMesh.addIndex((x+1)+(y+1)*width);		// 11
            mainMesh.addIndex(x+(y+1)*width);			// 10
        }
    }
    //preparing the mesh
    mainMesh.clearNormals();
    mainMesh.addNormals(mainMesh.getFaceNormals(true));
    
    

    //Settingup the correct lighting
    ofSetSmoothLighting(true);
    pointLight.enable();
    pointLight.setPointLight();
    pointLight.setPosition((width*spacing)/2,(height*spacing)/2,550);
    pointLight.roll(90);
    
    //Creating a somewhat matt material
    material.setDiffuseColor(ofColor(200,200,200));
    material.setSpecularColor(ofColor(200,200,200));
    material.setShininess(125.0f);

    
    //Moving and rotating the camera to the correct position
    cam.setScale(1,-1,1);
    cam.setPosition(width/2*spacing, height*spacing  , 400);

    cam.tilt(-80);
    extrusionAmount = 0.5;
    
    
    mainL.allocate(ofGetScreenWidth()/2,ofGetScreenHeight());
    mainL.begin();
    ofClear(255, 255, 255);
    mainL.end();
    
    mainR.allocate(ofGetScreenWidth()/2,ofGetScreenHeight());
    mainR.begin();
    ofClear(255, 255, 255);
    mainR.end();
}

//--------------------------------------------------------------
void ofApp::update(){
    
    
    if (isShaderDirty){  //Sometimes the shader breaks this resets it
        
        GLuint err = glGetError();	// we need this to clear out the error buffer.
        
        if (mShdPhong != NULL ) delete mShdPhong;
        mShdPhong = new ofShader();
        mShdPhong->load("shaders/phong");
        err = glGetError();	// we need this to clear out the error buffer.
        ofLogNotice() << "Loaded Shader: " << err;
        
        
        isShaderDirty = false;
    }
    
    
    
    pointLight.lookAt(ofVec3f(mouseX*spacing,mouseY*spacing,50));
    if(ofGetFrameNum() % updateFrameRate == 0) {
        float numbers[width*height];
        ofVec3f *Normals = new ofVec3f[width*height];
        for (int i=0; i<width*height; i++){          //Thisloops generates a new noise pattern
            float a = i%width * .051;
            float b = i/width * .051-ofGetFrameNum() / 200.0;
            float c=50+ofGetFrameNum() / 500.0;
            numbers[i] = exp(-1+debugger*abs(ofNoise(a, b, c))) * 400;
            

        }
        
        for (int y = 0; y<height-1; y++){ //These loops calculate the normals for the new mesh shape
            for (int x=0; x<width-1; x++){
                
                float a = numbers[x+y*width];
                float b = numbers[(x+1)+y*width];
                float c = numbers[x+(y+1)*width];			// 10
                
                ofVec3f test = ((ofVec3f(x*spacing,y*spacing,a)-ofVec3f(spacing*x+1,y*spacing,b)).getCrossed((ofVec3f(x*spacing,y*spacing,a)-ofVec3f(x*spacing,1+y*spacing,c)))).normalize();
                Normals[x+y*width] = test;
                Normals[x+(y+1)*width]=test;
                Normals[(x+1)+y*width]=test;
                
                test = ((ofVec3f(1+x*spacing,y*spacing,a)-ofVec3f(spacing*x+1,1+y*spacing,b)).getCrossed((ofVec3f(1+x*spacing,y*spacing,a)-ofVec3f(x*spacing,1+y*spacing,c)))).normalize();
                
                
                Normals[(x+1)+y*width] = test;
                Normals[(x+1)+(y+1)*width]=test;
                Normals[(x)+(y+1)*width]=test;
                
                
            }
        }
        
        
        for (int i=0; i<width*height; i++){    //This loop updates the mesh
            
            ofVec3f tmpVec = mainMesh.getVertex(i);
            tmpVec.z = numbers[i] * extrusionAmount;
            mainMesh.setVertex(i, tmpVec);
            mainMesh.setNormal(i,Normals[i]);
            
        
            
           
        }
       
        delete [] Normals;
    }
    
    material.setDiffuseColor(myC);
    mainL.begin();
    ofClear(0, 0, 0);
    cam.begin();
    drawScene();
    cam.end();
    mainL.end();
    

    mainR.begin();
    ofClear(0, 0, 0);
    cam.begin();
    ofTranslate(-300, 0); // this controlls the offset between th two eyes
    drawScene();
    cam.end();
    mainR.end();
    
}
void ofApp::draw(){
 
    mainL.draw(0, 0); // Drawing the two framebufferObject on the left and right side
    mainR.draw(ofGetScreenWidth()/2,0);

}

//--------------------------------------------------------------
void ofApp::drawScene(){
    ofEnableDepthTest();
  
    material.begin();
    mShdPhong->begin();
    glShadeModel(GL_FLAT);
    
    ofSetColor(myC);
    //pointLight.draw(); // to debug the position of the light
    mainMesh.draw();
    
    mShdPhong->end();
    
    /*  // This code will draw normals allong the faces
     vector<ofVec3f> n = mainMesh.getNormals();
     vector<ofVec3f> v = mainMesh.getVertices();
     float normalLength = 50.;
     
     if(!ofGetKeyPressed()){
     ofDisableLighting();
     ofSetColor(255,0,0,250);
     for(unsigned int i=0; i < n.size() ;i+=19){
     
     ofLine(v[i].x,v[i].y,v[i].z,
     v[i].x+n[i].x*normalLength,v[i].y+n[i].y*normalLength,v[i].z+n[i].z*normalLength);
     
     
        }
     }*/
    
    material.end();
    pointLight.disable();
    ofDisableLighting();
   
   
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    switch(key) {
        case 'f':
            ofToggleFullscreen();
            break;
        case 'l':
            debugger+=0.05; //adjusting the noise height l and k
            break;
        case 'k':
            debugger-=0.05;
            break;
            //Adjustting the color q w e increases and a s d decreases Red Green Blue respectivly
        case'q':
            myC.r=ofClamp(myC.r+5,0,255);
            break;
        case'w':
            myC.g=ofClamp(myC.g+5,0,255);
            break;
        case'e':
            myC.b=ofClamp(myC.b+5,0,255);;
            break;
            
        case'a':
            myC.r=ofClamp(myC.r-5,0,255);
            break;
        case's':
            myC.g=ofClamp(myC.g-5,0,255);
            break;
        case'd':
            myC.b=ofClamp(myC.b-5,0,255);
            break;
            
    }
    
    
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    isShaderDirty=true;
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 
    
}
