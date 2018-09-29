class Control {

  float gravity = sqrt(width*width+height*height)/10;
  float mass = 2.0;
  int numSprings = 0;
  boolean displayEnable = false;
  Spring2D springs[] = new Spring2D[maxSprings];
  float x =0 , y = 0;
  String mode = "ball";
  Trix trix = new Trix(rad/5);
  
  Control(int num) {
    numSprings = num;
    gx = 0;
    gy = 0;
    for (int i=0; i<numSprings; i++) {
      if(infectArm.length>2){
        springs[i] = new Spring2D(collisionParticleX, collisionParticleY, mass, gravity);
      } else {
        springs[i] = new Spring2D(width/2, height/2, mass, gravity);
      }
    }
  }
  
  void draw() {
    if(infectArm.length>2) {
      displayEnable = true;
      
      pushMatrix();
      translate(collisionParticleX, collisionParticleY);
      rotate(radians(random(360)));
      fill(0);
      triangle(trix.x1, trix.y1, trix.x2, trix.y2, trix.x3, trix.y3);
      popMatrix();
        
    } else {
      displayEnable = false;
    }
    
    gx = gravityX;
    gy = gravityY;
    for (int i=0; i<numSprings; i++) {
      if (i==0) {
        if(infectArm.length>2){
          x = collisionParticleX;
          y = collisionParticleY;
        } else {
          x = width/2;
          y = height/2;
        }
      } else {
        x = springs[i-1].x;
        y = springs[i-1].y;
      }
      
      springs[i].move(x, y);
      springs[i].touch();
      //pebug display
      if(displayEnable) {
        springs[i].display(x, y);        
      }

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
    if (touch1X > x-radius*2 && touch1X < x+radius*2 && 
    touch1Y > y-radius*2 && touch1Y < y+radius*2) {
        bx = x;
        by = y;
        bover = true;
        if(locked) {
          //clawTouchStart();
        } 
     } else {      
       locked = false; 
       bover = false;
        //clawTouchStop();
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
    stroke(0);
    strokeWeight(2);
    fill(0);
    ellipse(x, y, radius, radius);
    line(x, y, nx, ny);
  }
}
