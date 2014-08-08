/* @pjs transparent="true"; */


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

boolean cameraShow = false;
PImage infoImg;

ButtonInfo btInfo;
ButtonStart btStart;
ButtonAgain btAgain;
ButtonCamera btCamera;
ButtonClose btClose;
MenuSlider slider;
ScoreInfo scoreInfo;

float pInfo = 480;


var gameState = "Intro";

void setup() 
{
        //size(320, 480);
        size(screen.width, screen.height);
        //rectMode(CENTER_RADIUS);
        rectMode(CORNER); 
        ctx = externals.context;        
        frameRate(30);
        //smooth();
        
        infoImg= loadImage("infos.jpg");
  
        btInfo = new ButtonInfo();
        btStart = new ButtonStart();
        btAgain = new ButtonAgain();
        btCamera = new ButtonCamera();
        btClose = new ButtonClose();
        slider = new MenuSlider();
        scoreInfo = new ScoreInfo();

        compass = new Tcompass();
        
        PFont fontA = loadFont("SansSerif-10.vlw");
        textFont(fontA, 20);
        
  
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


        //setupThree();
        video = loadImage(iphone.getCamera());
        
        println("4 - Start sequence: main.pde setup()");
}

void draw() {
  playloopBG();
  switch( gameState ) {      

    case "Over":
      background(#FFCC00);
      fill(0);
      textAlign(CENTER);
      text("GAME", width/2, 30);
      text("OVER", width/2, 60); 
      
      btAgain.draw();
      
    break; // End of Case Statement

    case "Intro":
      background(#FFCC00);
      fill(0);
      textAlign(CENTER);
      text("Welcome to", width/2, 30); 
      text("Spincles", width/2, 60); 
      
      btStart.draw();
      
    break; // End of Case Statement
    
    case "InfoShow":
          fill(0, 0, 0, 20);
          rect(0,0,width,height);
          image(infoImg, width/2-320/2, pInfo+height/2-480/2);
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
        microfone = pow(iphone.getMicLevel(), 1) * mic_perc;                
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
        
        println("microfone " + microfone);
               
        if (cameraShow) {  
            Camera();
        } else { // end if cameraShow
          fill(colorR, colorG, colorB, 255 - delay_mic);
          noStroke();        
          rect(0,0,width,height);
        }
        
        //Three();
        
        
        ball.move();
        ball.touch();
        ball.display();
        
        
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

        //location();
        //pointCompass();
        //angleCompass = targetDEGREE - compassDEGREE;
        angleCompass = compassDEGREE;
        println("compass " + compassDEGREE);
        

        compass.draw();

        
        btInfo.draw();
        btCamera.draw();
        scoreInfo.draw();


        
        
        float rotationT = noise(pi/500)*((dx*dy*easing)/450) + radians(iAngle) + microfone/40;
        
        body = new Tbody(x, y, rotationT, iScale);
        //+ noise(pi/10)*2)
        
        pi++;
    break; // End of Case Statement   

  } //end switch
}
