int rad; //triangle radius 215 is default
float mx, my; //mouse or object position middle;
float trixelX, trixelY;
float angleCompass;
float atan;

//ENGINE GAME
int rangeTrixType = 10;
int changeTimeRange = 10;
int changeTimeRand = 10;
int changeTimeRandRange = 200;
int activeEnemyRange = 0;


TrixParticle trixBAD;
TrixParticle trixGOOD;
ArrayList particles;


class TrixelMatrix {  
  Trixel[] trixel;
  int n = 0;
  int count;
  int tv = 4;
  float r, d;
  
  TrixelMatrix() {
    count = wCount*hCount*tv;
    trixel = new Trixel[count];
    for(int i=0; i<hCount; i++) {
      for(int j=0; j<wCount; j++) {
        for(int k=0; k<tv; k++) {
          trixel[n++] = new Trixel(j, i, k);  
        }
      }
    }
  }
  void draw() {

    angleCompass = compassDEGREE + iAngle;
    trixelX = spinX;
    trixelY = spinY;
    
    atan = atan2(trixelY-height/2, trixelX-width/2);   
    r = radians(angleCompass) - atan;
    d = dist(width/2, height/2, trixelX, trixelY); // distance mouse to center, mouse middle
    mx = d*cos(-r)+width/2;
    my = d*sin(-r)+height/2;
        
    pushMatrix();
    translate(width/2, height/2);
    rotate(atan);
    rotate(r);
    translate(-width/2,-height/2); //new line before implementation
    
    for (int i = 0; i < count; i++) {
      trixel[i].draw(mx - width/2,my - height/2);
    }
    
    //pebug display
    /*
    stroke(0,0,255);
    line(0,height/2,width,height/2);
    line(width/2,0,width/2,height);

    fill(0,255,0);
    ellipse(mx,my, 60, 60); // target position
    stroke(0,255,0);
    line(width/2, height/2, 0, 150); //point compass
    */
    popMatrix();
  }  
}



class Trixel {
  Trix trix;
  float x1, y1, x2, y2, x3, y3;
  float s, h, radius, angle;
  float x, y;
  int v;

  int range;
  int changeTrix = 0;
  int changeTime;
  
  float collisionX, collisionY;

  Trixel(float tx, float ty, int inv) {
    
      trix = new Trix(rad);
      s = rad; 
      h = trix.h; 
      radius = trix.r;
      angle = trix.a;
      
      x1 = trix.x1;
      y1 = trix.y1;
        
      x2 = trix.x2;
      y2 = trix.y2;
      
      x3 = trix.x3;
      y3 = trix.y3;
      
    
      v = inv;
      if(v == 0) {
        x = s/2     + tx*s;
        y = radius  + ty*h*2; 
      }
      if(v == 1) {
        x = s/2     + tx*s;
        y = radius  + ty*h*2 + radius;  
      }
      if(v == 2) {
        x = tx*s;
        y = h+radius + ty*h*2; 
      }
      if(v == 3) {
        x = tx*s;
        y = h/3 + ty*h*2; 
      }
      x = x  + width/2    - wCount*s/2        + s/2;
      y = y  + height/2  - (hCount+1)*radius  - h/3;
      
      

      
            
      changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
      range = int(random(rangeTrixType));

  }
    
  void draw(float spX, float spY) {
    
    x -= spX/100;
    y -= spY/100;
    
    if(x>width+s) {
      x = x - s*wCount;
    }
    
    if(x<-s) {
      x = x + s*wCount;
    }
    
    if(y>height+h) {
      y = y - h*(hCount+2);
    }
    
    if(y<-h) {
      y = y + h*(hCount+2);
    }
    
    collisionX = mx - x;
    collisionY = my - y;
    
    
    changeTrix = changeTrix + 1;
    if(changeTrix>changeTime) { //warnning
      fill(255,int(random(255)));
      if(changeTrix>changeTime+20) { //actived
        resetTrix();
      }
    } else {
      noFill();
    }   

    pushMatrix();
    translate(x, y); 
    if(v == 1 || v == 3) {
      rotate(radians(180));
    }  
    
    if(range == 0) { //enemy
      fill(0);   
    }
    if(range == 1) { //life
      stroke(255);
      strokeWeight(1);
      fill(255,int(random(255)));
      triangle(0,0,x1,y1,x2,y2);
      fill(255,int(random(255)));
      triangle(0,0,x2,y2,x3,y3);
      fill(255,int(random(255)));
      triangle(0,0,x3,y3,x1,y1);
    }
    
    
    if(checkCollision(collisionX,collisionY)){
      
      if(range > 1) {
        fill(255,204,0,int(random(255))); 
       //pebug display
       //fill(0,0,200); 
      }
      
      if(range == 0 && blowMic<200) { //enemy        
        energy = energy - 4;
        soundEnemy.play();
        gameTransions = "Static";
        hurtRange = 300;
        //hurt();
        pebug("energy " + energy);
        collisionTrix();
        trixBAD.num = 0;
      }
      if(range == 1) { //score
        energy = energy + 2;
        score = score + 1;
        saveScore();
        pebug("energy " + energy);
        soundMagnetic.play();
        soundScore.play();
        gameTransions = "Blackout";
        gameDialog = "Score";
        collisionTrix();
        trixGOOD.num = 0;
        
      }
    } else {
      hurtRange -= hurtRange*0.01;
    }
         
        
    // draw triangle
    if(effect) {
      stroke(0);
    } else {
      stroke(255);
    }
    
    strokeWeight(1); 
    triangle(x1, y1, x2, y2, x3, y3);
    
    
    if(range == 0) { //enemy
      for(int i=0;i<10;i++) {
        stroke(255);
        point(random(-rad/5,rad/5), random(-rad/5,rad/5));
      }
    }
    
    popMatrix();
  }



  

  boolean checkCollision(float cx, float cy) {
    float tArea,t1Area,t2Area,t3Area,totalArea;
    tArea  = triangleArea(x1,y1,x3,y3,x2,y2);
    t1Area = triangleArea(cx,cy,x2,y2,x3,y3);
    t2Area = triangleArea(cx,cy,x3,y3,x1,y1);
    t3Area = triangleArea(cx,cy,x2,y2,x1,y1);    
    totalArea = t1Area+t2Area+t3Area;
    return (totalArea == tArea);
  } 
  
  float triangleArea(float p1, float p2, float p3, float p4, float p5, float p6) {
    float a,b,c,d;
    a = p1 - p5;
    b = p2 - p6;
    c = p3 - p5;
    d = p4 - p6;
    return (0.5* abs((a*d)-(b*c)));
  }
  
  
  void resetTrix() {
    range = int(random(rangeTrixType));
    changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
    changeTrix = 0;
  }
  
  void collisionTrix() {
    range = rangeTrixType; 
    changeTime = 0;
    changeTrix = 0;
  }
  
}





class TrixParticle {
  int num;
  int amount = 5;
  String tp;
  
  TrixParticle(String type) {
    tp = type;
    particles = new ArrayList();
    num = 0;
  }
  
  void draw(){
    num += 1;
    if(num<amount) {
      particles.add(new Particle(tp));
    }
    for(int i=0; i < particles.size(); i++){
      Particle p = (Particle) particles.get(i);
      p.draw();
      //p.gravity();
      p.display();
      p.conect();
      p.dead();
      if(p.death){
        particles.remove(i);
      }
    }
  }
  
  
}


class Particle{
  float x;
  float y;
  float xspeed = 0;
  float yspeed = 0;
  float myDiameter= 2;
  float distance = 90;
  float delay = random(0.001, 0.01);
  float elastic = 0.98;
  int life =0, lifeTime = 50+int(random(200));
  boolean death = false;
  String tp;

  
  Particle(String type){
    tp = type;
    if(tp == "good") {
      x= int(random(width));
      y= int(random(height));
    }
    if(tp == "bad") {
      x= spinX;
      y= spinY;
      xspeed= random(-2, 2);
      yspeed= random(-2, 2);  
    }
  }
    
  void draw(){
    strokeWeight(1);
    if(tp == "good") {
      float dx = spinX - x;
      float dy = spinY - y;
      xspeed = dx*delay+xspeed*elastic;
      yspeed = dy*delay+yspeed*elastic;
      x = x+xspeed;
      y = y+yspeed;
    }
    if(tp == "bad") {
      x = x+xspeed;
      y = y+yspeed; 
    }
    
  }
    
  void display(){
    noStroke();
    fill(0);
    ellipse(x, y, 2, 2);
  }
  
  void gravity(){
    yspeed += 0.01;
  }
  
  void dead() {
    life += 1;
    if(life>lifeTime) {
      death = true;  
    } else {
      death = false;
    } 
  }
  
  void conect() {
    for (int i = 0; i <particles.size() ; i++) {
      
      Particle other = (Particle) particles.get(i);
 
      if (this != other) {
        if (dist(x, y, other.x, other.y)<distance) {
          stroke(0,0,0,70);
          line(x, y, other.x, other.y);
          noStroke();
          fill(0, 0, 0, random(100));
          ellipse(x,y,myDiameter*5,myDiameter*5);
        }
      }
    } //end for
  }
     
}
