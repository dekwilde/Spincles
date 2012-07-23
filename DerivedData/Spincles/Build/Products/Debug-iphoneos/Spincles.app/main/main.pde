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
PImage bimg;

PGraphics pimg;
int dim = 1300;

Ball ball;
IPhone iphone;
PSound sound1, sound2, sound3, sound4;
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
        //bimg = loadImage("bg.jpg");
        
        infoImg= loadImage("infos.jpg");
  
        btInfo = new ButtonInfo();
        btClose = new ButtonClose();
        slider = new MenuSlider();
        
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
        
        sound2 = iphone.loadSound("touch.wav");
        sound2.play();
        sound2.loop();


	iphone.startMicMonitor();
	iphone.startAccelerometer();
}

void draw() 
{
      // init vars DONT MOVE    
      gravityX = iphone.getAcceleration().x;
      gravityY = -iphone.getAcceleration().y;
      microfone = pow(iphone.getMicLevel(), 1) * mic_perc;
      
      sound1.setVolume(microfone/2);
    
      
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
        
        println(microfone);
        	
        fill(colorR, colorG, colorB, 255 - delay_mic);
        noStroke();
        
        
        rect(0,0,width,height);
        //background(bimg);
        
        //image(bimg, 0, 0);
        //if (microfone < 0) {
        //  noTint();
        //else {
        //  tint(255, (255 - microfone*2));
        //}
        //image(pimg, 0, 0);
        
  
        ball.move();
	ball.touch();
	//ball.display();        
        
        //Spincles

        for(int i=0; i<numOfArms; i++) {
          angle[i] = angle[i] + angleSpeed[i] + microfone/400;
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
        
        float rotationT = noise(pi/500)*((dx*dy*easing)/450) + radians(iAngle) + microfone/40;
        
        body = new Tbody(x, y, rotationT, iScale);
        //+ noise(pi/10)*2)
        
        pi++;
    }
}
/*
void drawGradient() {
  pimg = createGraphics(320, 480, P2D);
  int radius = dim/2 - 2;
  float r1 = 255;
  float g1 = 204;
  float b1 = 0;
  float dr = (255 - r1) / radius;
  float dg = (255 - g1) / radius;
  float db = (0   - b1) / radius;
  
  pimg.beginDraw(); 
  for (int r = radius; r > 0; --r) {
    pimg.fill(r1, g1, b1, 180);
    pimg.noStroke();
    pimg.ellipse(width/2, height/2, r, r);
    r1 += dr;
    g1 += dg;
    b1 += db;
  }
  pimg.endDraw();
}
*/

void buttonLink(int pX, int pY, int Width, int Height, char Str) {
      if (touch1X > pX-Width && touch1X < pX+Width && touch1Y > pY-Height && touch1Y < pY+Height) {
        println("link out " + Str);
        link(Str, "_new");
        // infoShow = false;
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
  sound2.setVolume(100);
  //GEsture Drag Spincles
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
    bover = true;  
  }
  
  if(bover) { 
    locked = true;
    //fill(255, 0, 0);
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
    sound2.setVolume(0);
  if (infoShow && pInfo<1) {
      buttonLink(90, 458, 60, 12, "http://spincles.dekwilde.com.br/support");
      buttonLink(230, 458, 60, 12, "mailto:spincles@dekwilde.com.br");
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
