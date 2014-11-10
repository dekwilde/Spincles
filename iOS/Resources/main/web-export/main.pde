/* @pjs transparent="true"; font="data/cubic.ttf, data/pixelart.ttf"; preload="data/logo.png"; */

PFont fontTitle, fontText;

float spring = 0.2;
float gravityX = 0.0;
float gravityY = 0.0;
float bx;
float by;
int bs = 120;
boolean bover = false;
boolean locked = false;
float bdifx = 0.0; 
float bdify = 0.0;

float iAngle;
float startAngle;
float iScale;
float startEscala;

float microfone = 0;
float delay_mic = 0;
float mic_perc = 50;

//float dim = 40;
var ctx;

PGraphics pimg;
int dim = 1300;

Ball ball;
IPhone iphone;
PSound sound1, sound2, sound3, sound4;
Tbody body;
TCompass compass;

int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float radius = 0.0f;
float easing = 0.05f;
float x = width/2; 
float y = height/2;
float targetX, targetY;
float spinX, spinY;
float pi = 0;

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
float rotationT = 0.0;

boolean cameraShow = false;
PImage infoImg, logoImg;

float initColorAlpha = 0.0;
float endColorAlpha = 0.0;
float initPosY = 0.0;

ButtonInfo btInfo;
ButtonStart btStart;
ButtonAgain btAgain;
ButtonCamera btCamera;
ButtonClose btClose;
MenuSlider slider;
ScoreInfo scoreInfo;

float pInfo = height;


var gameState = "Intro";

void setup() 
{
        size(320, 480);
        //size(screen.width, screen.height);
        //rectMode(CENTER_RADIUS);
        rectMode(CORNER);
        imageMode(CENTER);
        ctx = externals.context;        
        frameRate(30);
        //smooth();
        
        
        initPosY = height + 100;
        
        infoImg = loadImage("infos.jpg");
        logoImg = loadImage("logo.png");
        fontTitle = loadFont("data/cubic.ttf");        
        fontText = loadFont("data/pixelart.ttf");
        

        btInfo = new ButtonInfo();
        btStart = new ButtonStart();
        btAgain = new ButtonAgain();
        btCamera = new ButtonCamera();
        btClose = new ButtonClose();
        slider = new MenuSlider();
        scoreInfo = new ScoreInfo();

        compass = new Tcompass();
        trixBAD = new TrixParticle("bad");
        trixGOOD = new TrixParticle("good");
        

        
  
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
        iScale = 0.6;
        
        ball = new Ball(bx, by, bs);
        iphone = new IPhone();


        sound1 = iphone.loadSound("bg1.wav");
        sound2 = iphone.loadSound("bg2.wav");
        sound1.setVolume(100);
        sound2.setVolume(100);


        //setupThree();
        //video = loadImage("cam.png");
        
        println("4 - Start sequence: main.pde setup()");
}

void draw() {
  playloopBG();
  switch( gameState ) {      

    case "Intro":
      initColorAlpha = initColorAlpha + (255 - initColorAlpha)/20;
      background(255, 204, 0, initColorAlpha);
      fill(0);
      textFont(fontTitle, 10);
      textAlign(CENTER);
      text("Welcome to", width/2, height/2-80); 
      image(logoImg, width/2, height/2);
      
      if(initColorAlpha>220) {
        println(initPosY);
        initPosY = initPosY + (50 - initPosY)/10;
        pushMatrix();
        translate(0, initPosY);
        btStart.draw();
        popMatrix();
      }
      
      
    break; // End of Case Statement
    
    
    case "Over":
    
      initColorAlpha = initColorAlpha + (255 - initColorAlpha)/20;
    
      background(255, 204, 0, initColorAlpha);
      fill(0);
      textFont(fontTitle, 20);
      textAlign(CENTER);
      imageMode(CENTER);
      text("GAME", width/2, 60);
      text("OVER", width/2, 90);
      
      textFont(fontText, 16);
      text("score", width/2, 140);
      text(score, width/2, 160);
      text(scoreResult, width/2, 180);
      
      btAgain.draw();
      
    break; // End of Case Statement
    
    
    case "Win":
      initColorAlpha = initColorAlpha + (255 - initColorAlpha)/20;
    
      background(255, 204, 0, initColorAlpha);
      fill(0);
      textFont(fontTitle, 20);
      textAlign(CENTER);
      text("YOU", width/2, 30);
      text("WIN", width/2, 60); 
      
      btAgain.draw();
      
    break; // End of Case Statement

    case "InfoShow":
          fill(0, 0, 0, 20);
          rect(0,0,width,height);
          image(infoImg, width/2, pInfo+height/2);
        //tint(20);
          if (pInfo<1) {
              pInfo = 0;
              slider.draw();
              btClose.draw();
          }
          pInfo = pInfo - pInfo/6;
    break; // End of Case Statement
    
    case "Game":
        // init vars DONT MOVE    
        gravityX = iphone.getAcceleration().x;
        gravityY = -iphone.getAcceleration().y;
        
        //println("x: " + gravityX + " " + "y: " + gravityY);

        microfone = pow(iphone.getMicLevel(), 1) * mic_perc;                
        delay_mic = delay_mic + (microfone*15 - delay_mic/4)/10;
                
        if (delay_mic>255) {
            delay_mic = 255;
        }

        colorR = 255; // + microfone*20;
        colorG = 204; // + microfone*25;
        colorB = 0;   // + microfone*20;
   
	ctx.clearRect(0,0,width,height);// part of the canvasAPI that creates a clear rect
        //Camera();
        fill(colorR, colorG, colorB, 255 - delay_mic);
        noStroke();        
        rect(0,0,width,height);
        
        //Three();        
        
        ball.move();
        ball.touch();
        ball.display();
        
        
        compass.draw();
        trixBAD.draw();
        trixGOOD.draw();

        
        btInfo.draw();
        //btCamera.draw();
        scoreInfo.draw();
        
        
        
        ///////////////////////////////////////////////// Spincles draw /////////////////////////////////////////////////////////
        

        
        for(int i=0; i<numOfArms; i++) {
          angle[i] = angle[i] + angleSpeed[i] + microfone/250 + angleSpeedTouch;
        }
        
        //targetX = mouseX;
        targetX = ball.x;
        float dx = targetX - x;
        float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
        x += dx * easing + nX*(microfone/3 + 5.2);
        spinX = x;
        
        //targetY = mouseY;
        targetY = ball.y;
        float dy = targetY - y;
        float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
        y += dy * easing + nY*(microfone/3 + 5.2);
        spinY = y;

        //location();
        //pointCompass();
        //angleCompass = targetDEGREE - compassDEGREE;
        angleCompass = compassDEGREE + gestureRotation;

        //println("angleCompass: " + angleCompass);
                
        rotationT = noise(pi/500)*((dx*dy*easing)/450) + radians(iAngle) + microfone/40;
        
        body = new Tbody(x, y, rotationT, iScale);
        //+ noise(pi/10)*2)
        
        pi++;
        
        
    break; // End of Case Statement   

  } //end switch
}
class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
  }
  
  void move() {
    if (!locked) {
        bx = x;
        by = y;
        
        vx += gravityX;
        vy += gravityY;
        x += vx;
        y += vy;
        if (x + diameter/2 > width) {
          x = width - diameter/2;
          vx *= -spring; 
        }
        else if (x - diameter/2 < 0) {
          x = diameter/2;
          vx *= -spring;
        }
        if (y + diameter/2 > height) {
          y = height - diameter/2;
          vy *= -spring; 
        } 
        else if (y - diameter/2 < 0) {
          y = diameter/2;
          vy *= -spring;
        }
    } else {
        x = bx;
        y = by;
    }
  }
  
  void touch() {
    if (touch1X > x-bs && touch1X < x+bs && 
  	touch1Y > y-bs && touch1Y < y+bs) {
          bx = x;
          by = y;
          bover = true;
          
          
          if(!locked) { 
              //stroke(0); 
              //fill(0);
          } 
     } else {
          //stroke(0);
          //fill(255);          
          bover = false;
    }
    
    angleSpeedTouch = angleSpeedTouch / 1.02;
    angleRadiusTouch = angleRadiusTouch / 1.008;
    WeightSegmentTouch = WeightSegmentTouch / 1.08;
    //println("touch_off"); 
  }
  
  void display() {
    pushMatrix();
    stroke(0,255,0);
    noFill();
    ellipse(x, y, diameter, diameter);
    popMatrix();
  }
}
class ButtonAgain {
    boolean overButton = false;
    
    int pX = width/2;
    int pY = height/2;
    int dw = 60;
    int dh = 15;
    
    ButtonAgain() {
        smooth();
    }
    
    void draw() {
        checkButton();
              // Left buttom
        if (overButton == true) {
          stroke(#ffcc00);          
        } else {
          stroke(255);
        }
        fill(0);
        rect(pX, pY, dw, dh);
        fill(255);
        textFont(fontText, 14);
        textAlign(CENTER);
        text("Try Again", pX, pY);
        
        if (overButton == true) {
            overButton = false;
            resetGame();
        }
    } 
    
    
    void checkButton() {
          if (touch1X > pX-dw && touch1X < pX+dw && touch1Y > pY-dh && touch1Y < pY+dh) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}



class ButtonStart {
    boolean overButton = false;
    
    int pX = width/2;
    int pY = height/2+40;
    int dw = 120;
    int dh = 40;
    int fSize = 20;
    
    ButtonStart() {  
      
    }
    
    void draw() {
        checkButton();
              // Left buttom
        if (overButton == true) {
          stroke(#ffcc00);          
        } else {
          stroke(0);
        }
        noFill();
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill();
        textFont(fontText, fSize);
        textAlign(CENTER);
        text("Start", pX, pY);
        
        if (overButton == true) {
           overButton = false;
           startGame();
        }
    } 
    
    
    void checkButton() {
          if (touch1X > pX-dw && touch1X < pX+dw && touch1Y > pY-dh && touch1Y < pY+dh) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}


class ButtonInfo {
    boolean overButton = false;
    int dm = 20;   
    int pX = width - dm - 10;
    int pY = height - dm - 10;

    
    ButtonInfo() {  
    }    
    void draw() {
        checkButton();
          // Left buttom
        if (overButton == true) {
          gameState = "InfoShow";
          println("info");
          
          textFont(fontText, 20);
          textAlign(CENTER);
          
          // circulo          
          noStroke();
          fill(0);
          ellipse(pX, pY, dm, dm);
          
          fill(255);
          text("i", pX, pY+dm/2);
          
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();
          ellipse(pX, pY, dm, dm);
          
          fill(0);
          rect(pX-dm/8, pY-dm/8, dm/4, dm/4);
          

        }
    }
    void checkButton() {
          if (touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}



class ButtonClose {
    boolean overButton = false;
    int pX = 285;
    int pY = 25;
    int dm = 15; 
    
    ButtonClose() {  
      
    }
    
    void draw() {
        checkButton();
              // Left buttom
        if (overButton == true) {          
          // o "X"
          stroke(#ffcc00);          
        } else {
          // o "X"
          stroke(255);
        }
        strokeWeight(1);
        noFill();
        line(pX-dm, pY-dm, pX+dm, pY+dm);
        line(pX-dm, pY+dm, pX+dm, pY-dm);
        
        if (overButton == true) {
           background(0);
           pInfo = 480;    
           gameState = "Game";
           println("close");
        }
    } 
    
    
    void checkButton() {
          if (touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}





class ButtonCamera {
    boolean overButton = false;
    boolean pressButton = false;
    int dm = 20;
    int pX = 20;
    int pY = height -dm - 20; 
    
    ButtonCamera() {  
        
    }    
    void draw() {
        checkButton();
          // Left buttom
        if (overButton) {
          pressButton = true;
          overButton = false;
          cameraShow = true;
          println("camera " + cameraShow);
          iphone.squareCamera();    
          noStroke();
          fill(255);
 
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();    
        }
        rect(pX, pY, dm, dm);
    }
    void checkButton() {   
          if (!pressButton && touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}


PImage video;

int index = 0;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel

boolean loadCamera = false;
boolean checkCamera = false;

void Camera() {
  //background(0,0,0,0);
  checkCamera = iphone.checkCamera();
  if (checkCamera && !loadCamera) {
    println("4 - getCamera in pde: " + iphone.getCamera());
    video = requestImage(iphone.getCamera());
    loadCamera = true;
  } //end if checkCamera
  
 
    if(loadCamera) {
      
      
      
      
      println("6 - loaded image - ready Pixels Image");
      
      /*
      float brightestValue = 0; // Brightness of the brightest video pixel
      // Search for the brightest pixel: For each row of pixels in the video image and
      // for each pixel in the yth row, compute each pixel's index in the video
      video.loadPixels();
      for (int y = 0; y < video.height; y++) {
        for (int x = 0; x < video.width; x++) {
          // Get the color stored in the pixel
          int pixelValue = video.pixels[index];
          // Determine the brightness of the pixel
          float pixelBrightness = brightness(pixelValue);
          // If that value is brighter than any previous, then store the
          // brightness of that pixel, as well as its (x,y) location
          if (pixelBrightness > brightestValue) {
            brightestValue = pixelBrightness;
            brightestY = y;
            brightestX = x;
          }
          index++;
        }
      }
      */
      
            
      loadCamera = false;
      iphone.updateSquare();
    }
  
  
  // Draw a large, yellow circle at the brightest pixel
  //image(video, 0, 0, video.width, video.height);
  image(video, 0, 0, width/2, height/2);
  noStroke();
  fill(0,0,255);
  ellipse(brightestX*10, brightestY*10, 50, 50);
}

int lastTime = 0;
int interval = 5000;
   float lt;
   float lg;
   float al;
   float hd;
   float sp;
   
   float targetLT = -21.793933;
   float targetLG = -48.170929;
   float currentLT;
   float currentLG;
   float compassDEGREE, targetDEGREE;

void location() {
   int currentTime = millis();
   if (currentTime > lastTime+interval) {
        Location loc = iphone.getLocation();
        lt = loc.latitude;
        lg = loc.longitude;
        al = loc.altitude;
        hd = loc.heading;
        sp = loc.speed;

        lastTime = currentTime;
        iphone.getCurrentLocation();
        println("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp);

    }
    //fill(0); 
    //text("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp, 10, 40);

}


void compassEvent() {
  //println(compassHeading);
  compassDEGREE = compassHeading;
}

void locationEvent() {
  //text("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading, 10, 80);
  println("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading);
}

void pointCompass() {
    currentLT = lt;
    currentLG = lg;
        
    diffLT = targetLT - currentLT;
    diffLG = targetLG - currentLG;
    
    /*
    if (diffLT == 0) {
        if (diffLG > 0) {
            targetDEGREE = 90;
        }
        else {
            targetDEGREE = 270;
        }
    }
    else {
        targetDEGREE = atan2(diffLT, diffLG) * 180 / PI;
        
    }

    if (diffLT < 0) {
        targetDEGREE = targetDEGREE + 180;
    }
    */
    
    targetDEGREE = atan2(diffLT, diffLG) * 180 / PI;
    //println(targetDEGREE);
}




class MenuSlider {
   
    float st_x;
    float st_y;
    int st_s = 30;
    float st_difx = 0.0; 
    float st_dify = 0.0; 
    float init = 35;
    float end = 285;
    
    
    MenuSlider() {  
      st_x = 160;
      st_y = 100;
    }
    
    void draw() {
      //Draw Line
      line(init, st_y, end, st_y);
      
      // Draw the button
      if (st_x>end) {
        st_x = end;
      }
      if (st_x<init) {
        st_x = init;
      }
      fill(0);
      ellipse(st_x, st_y, st_s, st_s);

      
      mic_perc = (st_x-init) / ((end-init)/100);
      
      //println(perc);
      
      
      if (touch1X > st_x-st_s && touch1X < st_x+st_s && 
      	touch1Y > st_y-st_s && touch1Y < st_y+st_s) {
             st_x = touch1X;  
         } else {
           st_x = st_x;
      }
      
    }
    
 
    
} // end class

class Tcompass {  
  TrixelMatrix trixelMtx;
  float pX = 0.0;
  float pY = 0.0;
  
  Tcompass() {
    trixelMtx = new TrixelMatrix();
  }
  void draw() {
    //trixelX += (spinX - trixelX)*easing;
    //trixelY += (spinY - trixelY)*easing;
    
    trixelX = spinX;
    trixelY = spinY;
    

    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(trixelY-height/2, trixelX-width/2);
    rotate(a);
    trixelMtx.draw();
    popMatrix();
  }  
}
var r3d = 0;
PShape model;   

void setupThree() {
  model = loadShape("Falcon.obj");
  
}

void Three() {
  
  pushMatrix();
  hint(DISABLE_DEPTH_TEST);
  translate(width/2, height/2, 80);
  rotateX(r3d += 0.01);
  rotateY(r3d += 0.01);
  rotateZ(r3d += 0.01); 
  scale(8);  
  hint(ENABLE_DEPTH_TEST);
  shape(model);
  popMatrix();
}
TrixParticle trixBAD;
TrixParticle trixGOOD;
ArrayList particles;

class TrixParticle {
  int num;
  int amount = 5;
  String tp;
  
  TrixParticle(String type) {
    tp = type;
    particles = new ArrayList();
    num = 0;
  }
  
  void draw(){
    num += 1;
    if(num<amount) {
      particles.add(new Particle(tp));
    }
    for(int i=0; i < particles.size(); i++){
      Particle p = (Particle) particles.get(i);
      p.run();
      //p.gravity();
      p.display();
      p.conect();
      p.dead();
      if(p.death){
        particles.remove(i);
      }
    }
  }
  
  
}


class Particle{
  float x;
  float y;
  float xspeed = 0;
  float yspeed = 0;
  float myDiameter= 2;
  float distance = 90;
  float delay = random(0.001, 0.01);
  float elastic = 0.98;
  int life =0, lifeTime = 50+int(random(200));
  boolean death = false;
  String tp;

  
  Particle(String type){
    tp = type;
    if(tp == "good") {
      x= int(random(width));
      y= int(random(height));
    }
    if(tp == "bad") {
      x= spinX;
      y= spinY;
      xspeed= random(-2, 2);
      yspeed= random(-2, 2);  
    }
  }
    
  void run(){
    if(tp == "good") {
      float dx = spinX - x;
      float dy = spinY - y;
      xspeed = dx*delay+xspeed*elastic;
      yspeed = dy*delay+yspeed*elastic;
      x = x+xspeed;
      y = y+yspeed;
    }
    if(tp == "bad") {
      x = x+xspeed;
      y = y+yspeed; 
    }
    
  }
    
  void display(){
    noStroke();
    fill(0);
    ellipse(x, y, 2, 2);
  }
  
  void gravity(){
    yspeed += 0.01;
  }
  
  void dead() {
    life += 1;
    if(life>lifeTime) {
      death = true;  
    } else {
      death = false;
    } 
  }
  
  void conect() {
    for (int i = 0; i <particles.size() ; i++) {
      
      Particle other = (Particle) particles.get(i);
 
      if (this != other) {
        if (dist(x, y, other.x, other.y)<distance) {
          stroke(0,0,0,70);
          line(x, y, other.x, other.y);
          noStroke();
          fill(0, 0, 0, random(100));
          ellipse(x,y,myDiameter*5,myDiameter*5);
        }
      }
    } //end for
  }
  
    
}
//LAYOUT and ANIMATION
int wCount = 4;
int hCount = 3;
int rad = 140; //triangle radius
float mx, my; //mouse or object position middle;
float twothird = 2.0/3.0; //triangle use
float trixelX, trixelY;
float angleCompass;
float delaySpeedCompass = 20;

//ENGINE GAME
int rangeCentroid = 10;
int changeTimeRange = 10;
int changeTimeRand = 10;
int changeTimeRandRange = 200;
int activeEnemyRange = 3;




class TrixelMatrix {
  GridTrixel gridtrixel;
  float r = 0.0; //rotation var
  float dgr;
  float d; // distance mouse to center, mouse middle
  float speed = 1; //speed for rotation
  TrixelMatrix() {
    gridtrixel = new GridTrixel(); 
  }
  
  void draw() {
    //r = r + speed;

    dgr = abs(radians(angleCompass) - PI)*PI;
    r += (dgr - r)*easing;
    
    
    //println("degrees " + angleCompass);
    //println("radians " + r);
    d = dist(width/2, height/2, trixelX, trixelY);
    mx = d*cos(-r);
    my = d*sin(-r);
  
    pushMatrix();
    rotate(r);
    gridtrixel.draw();
    fill(0,255,0);
    ellipse(mx,my, 30, 30); // target position
    popMatrix();
    stroke(0,255,0);
    line(0, 0, 0, 20); //point compass
  }
}

class GridTrixel {
  Trixel[] trixel;
  int n = 0;
  int count;
  int angleStart = 2;
  int angleEnd = 6;  
  GridTrixel() {
    count = wCount*hCount*(angleEnd-angleStart);
    trixel = new Trixel[count];
    for(int i=0; i < hCount; i++) {
      for(int j=0; j < wCount; j++) {
        for(int k=angleStart; k < angleEnd; k++) {
          trixel[n++] = new Trixel(j, i, rad, k);  
        }
      }
    }
    
  }
  
  void draw() {
    for (int i = 0; i < count; i++) {
      trixel[i].draw();
    }
  }
}







class Trixel {
  Triangle t;
  float x1, y1, x2, y2, x3, y3;
  float radius;
  int range;
  int changeTrix = 0;
  int changeTime;
  boolean activeTrix = false;
  float aniTrix;
  XY a,b,c;
  XY centroid;
  

  
  Trixel(float i, float j, float r, int inv) {
      
      changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
      radius = r;
      x1 = (i-(wCount-1)/2)*radius;      
      y1 = (j-(hCount-twothird)/2)*(radius + radius*twothird+radius*0.065625)+radius/2+radius*0.065625;
      
      float angle = (TWO_PI / 6) * inv;
      x2 = x1 + cos( angle ) * radius;
      y2 = y1 + sin( angle ) * radius;
      
      x3 = x1 + (cos(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
      y3 = y1 + (sin(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
      
      a = new XY(x1,y1);
      b = new XY(x2,y2);
      c = new XY(x3,y3);
      centroid = new XY(-1,-1);
      XY bc = new XY(b.x+(c.x-b.x)/2, b.y+(c.y-b.y)/2);
      centroid.set( int(a.x+(bc.x-a.x)*twothird) , int(a.y+(bc.y-a.y)*twothird) );
      t = new Triangle(x1,y1,x2,y2,x3,y3);
      //ENGINE
      
      range = int(random(rangeCentroid));

  }
    
  void draw() {
    changeTrix = changeTrix + 1;
    if(changeTrix>changeTime) { //warnning
      fill(255,255,255,int(random(255)));
      if(changeTrix>changeTime+20) { //actived
        resetTrix();
      }
    } else {
      noFill();
    }
    
    if(range == 0) { //enemy
      fill(255);  
    }
    if(range == 1) { //life
      troid();
    }
    

    
    
    if(checkCollision(mx,my,t)){
      if(range == 0) { //enemy
        //rotate(random(10));
        energy = energy - 1;
        fill(int(random(255)),int(random(100)));
        if(!activeTrix) {
          activeTrix = true;
          aniTrix = changeTrix;
        }
        if(changeTrix>aniTrix+activeEnemyRange){
          hurt();
          println("energy " + energy);
          resetTrix();
          trixBAD.num = 0;
        }
      }
      if(range == 1) { //score
        energy = energy + 2;
        score = score + 1;
        println("energy " + energy);
        resetTrix();
        trixGOOD.num = 0;
        
      }
    } else {
      activeTrix = false;
    }
    
    
    
    stroke(255);
    strokeWeight(1);
    t.drawTriangle();
  }

  void resetTrix() {
    range = int(random(rangeCentroid));
    changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
    changeTrix = 0;
    activeTrix = false;
  }
  
  void troid() {
    stroke(0);
    fill(0);
    stroke(0); 
    ellipse(centroid.x, centroid.y, 10, 10);
    noFill();
  }
  

  boolean checkCollision(float x, float y, Triangle t) {
    float tArea,t1Area,t2Area,t3Area;
    tArea  = triangleArea(t.point1x, t.point1y, t.point3x, t.point3y, t.point2x, t.point2y);
    t1Area = triangleArea(x,y, t.point2x, t.point2y, t.point3x, t.point3y);
    t2Area = triangleArea(x,y, t.point3x, t.point3y, t.point1x, t.point1y);
    t3Area = triangleArea(x,y, t.point2x, t.point2y, t.point1x, t.point1y);    
    float totalArea = t1Area+t2Area+t3Area;
    return (totalArea == tArea);
  }
  
  float triangleArea(float p1, float p2, float p3, float p4, float p5, float p6) {
    float a,b,c,d;
    a = p1 - p5;
    b = p2 - p6;
    c = p3 - p5;
    d = p4 - p6;
    return (0.5* abs((a*d)-(b*c)));
  }
  
  
}



class Triangle {
  float point1x;
  float point1y;
  float point2x;
  float point2y;
  float point3x;
  float point3y;
  
  Triangle(float point1x,float point1y,float point2x,float point2y,float point3x,float point3y){
    this.point1x = point1x;
    this.point1y = point1y;
    this.point2x = point2x;
    this.point2y = point2y;
    this.point3x = point3x;
    this.point3y = point3y;        
  }
  
  void drawTriangle() {
    triangle(point1x, point1y, point2x, point2y, point3x, point3y);
  }
}






class XY
{
    float x, y;
    
    XY (float xx, float yy)
    {
        x=xx; 
        y=yy;
    }
    
    boolean inside (int xx, int yy)
    { 
        return (xx>x-5 && xx<x+5 && yy>y-5 && yy<y+5); 
    }
    
    void set ( int _x, int _y )
    {
        x=_x; 
        y=_y;
    }
}

class Tbody {
  float x, y;  
  Arm arms;  
   
  Tbody(float posX, float posY, float rotator, float escala) {
    x = posX;
    y = posY;
    stroke((0 + microfone*15), 80); 
    translate(posX, posY);
    rotate(rotator);
    scale(escala);
    //
    for(int i=0; i<numOfArms; i++) {
      radius = angleRadius[i] * sin(angle[i]);
      arms = new Arm(radius, WeightSegment[i]+WeightSegmentTouch, segLength[i]);
      rotate(rotation[i]);
      
      //rotate(PI/(numOfArms/2));
      //rotate(random(PI));
    }
    
  }
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
  
  void segment(float x, float y, float a, float Weight, float LengthSeg) {
      translate(x, y);
      rotate(a);
      strokeWeight(Weight/SegWeightPor);
      line(0, 0, LengthSeg, 0);
  } 
}
void gestureStarted() {
	startAngle = iAngle;
	startEscala = iScale;
}

void gestureChanged() {
	iAngle = startAngle + gestureRotation;
	iScale = startEscala * gestureScale;
	if (iAngle > 360) {
		iAngle = iAngle - 360;
	}
	if (iAngle < 0) {
		iAngle = 360 + iAngle;
	}
}

void gestureStopped() {
	startAngle = iAngle;
	startEscala = iScale;
}

void touch1Started() {
  //GEsture Drag Spincles
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
       bover = true;
       
       
  } else {

    
  }
  
  if(bover) { 
    locked = true;
    
  } else {
    locked = false;
  }
  bdifx = touch1X-bx; 
  bdify = touch1Y-by; 
}

void touch1Moved() {
  if(locked) {
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }
}


void touch1Stopped() {  
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
         //hurt();
  }
  
  // click info var
  //btClose.overButton = false;
  //btInfo.overButton = false;
  //btSupport.overButton = false;
  //btContact.overButton = false;
  
  // gesture var
  //bover = false;
  locked = false;
}

void hurt() {
  angleSpeedTouch =  random(0.02, 0.14);
  angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
  WeightSegmentTouch =  random(4.0, 10.0);  
}

void shakeEvent() {
  println("shaked");
}

boolean playSound1 = false;
boolean playSound2 = false;
void playloopBG() {
  
    int m = round(millis()/1000);
    
    if(!playSound1) {
      playSound1 = true;
      sound1.play();
      sound1.loop();
      println("sound1");
    }
    if(m == 3) {
      if(!playSound2) {
        playSound2 = true;
        sound2.play();
        sound2.loop();
        println("sound2");
      }  
    }
}
void startGame() {
    recordScore = iphone.loadState();
    iphone.startMicMonitor();
    iphone.startAccelerometer();
    iphone.startCompass();
    //iphone.startLocation();
    iphone.squareCamera();
    resetGame();
}


void resetGame() {
  energy = 30;
  score = 0;
  gameState = "Game";
  println(gameState);
  sound1.setVolume(100);
  sound2.setVolume(100);  
}


void gameOver() {
  //First time score
  if(recordScore != null) {
    //check if the score is a new record
    if(score>recordScore) {
      scoreResult = "New Record";
      recordScore = score;
      iphone.saveState(score);
    } else {
      scoreResult = "Record " + (String)recordScore;
    }
  } else {
    recordScore = score;
    iphone.saveState(score);
  } 
  gameState = "Over";
}

void gameWin() {
  //
}

int score = 0;
int energy = 0;
String scoreResult = "";
int recordScore;
class ScoreInfo {

    
    int dw = 100;
    int dh = 10;
    float px = width - dw - 10;
    float py = 10;  
    

  
    ScoreInfo() {
      //Setuo do botão 
    }
    
    void draw() {
      if(energy < 0) {
          gameOver();
      }
      
      
      if(energy>100) {
        gameWin();
      }
        
      if(energy>25 && energy<29) {
        numSegment = 4;
        numOfArms = 8;  
      } 
      else if(energy>20 && energy<24) {
        numSegment = 3;
        numOfArms = 7;  
      }
      else if(energy>15 && energy<19) {
        numSegment = 3;
        numOfArms = 5;  
      }
      else if(energy>10 && energy<14) {
        numSegment = 3;
        numOfArms = 5;  
      }
      else if(energy>5 && energy<9) {
        numSegment = 2;
        numOfArms = 3;  
      }

      pushMatrix();
      scale(1.0);
      
      stroke(0);
      noFill();
      rect(px, py, dw, dh);
      
      fill(0);
      noStroke();
      rect(px, py, energy, dh);
      
      stroke(255);

      line(px+10, py+dh/2, px+80, py+dh/2);
      line(px+10, py+ dh/5, px+10, py+ dh - dh/5);
      line(px+80, py+ dh/5, px+80, py+ dh - dh/5);    
    
      popMatrix();
      textFont(fontText, 14);
      textAlign(RIGHT);
      text(score, px-5, py+10);        

    }

}

