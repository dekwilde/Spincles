float gx,gy;
class Control {

  float gravity = sqrt(width*width+height*height)/10;
  float mass = 2.0;
  int numSprings = 1;
  Spring2D springs[] = new Spring2D[numSprings];
  float x, y;
  String mode = "chain";
  
  Control() {
    gx = 0;
    gy = 0;
    for (int i=0; i<numSprings; i++) {
      springs[i] = new Spring2D(0.0, width/2, mass, gravity);
    }
  }
  
  void draw() 
  {
    gx = gravityX;
    gy = gravityY;
    for (int i=0; i<numSprings; i++) {
      if (i==0) {
        x = width/2;
        y = height/2;
      } else {
        x = springs[i-1].x;
        y = springs[i-1].y;
      }
      
      springs[i].move(x, y);
      springs[i].touch();
      //springs[i].display(x, y);
      x = springs[i].x;
      y = springs[i].y;
    }
  }
}

class Spring2D {
  float vx, vy; // The x- and y-axis velocities
  float x, y; // The x- and y-coordinates
  float gravity;
  float mass;
  float radius = 20;
  float stiffness = 0.2;
  float damping = 0.7;
  
  
  
  Spring2D(float xpos, float ypos, float m, float g) {
    x = xpos;
    y = ypos;
    vx = 0;
    vy = 0;
    mass = m;
    gravity = g;
  }
  
  void touch() {
    if (touch1X > x-radius && touch1X < x+radius && 
    touch1Y > y-radius && touch1Y < y+radius) {
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
  }
  
  void move(float targetX, float targetY) {
    if (!locked) {
      bx = x;
      by = y;
      
      if(control.mode == "chain") {
        float forceX = (targetX - x) * stiffness;
        forceX += gravity*gx;
        float ax = forceX / mass;
        vx = damping * (vx + ax);
        x += vx;
        
        float forceY = (targetY - y) * stiffness;
        forceY += gravity*gy;
        float ay = forceY / mass;
        vy = damping * (vy + ay);
        y += vy;
      }
      if(control.mode == "ball") {
        vx += gravityX;
        vy += gravityY;
        x += vx*gravity;
        y += vy*gravity;
        vx *= -spring;
        vy *= -spring;   
      }
      
      
      
      if (x + radius/2 > width) {
        x = width - radius/2;
      }
      else if (x - radius/2 < 0) {
        x = radius/2;
      }
      if (y + radius/2 > height) {
        y = height - radius/2;
      } 
      else if (y - radius/2 < 0) {
        y = radius/2;
      }
      
    } else {
      x = bx;
      y = by;
    }
    
  }
  
  void display(float nx, float ny) {
    stroke(255,0,0);
    strokeWeight(1);
    ellipse(x, y, radius*2, radius*2);
    //line(x, y, nx, ny);
  }
}
