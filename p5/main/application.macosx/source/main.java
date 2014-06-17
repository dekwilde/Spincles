import processing.core.*; 
import processing.xml.*; 

import javax.media.opengl.*; 
import processing.opengl.*; 
import jsyphon.*; 
import ddf.minim.analysis.*; 
import ddf.minim.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class main extends PApplet {









Minim minim;
AudioInput in;
FFT fft;

JSyphonServer mySyphon;

float spring = 0.5f;
float gravityX = 0;
float gravityY = 0;

float bx;
float by;
int bs = 120;
float bdifx = 0.0f; 
float bdify = 0.0f;
int colorR = 0, colorG = 0, colorB = 0;

float iAngle;
float startAngle;
float iScale;
float startEscala;

float microfone = 0;
float delay_mic = 0;
float mic_perc = 50;


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
float airX = 0.0f;
float airY = 0.0f;

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



public void setup() 
{
        size(800,600, OPENGL);
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
        stroke(0xffffffff, 255);
        
        
        
        
  
        for(int i=0; i<numOfArms; i++) {
          rotation[i] = random(0, 360);
          angleRadius[i] = random(0.3f, 1.9f);
          angleSpeed[i] = random(0.009f, 0.16f);
          angleSegment[i] = random(0.09f, 1.4f);
          WeightSegment[i] = random(1.4f, 6.1f);
          segLength[i] = random(25, 65);
        } 
      

        bx = width/2;
        by = height/2;
        iAngle = 0;
        iScale = 0.8f;
        
        ball = new Ball(bx, by, bs);
}

public void draw() {
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
        x += dx * easing + nX*(microfone/3 + 5.2f);
        
        //targetY = mouseY;
        targetY = ball.y;
        float dy = targetY - y;
        float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
        airY += easing;  
        y += dy * easing + nY*(microfone/3 + 5.2f);
                
        
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

public void stop()
{
  // always close Minim audio classes when you finish with them
  minim.stop();
  
  super.stop();
}




class Arm {

  Arm(float angleSeg, float WeightSeg, float LengthSeg) {   
      pushMatrix();
      for(int i=0; i<numSegment; i++) {
        if(i>0) {
          segment(LengthSeg, 0, angleSeg*angleSegment[i]+(microfone/50)+angleRadiusTouch, ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg);
        } else {
          segment(0, 0, angleSeg, (numSegment+1)*WeightSeg, LengthSeg); 
        }
      }
      popMatrix();
  }
  
  public void segment(float x, float y, float a, float Weight, float LengthSeg) {
      translate(x, y);
      rotate(a);
      strokeWeight(Weight/SegWeightPor);
      line(0, 0, LengthSeg, 0);
  } 
}
class Ball {
  float diameter;
  float vx = 0;
  float vy = 0;
  
  float left = 100, right = 700, bottom = 100, top = 500;
  float xMax = 10, yMax = 5;
  float x = 400, y = 300;
  float xLimit, yLimit, xSpeed, ySpeed, xDelta, yDelta; 
  
  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
  }
  
  public void move() {
        
    if (x < left){
      xDelta = random(0,1);
      angleSpeedTouch =  random(0.02f, 0.14f);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (x > right){
      xDelta = random (-1,0);
      angleSpeedTouch =  random(0.02f, 0.14f);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else {
      xDelta = random(-1,1);
      angleSpeedTouch =  random(0.02f, 0.14f);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    }

    if (y < bottom){
      yDelta = random(0,1);
      angleSpeedTouch =  random(0.02f, 0.14f);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (y > top){
      yDelta = random (-1,0);
      angleSpeedTouch =  random(0.02f, 0.14f);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else {
      yDelta = random(-1,1);
      angleSpeedTouch =  random(0.02f, 0.14f);
    }

    xSpeed = xSpeed + xDelta;
    ySpeed = ySpeed + yDelta;

    if (xSpeed > xMax){
      xSpeed = xMax;
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (xSpeed < -xMax){
      xSpeed = -xMax;
    }

    if (ySpeed > yMax){
      ySpeed = yMax;
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (ySpeed < -yMax){
      ySpeed = -yMax;
    }

    x = x + xSpeed;
    y = y + ySpeed;
    
    angleSpeedTouch = angleSpeedTouch / 1.02f;
    angleRadiusTouch = angleRadiusTouch / 1.008f;
    WeightSegmentTouch = WeightSegmentTouch / 1.08f;
    
  }
  
}
class Tbody {
  
  Arm arms;  
   
  Tbody(float x, float y, float rotator, float escala) {

    stroke(255, 255); 
    translate(x, y);
    rotate(rotator);
    scale(escala);
    //
    for(int i=0; i<numOfArms; i++) {
      radius = angleRadius[i] * sin(angle[i]);
      arms = new Arm(radius, WeightSegment[i]+WeightSegmentTouch, segLength[i]);
      rotate(rotation[i]);
    }
    
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "main" });
  }
}
