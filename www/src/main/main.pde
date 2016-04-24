/* @pjs 
transparent="true"; 
crisp="false";
font="data/MicroN55.ttf, data/hexagonica.ttf"; 
preload="data/how.png"; */
PFont fontTitle, fontText;

float easing = 0.20;
float spring = 0.02;
float gravity = 10.0;
float gravityX = 0.0;
float gravityY = 0.0;
float touch1X = 0.0;
float touch1Y = 0.0;
float touch2X = 0.0;
float touch2Y = 0.0;
float bx = 0.0;
float by = 0.0;
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
float endEscala;
float speedEscala = 10;
float trixScale = 8.0;

float microfone = 0;
float mic_perc = 50; // 0 a 100
String micText;

//float dim = 40;
var ctx;

PGraphics pimg;
int dim = 1300;

Control control;

Tbody body;
TrixelMatrix trixelmatrix;

int scW = screen.width;
int scH = screen.height;
int wCount, hCount;
float x = width/2; 
float y = height/2;
float targetX, targetY;
float spinX, spinY;




float angleSpeedTouch = 0.0f;
float angleRadiusTouch = 0.0f;
float WeightSegmentTouch = 0.0f;
int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float rotationT = 0.0;
float radius = 0.00;

float [] rotation = new float[numOfArms];
float [] angleRadius = new float[numOfArms];
float [] angleSegment= new float[numOfArms];
float [] angleSpeed = new float[numOfArms];
float [] angle = new float[numOfArms];
float [] WeightSegment = new float[numOfArms];
float [] segLength = new float[numOfArms];



boolean cameraShow = false;
boolean isGame = false;
boolean dialogLoop = true;

PImage howImg, logoImg;

float initColorAlpha = 0.0;
float endColorAlpha = 0.0;
float initPosY = 0.0;
int initColor = 255;
int alphaBG = 0.0;
float tweenBG = 0.0;
float tween = 0.0;
int load = 0;
float dialogTimer = 0;

float hurtRange = 0.0;
int hurtTimer = 0;
int hurtValue = 128;
int hurtLife = 20;

float gx,gy;
float mx, my; //mouse or object position middle;
float trixelX, trixelY;
float angleCompass;
float atan;

// Interface
ButtonInfo btInfo;
ButtonStart btStart;
ButtonAgain btAgain;
ButtonHow btHow;
ButtonClear btClear;
ButtonShare btShare;
ButtonLeaderBoard btLeader;
ButtonClose btClose;
MenuSlider slider;
ScoreInfo scoreInfo;
Logo logo;
TrixelEffect tEff;
Dialog dialog;

TrixParticle particleMagnetic;
ArrayList particles;

float pInfo = height;


// Transitions

String gameState, gameEnemy, gameTransions, gameSound, gameDialog;

void setup() {  
  stateSetup();   
}

void draw() {
  switch( gameState ) {      
    
    case "Start":
      stateStart();
    break;
    
    case "Over":
      stateOver();
    break;
    
    case "NoTouch":
      stateNoTouch();
    break;
    
    
    case "InfoShow":
      stateInfoShow();
    break;
    
    case "How":
      stateHow();
    break;
        
    case "LoadGame":
      stateLoadGame();
    break;    
      
    case "GameStart":
      stateGameStart();
    break;
         
    case "GameLevel":
      stateGameLevel();
    break;    
        
    
    case "Share":
     stateShare();  
    break; 
    
    case "Load":
     stateLoad();  
    break; 
            
    
  } //end gameState
    
  switch( gameEnemy ) {
    case "Null":
    
    break;
    
    case "Magnetic":
      particleMagnetic.draw(spinX,spinY);
    break;
  } 
  
  
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
      tEff.draw2(255-tween, 255);
      //noStroke();
      //fill(255, 255-tween);      
      //rect(0,0,width,height);   
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
      fill(0, 255-tween); 
      rect(0,0,width,height);   
      popMatrix();
    break;
    
    case "Yellowout":
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

      soundStart.stop();
      soundStart.play();
      //soundStart.loop(true);
      gameSound = "Null";
    break;
    
    case "Start":
      //soundStartUP.play();
      gameSound = "Null";
    break;

    case "Game": 
      soundStart.volume(0);
      soundLoopBG.stop();
      soundLoopBG.play();
      soundLoopBG.loop(true);
      gameSound = "Null";
    break;
    
  }
  
  switch( gameDialog ) {      
    case "Null":
      //
    break;
    
    case "Level":
      dialogLoop = true;
      dialog.draw("level",level, "", false);
    break;
    
    case "Score":
      dialogLoop = true;
      dialog.draw("score","+1", "", false);
    break;
        
    case "Start":
      dialogLoop = true;
      dialog.draw("","start", "", false);
    break;
    
    case "Find":
      if(dialogLoop) {
        dialog.draw("FIND","energy", "", true);
      }
    break;
        
  }

  
  
}
