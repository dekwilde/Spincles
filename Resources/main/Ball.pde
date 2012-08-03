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
              //stroke(255); 
              //fill(0);
          } 
     } else {
          //stroke(0);
          //fill(255);          
          bover = false;
    }
    
    angleSpeedTouch = angleSpeedTouch / 1.02;
    angleRadiusTouch = angleRadiusTouch / 1.008;
    WeightSegmentTouch = WeightSegmentTouch / 1.08;
    println("touch_off");   
  }
  
  void display() {
    ellipse(x, y, diameter+diameter*microfone, diameter+diameter*microfone);
  }
}
