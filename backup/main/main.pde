float spring = 0.5;
float gravityX = 0;
float gravityY = 0;

float bx;
float by;
int bs = 60;
boolean bover = false;
boolean locked = false;
float bdifx = 0.0; 
float bdify = 0.0;

float angle;
float startAngle;
float percent;
float startPercent;

float microfone = 0;



Ball ball;

IPhone iphone;

void setup() 
{
        size(320, 480);
      
        noStroke();
        smooth();
        rectMode(CENTER_RADIUS);
        bx = width/2;
        by = height/2;
        angle = 0;
        percent = 1.0;
        
	ball = new Ball(bx, by, bs);
	iphone = new IPhone();
	iphone.startMicMonitor();
	iphone.startAccelerometer();

}

void draw() 
{
	   background(0);	
	   gravityX = iphone.getAcceleration().x;
	   gravityY = -iphone.getAcceleration().y;
       microfone = iphone.getMicLevel();
       println(microfone);

        

        
        ball.move();
	ball.touch();
	ball.display();
        rotate(radians(angle));
        scale(percent);
}

void gestureStarted() {
	startAngle = angle;
	startPercent = percent;
}

void gestureChanged() {
	angle = startAngle + gestureRotation;
	percent = startPercent * gestureScale;
	if (angle > 360) {
		angle = angle - 360;
	}
	if (angle < 0) {
		angle = 360 + angle;
	}
}

void gestureStopped() {
	startAngle = angle;
	startPercent = percent;
}

void touch1Started() {
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
    bover = true;  
  }
  
  if(bover) { 
    locked = true; 
    fill(255, 0, 0);
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
              stroke(255,0,0); 
              fill(153);
          } 
     } else {
          stroke(153);
          fill(153);
          bover = false;
    }
  }
  
  void display() {
    ellipse(x, y, diameter+diameter*microfone, diameter+diameter*microfone);
  }
}
