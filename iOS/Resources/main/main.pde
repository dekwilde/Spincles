/* @pjs transparent="true"; font="data/MicroN55.ttf, data/hexagonica.ttf"; preload="data/logo.png"; */

PFont fontTitle, fontText;

float spring = 0.02;
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
float blowMic = 0.0;

//float dim = 40;
var ctx;

PGraphics pimg;
int dim = 1300;

Ball ball;
IPhone iphone;


boolean playSoundBG1 = false;
boolean playSoundBG2 = false;
PSound soundBG1, soundBG2, soundLoopBG, soundTransIN, soundTransOUT, soundStartUP, soundGlitch, soundClick, soundMagnetic;
Tbody body;
TCompass compass;

int scW, scH;
int wCount, hCount;

int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float radius = 0.00;
float easing = 0.20;
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
int initColor = 255;
float alphaBG = 0.0;
float tweenBG = 0.0;
float tween = 0.0;

float hurtRange = 0.0;
int hurtTimer = 0;

// Interface
ButtonInfo btInfo;
ButtonStart btStart;
ButtonAgain btAgain;
ButtonCamera btCamera;
ButtonClose btClose;
MenuSlider slider;
ScoreInfo scoreInfo;
float pInfo = height;


// Transitions
IntroGame introgame;

var gameState = "Start";
var gameTransions = "Null";
var gameSound = "Intro";

void setup() {
        //size(320, 480);
        scW = screen.width;
        scH = screen.height;
        
        size(scW, scH);
        
        if(scW>320 && scH>480) {
          wCount = 9;
          hCount = 7;
        } else {
          wCount = 4;
          hCount = 3;
        }
        
        println("wCount: " + wCount + ", hCount: " + hCount);
        
        
        
        //rectMode(CENTER_RADIUS);
        rectMode(CORNER);
        imageMode(CENTER);
        textAlign(CENTER);
        ctx = externals.context;   
        frameRate(30);
        //smooth();
        
        
        initPosY = height + 100;
        
        infoImg = loadImage("infos.jpg");
        logoImg = loadImage("logo.png");
        fontTitle = loadFont("data/hexagonica.ttf");        
        fontText = loadFont("data/MicroN55.ttf");
        

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
        
        // Transitions
        introgame = new IntroGame();
        

        
  
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
        iScale = 1.1;
        
        ball = new Ball(bx, by, bs);
        iphone = new IPhone();
        
        soundMagnetic   = iphone.loadSound("magnetic.wav");
        soundClick      = iphone.loadSound("click.wav");
        soundGlitch     = iphone.loadSound("world_glitch.wav");
        soundStartUP    = iphone.loadSound("module_startup.wav");
        soundTransIN    = iphone.loadSound("transIn.wav");
        soundTransOUT   = iphone.loadSound("transOut.wav");
        soundLoopBG     = iphone.loadSound("loop1.wav");
        soundBG1        = iphone.loadSound("bg1.wav");
        soundBG2        = iphone.loadSound("bg2.wav");
        
        background(0);
        iphone.squareCamera();
        
        //setupThree();
        //video = loadImage("cam.png");
        
        println("4 - Start sequence: main.pde setup()");
}

void draw() {
  switch( gameState ) {      
    case "Start":
      stateStart();
    break;
    
    case "Over":
      stateOver();
    break;
    
    
    case "InfoShow":
      stateInfoShow();
    break;
    
    case "Intro":
      introgame.draw();
    break;
        
    case "Game":
      stateGame();  
    break;  
  } //end gameState
  
  
  switch( gameTransions ) {      
    case "Null":
      tween = 0.0;
    break;
    
    case "Flash":
      tween = tween +(initColor-tween)/10;
      if(tween>(initColor-1)) {
        gameTransions = "Null";
      }
      pushMatrix();
      rotate(0);
      translate(0,0);
      scale(1.0);
      fill(255, 255-tween);
      noStroke();        
      rect(0,0,width,height);   
      popMatrix();
    break;
    
   case "Static":
      tween = tween +(initColor-tween)/5;
      if(tween>(initColor-1)) {
        gameTransions = "Null";
      }
      pushMatrix();
      rotate(0);
      translate(0,0);
      scale(1.0);
      //background(0,0);
      ctx.rect(0,0,width,height);
      fill(255, round(random(1))*255);
      noStroke();        
      rect(0,0,width,height);   
      popMatrix();
    break;
    
    
    case "Blackout":
      tween = tween +(initColor-tween)/10;
      if(tween>(initColor-1)) {
        gameTransions = "Null";
      }
      pushMatrix();
      rotate(0);
      translate(0,0);
      scale(1.0);
      fill(255,204,0, 255-tween);
      noStroke();        
      rect(0,0,width,height);   
      popMatrix();
    break;
    
    
  } //end switch
  
  
  switch( gameSound ) {      
    case "Null":
      //
    break;
    case "Intro":
      int m = round(millis()/1000);
      
      if(!playSoundBG1) {
        playSoundBG1 = true;
        soundBG1.play();
        soundBG1.loop();
        println("soundBG1");
      }
      if(m == 4) {
        if(!playSoundBG2) {
          playSoundBG2 = true;
          soundBG2.play();
          soundBG2.loop();
          gameSound = "Null";
          println("soundBG2");
        }  
      }
    break;
    
    case "Game":
      soundBG1.stop();
      soundBG2.stop();
      soundLoopBG.play();
      soundLoopBG.loop();
      gameSound = "Null";
    break;
    
  }
  
}
