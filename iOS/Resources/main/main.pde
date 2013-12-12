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
        iphone.openCamera();        

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
        
        camImg = loadImage(iphone.getCamera());
        image(camImg,0,0); 
        
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




