var video = document.createElement("img");
video.setAttribute("style", "display:none;");
video.id = "videoOutput";
video.src = "data/cam.png";


float spring = 0.5;
float gravityX = 0;
float gravityY = 0;

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
PImage camImg;

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


boolean infoShow = false;
PImage infoImg;
ButtonInfo btInfo;
ButtonClose btClose;
MenuSlider slider;
float pInfo = 480;

void setup() 
{
        size(320, 480);
        ctx = externals.context;
        frameRate(30);
        background(0);
        
        infoImg= loadImage("infos.jpg");
  
        btInfo = new ButtonInfo();
        btClose = new ButtonClose();
        slider = new MenuSlider();
        compass = new Tcompass();
        
        PFont fontA = loadFont("SansSerif-10.vlw");
	textFont(fontA, 10);
        
        //drawGradient();
        
        //noFill();
        //noStroke();
        //smooth();
        //rectMode(CENTER_RADIUS);
  
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
        iScale = 1.0;
        
	ball = new Ball(bx, by, bs);
	iphone = new IPhone();

	
        sound1 = iphone.loadSound("background.wav");
        sound1.play();
        sound1.loop();
        
        /*
        sound2 = iphone.loadSound("soprar.wav");
        sound2.play();
        sound2.loop();
        */
        

	iphone.startMicMonitor();
	iphone.startAccelerometer();
        iphone.startCompass();
        iphone.startLocation();
        iphone.squareCamera();    
        //camImg = loadImage(iphone.getCamera());

}

void draw() 
{
      // init vars DONT MOVE    
      gravityX = iphone.getAcceleration().x;
      gravityY = -iphone.getAcceleration().y;
      microfone = pow(iphone.getMicLevel(), 1) * mic_perc;
      
      if (infoShow) {
          image(infoImg, 0, pInfo);
        //tint(20);
          if (pInfo<1) {
              pInfo = 0;
              slider.frame();
              btClose.frame();

          }
          pInfo = pInfo - pInfo/6;
      } else {
                
        delay_mic = delay_mic + (microfone*15 - delay_mic/4)/10;
        
        
            
    
        
        if (delay_mic>255) {
            delay_mic = 255;
        }
        
        
        if (delay_mic<128) {
            colorR = 255; // + microfone*20;
            colorG = 204; // + microfone*25;
            colorB = 0;   // + microfone*20;
        } else {
            colorR = 0;
            colorG = 0;
            colorB = 0;
        }
        
        if (colorR>255) {
            colorR = 0;
        }
        if (colorG>255) {
            colorG = 0;
        }
        if (colorB>255) {
            colorB = 0;
        }
        
        //println(microfone);
        	
        fill(colorR, colorG, colorB, 255 - delay_mic);
        noStroke();        
        rect(0,0,width,height);
        
        //println(iphone.getCamera()); 
        //camImg = loadImage(iphone.getCamera());
        
        /*
        pushMatrix();
        translate(320,0);
        scale(-1,1);//mirror the video
        ctx.drawImage(video, 0, 0, 320, 480); //video is defined outside processing code
        popMatrix();
        camImg=get();
        */
        
        
        
        //image(camImg,0,0); 
        
        ball.move();
	ball.touch();
	//ball.display();        
        
        
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
        
        btInfo.frame();
        location();
        compass.frame(targetDEGREE - compassDEGREE);
        
        
        float rotationT = noise(pi/500)*((dx*dy*easing)/450) + radians(iAngle) + microfone/40;
        
        body = new Tbody(x, y, rotationT, iScale);
        //+ noise(pi/10)*2)
        
        sound1.setVolume(microfone*10);
        //sound2.setVolume(delay_mic/1000);
        pi++;
        

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
              //stroke(255); 
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
    ellipse(x, y, diameter+diameter*microfone, diameter+diameter*microfone);
  }
}
class ButtonClose {
    boolean overButton = false;
    int pX = 285;
    int pY = 25;
    int dm = 15; 
    
    ButtonClose() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }
    
    void frame() {
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
           infoShow = false;
           println("close " + infoShow);
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
class ButtonInfo {
    boolean overButton = false;
    int pX = 300;
    int pY = 460;
    int dm = 12;   
    
    ButtonInfo() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }    
    void frame() {
        checkButton();
          // Left buttom
        if (overButton == true) {
          infoShow = true;
          println("info " + infoShow);
          
          // circulo          
          noStroke();
          fill(0);
          ellipse(pX, pY, 16, 16);
          
          // o "i"
          noStroke();
          fill(#ffcc00);
          rect(pX, pY+2, 1, 4);
          
          //ping do i
          noStroke();
          fill(#ffcc00);
          ellipse(pX, pY-4, 2, 2);
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();
          ellipse(pX, pY, 16, 16);
          
          // o "i"
          noStroke();
          fill(0);
          rect(pX, pY+2, 1, 4);
          
          //ping do i
          noStroke();
          fill(0);
          ellipse(pX, pY-4, 2, 2);
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
   float compassDEGREE;

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
    pointCompass();
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
      rectMode(RADIUS);  
    }
    
    void frame() {
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

class Tbody {
  
  Arm arms;  
   
  Tbody(float x, float y, float rotator, float escala) {

    stroke((0 + microfone*15), 80); 
    translate(x, y);
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
class Tcompass {  
  Tcompass() {
    smooth();

  }
  void frame(angleCompass) {
    pushMatrix();
    translate(160, 240); 
    rotate(radians(angleCompass));
    
    //println(angleCompass);
    noFill();
    stroke(0);
    ellipse(0, 0, 250, 250);
    fill(0);
    ellipse(-125, 0, 15, 15);
    popMatrix();
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
  
         angleSpeedTouch =  random(0.02, 0.14);
         angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
         WeightSegmentTouch =  random(4.0, 10.0);
         //println("touch_on"); 
         
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

void shakeEvent()
{
  println("shaked");
}




