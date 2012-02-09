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

int microfone = 0;

//float dim = 40;
PImage bimg;

PGraphics pimg;
int dim = 1300;

Ball ball;
IPhone iphone;
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



void setup() 
{
        size(320, 480);
        frameRate(30);
        bimg = loadImage("bg.jpg");
        //drawGradient();
        
        //noFill();
        //noStroke();
        //smooth();
        //rectMode(CENTER_RADIUS);
  
        for(int i=0; i<numOfArms; i++) {
          rotation[i] = random(0, 360);
          angleRadius[i] = random(0.3, 1.9);
          angleSpeed[i] = random(0.009, 0.11);
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
	iphone.startMicMonitor();
	iphone.startAccelerometer();

}

void draw() 
{
        //background(#ffff00, 0.1);	
        //fill(#ffff00, 50);
        //rect(0,0,width,height);
        //background(bimg);
        
        image(bimg, 0, 0);
        //if (microfone < 0) {
        //  noTint();
        //else {
        //  tint(255, (255 - microfone*2));
        //}
        //image(pimg, 0, 0);
        
        
        gravityX = iphone.getAcceleration().x;
        gravityY = -iphone.getAcceleration().y;
        microfone = pow(iphone.getMicLevel(), 3) * 100;
        println(microfone);
        ball.move();
	ball.touch();
	//ball.display();        
        
        //Spincles

        for(int i=0; i<numOfArms; i++) {
          angle[i] = angle[i] + angleSpeed[i] + microfone/100;
        }
        
        //targetX = mouseX;
        targetX = ball.x;
        float dx = targetX - x;
        float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
        airX += easing;
        x += dx * easing + nX*(microfone + 5.2);
        
        //targetY = mouseY;
        targetY = ball.y;
        float dy = targetY - y;
        float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
        airY += easing;  
        y += dy * easing + nY*(microfone + 5.2);
        
        body = new Tbody(x, y, noise(pi/500)*((x*y)/8000) + radians(iAngle), iScale);
        //+ noise(pi/10)*2)
        
        pi++;
}
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
  locked = false;
}
