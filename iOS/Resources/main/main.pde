/* @pjs transparent="true"; font="data/MicroN55.ttf, data/hexagonica.ttf"; preload="data/logo.png"; */

PFont fontTitle, fontText;

float easing = 0.20;
float spring = 0.02;
float gravity = 10.0;
float gravityX = 0.0;
float gravityY = 0.0;
float bx;
float by;
int bs = 120;
boolean bover = false;
boolean locked = false;
boolean effect = false;
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

Control control;
IPhone iphone;



PSound soundBG1, soundBG2, soundLoopBG, soundTransIN, soundTransOUT, soundStartUP, soundGlitch, soundEnemy, soundClick, soundScore, soundMagnetic, soundTouchTimer;
Tbody body;
TrixelMatrix trixelmatrix;

int scW, scH;
int wCount, hCount;

int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float radius = 0.00;

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
int alphaBG = 0.0;
float tweenBG = 0.0;
float tween = 0.0;
float dialogTimer = 0;

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
Logo logo;
TrixelEffect tEff;
Dialog dialog;

float pInfo = height;


// Transitions
IntroGame introgame;

String gameState = "Start";
String gameTransions = "Null";
String gameSound = "Intro";
String gameDialog = "Null";

void setup() {
        //size(320, 480);
        scW = screen.width;
        scH = screen.height;
        
        size(scW, scH, JAVA2D);
        
        if(scW>320 && scH>480) {
          wCount = 4; //ipad
          hCount = 2; 
          rad = 430;
          iScale = 2.4;
        } else {
          wCount = 4; //iphone
          hCount = 2;
          rad = 215;
          iScale = 1.4;
        }
        
        pebug("wCount: " + wCount + ", hCount: " + hCount);
        
        
        
        //rectMode(CENTER_RADIUS);
        rectMode(CORNER);
        imageMode(CENTER);
        textAlign(CENTER);
        ctx = externals.context;   
        frameRate(30);
        //smooth();
        
        
        initPosY = height + 100;
        
        infoImg = loadImage("infos.jpg");
        //logoImg = loadImage("logo.png");
        fontTitle = loadFont("data/hexagonica.ttf");        
        fontText = loadFont("data/MicroN55.ttf");
        

        btInfo = new ButtonInfo();
        btStart = new ButtonStart();
        btAgain = new ButtonAgain();
        btCamera = new ButtonCamera();
        btClose = new ButtonClose();
        slider = new MenuSlider();
        scoreInfo = new ScoreInfo();
        logo = new Logo();
        tEff = new TrixelEffect();
        dialog = new Dialog();

        trixelmatrix = new TrixelMatrix();
        //trixBAD = new TrixParticle("bad");
        //trixGOOD = new TrixParticle("good");
        
        introgame = new IntroGame();
        

        spinclesState();
      

        bx = width/2;
        by = height/2;
        iAngle = 0;

        
        control = new Control();
        iphone = new IPhone();
        
        soundMagnetic   = iphone.loadSound("energy.wav");
        soundScore      = iphone.loadSound("score.wav");
        soundClick      = iphone.loadSound("click.wav");
        soundGlitch     = iphone.loadSound("gltch.wav");
        soundEnemy      = iphone.loadSound("enemy.wav");
        soundTouchTimer = iphone.loadSound("glitch.wav");
        soundStartUP    = iphone.loadSound("startup.wav");
        soundTransIN    = iphone.loadSound("transIn.wav");
        soundTransOUT   = iphone.loadSound("transOut.wav");
        soundLoopBG     = iphone.loadSound("loop7.wav");
        soundBG1        = iphone.loadSound("loop0.wav");
        
        background(0);
        iphone.squareCamera();
        
        //setupThree();
        //video = loadImage("cam.png");
        
        pebug("4 - Start sequence: main.pde setup()");
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
      effect = false;
      tween = 0.0;
    break;
    
    case "Level":
      tween = tween +(initColor-tween)/10;
      if(tween>(initColor-1)) {
        gameTransions = "Null";
      }
      pushMatrix();
      rotate(0);
      translate(0,0);
      scale(1.0);
      tEff.draw2(255-tween, 255); 
      popMatrix();
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
      noStroke();
      fill(255, 255-tween);      
      rect(0,0,width,height);   
      popMatrix();
    break;
    
   case "Static":
      effect = true;
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
      tEff.draw2(255-tween, 0); 
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
      noStroke();
      fill(255,204,0, 255-tween); 
      rect(0,0,width,height);   
      popMatrix();
    break;
    
    
  } //end switch
  
  
  switch( gameSound ) {      
    case "Null":
      //
    break;
    case "Intro":
      soundBG1.play();
      soundBG1.loop();
      gameSound = "Null";
    break;
    
    case "Start":
      soundStartUP.play();
      gameSound = "Null";
    break;

    case "Game": 
	  //soundStartUP.stop();
      soundBG1.stop();
      soundLoopBG.play();
      soundLoopBG.loop();
      gameSound = "Null";
    break;
    
  }
  
  switch( gameDialog ) {      
    case "Null":
      //
    break;
    
    case "Level":
      pushMatrix();
      rotate(0);
      translate(width/2,height/2);
      scale(1.0);
      dialog.draw("level",level, "");
      popMatrix();
    break;
    
    case "Score":
      pushMatrix();
      rotate(0);
      translate(width/2,height/2);
      scale(1.0);
      dialog.draw("score",score, "");
      popMatrix();
    break;
  }
  
  
}
