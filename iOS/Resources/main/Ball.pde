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
        x += vx*gravity;
        y += vy*gravity;
        if (x + diameter/2 > width) {
          x = width - diameter/2;
        }
        else if (x - diameter/2 < 0) {
          x = diameter/2;
        }
        if (y + diameter/2 > height) {
          y = height - diameter/2;
        } 
        else if (y - diameter/2 < 0) {
          y = diameter/2;
        }
        vx *= -spring;
        vy *= -spring; 
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

          if(locked) { 
              clawTouchLoop();
          } 
     } else {      
          bover = false;
          clawTouchStop();
    }
    
    //pebug("touch_off"); 
  }
  
  void display() {
    pushMatrix();
    stroke(0,255,0);
    noFill();
    ellipse(x, y, diameter, diameter);
    popMatrix();
  }
  
  void draw() {
    ball.move();
    ball.touch();
    ball.display();
  }
  
}
