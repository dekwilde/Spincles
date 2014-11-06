import javax.media.opengl.*;
import processing.opengl.*;
import jsyphon.*;

import ddf.minim.analysis.*;
import ddf.minim.*;


Minim minim;
AudioInput in;
FFT fft;

JSyphonServer mySyphon;

float spring = 0.5;
float gravityX = 0;
float gravityY = 0;

float bx;
float by;
int bs = 120;
float bdifx = 0.0; 
float bdify = 0.0;
int colorR = 0, colorG = 0, colorB = 0;

float iAngle;
float startAngle;
float iScale;
float startEscala;

float microfone = 0;
float delay_mic = 0;
float mic_perc = 1;


int dim = 1300;

Ball ball;
Tbody body;

int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float radius = 0.0f;
float easing = 0.05f;
float x, y;
float targetX, targetY;
float pi = 0;
float airX = 0.0;
float airY = 0.0;

float [] rotation = new float[numOfArms];
float [] angleRadius = new float[numOfArms];
float [] angleSegment= new float[numOfArms];
float [] angleSpeed = new float[numOfArms];
float [] angle = new float[numOfArms];
float [] WeightSegment = new float[numOfArms];
float [] segLength = new float[numOfArms];
float angleSpeedTouch = 0.0f;
float angleRadiusTouch = 0.0f;
float WeightSegmentTouch = 0.0f;



void setup() 
{
        size(150,600, OPENGL);
        mySyphon = new JSyphonServer();
        mySyphon.test();
        mySyphon.initWithName("Transcreen");
        frameRate(30);
        
        minim = new Minim(this);
        //minim.debugOn();
        // get a line in from Minim, default bit depth is 16
        in = minim.getLineIn(Minim.STEREO, 512);
        fft = new FFT(in.bufferSize(), in.sampleRate());
        // use 128 averages.
        // the maximum number of averages we could ask for is half the spectrum size. 
        fft.linAverages(1);
        
        
        smooth();
        stroke(#ffffff, 255);
        
        
        
        
  
        for(int i=0; i<numOfArms; i++) {
          rotation[i] = random(0, 360);
          angleRadius[i] = random(0.3, 1.9);
          angleSpeed[i] = random(0.009, 0.16);
          angleSegment[i] = random(0.09, 1.4);
          WeightSegment[i] = random(1.4, 6.1);
          segLength[i] = random(25, 65);
        } 
      

        bx = width/2;
        by = height/2;
        iAngle = 0;
        iScale = 0.4;
        
        ball = new Ball(bx, by, bs);
}

void draw() {
      // get an OpenGL handle
      PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  
  
      // init vars DONT MOVE    
      gravityX = 0;
      gravityY = 0;
      fft.forward(in.mix);
      microfone = pow(fft.getAvg(0), 1) * mic_perc;
      //microfone = 0;
      
      println(microfone);
      
                
        delay_mic = delay_mic + (microfone*15 - delay_mic/4)/10;
                
        if (delay_mic>255) {
            delay_mic = 255;
        }
      
        
        fill(colorR, colorG, colorB, 255);
        noStroke();        
        rect(0,0,width,height);
        
        
        ball.move();
              
        
        for(int i=0; i<numOfArms; i++) {
          angle[i] = angle[i] + angleSpeed[i] + microfone/250 + angleSpeedTouch;
        }
        
        //targetX = mouseX;
        targetX = ball.x;
        float dx = targetX - x;
        float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
        airX += easing;
        x += dx * easing + nX*(microfone/3 + 5.2);
        
        //targetY = mouseY;
        targetY = ball.y;
        float dy = targetY - y;
        float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
        airY += easing;  
        y += dy * easing + nY*(microfone/3 + 5.2);
                
        
        float rotationT = noise(pi/500)*((dx*dy*easing)/450) + radians(iAngle) + microfone/40;
        
        body = new Tbody(x, y, rotationT, iScale);

        pi++;
        
          GL gl = pgl.beginGL();
  // copy to texture, to send to Syphon.
  int[] texID = new int[1];
  gl.glEnable(gl.GL_TEXTURE_RECTANGLE_EXT);
  gl.glGenTextures(1, texID, 0);
  gl.glBindTexture(gl.GL_TEXTURE_RECTANGLE_EXT, texID[0]);
  gl.glTexImage2D(gl.GL_TEXTURE_RECTANGLE_EXT, 0, gl.GL_RGBA8, width, height, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, null);  
  gl.glCopyTexSubImage2D(gl.GL_TEXTURE_RECTANGLE_EXT, 0,0, 0, 0, 0, width, height); 
  mySyphon.publishFrameTexture(texID[0], gl.GL_TEXTURE_RECTANGLE_EXT, 0, 0, width, height, width, height, false); 
  gl.glDeleteTextures(1, texID, 0);   
  pgl.endGL();
        
}

void stop()
{
  // always close Minim audio classes when you finish with them
  minim.stop();
  
  super.stop();
}




