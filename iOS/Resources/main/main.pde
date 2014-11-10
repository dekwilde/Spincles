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

int scW, scH;
int wCount, hCount;

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
        initPosY = initPosY + (0 - initPosY)/10;
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
    
    case "Tutorial":
    
    
    break; // End of Case Statement
    
    case "Game":
        // init vars DONT MOVE    
        gravityX = iphone.getAcceleration().x;
        gravityY = -iphone.getAcceleration().y;
        
        println("x: " + gravityX + " " + "y: " + gravityY);
        println("Mic: " + iphone.getMicLevel());
        
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
        
        spinclesDraw();
        
        
        
        
    break; // End of Case Statement   

  } //end switch
}











