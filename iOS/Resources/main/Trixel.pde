//LAYOUT and ANIMATION
int rad = 140; //triangle radius
float mx, my; //mouse or object position middle;
float twothird = 2.0/3.0; //triangle use
float trixelX, trixelY;
float angleCompass;
float delaySpeedCompass = 20;

//ENGINE GAME
int rangeTrixType = 10;
int changeTimeRange = 10;
int changeTimeRand = 10;
int changeTimeRandRange = 200;
int activeEnemyRange = 0;


TrixParticle trixBAD;
TrixParticle trixGOOD;
ArrayList particles;


class Tcompass {  
  TrixelMatrix trixelMtx;
  float pX = 0.0;
  float pY = 0.0;
  
  Tcompass() {
    trixelMtx = new TrixelMatrix();
  }
  void draw() {
    
    
    //location();
    //pointCompass();
    //angleCompass = targetDEGREE - compassDEGREE;
    
    if (compassDEGREE > 360) {
      compassDEGREE = compassDEGREE - 360;
    }
    if (compassDEGREE < 0) {
      compassDEGREE = 360 + compassDEGREE;
    }
    angleCompass = compassDEGREE + iAngle;
    
    
    
    //trixelX += (spinX - trixelX)*easing;
    //trixelY += (spinY - trixelY)*easing;
    
    trixelX = spinX;
    trixelY = spinY;
    
    //trixelX = targetX;
    //trixelY = targetY;
    

    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(trixelY-height/2, trixelX-width/2);
    rotate(a);
    trixelMtx.draw();
    popMatrix();
  }  
}







class TrixelMatrix {
  GridTrixel gridtrixel;
  float r = 0.0; //rotation var
  float dgr;
  float d; // distance mouse to center, mouse middle
  float speed = 1; //speed for rotation
  TrixelMatrix() {
    gridtrixel = new GridTrixel(); 
  }
  
  void draw() {
    //r = r + speed;

    
    
    dgr = radians(angleCompass);
    //r += (dgr - r)*easing;
    float a = atan2(trixelY-height/2, trixelX-width/2);
    r = dgr - a;
    
    
    //pebug("degrees " + angleCompass);
    //pebug("radians " + r);
    d = dist(width/2, height/2, trixelX, trixelY);
    mx = d*cos(-r);
    my = d*sin(-r);
  
    pushMatrix();
    rotate(r);
    gridtrixel.draw();
    //fill(0,255,0);
    //ellipse(mx,my, 30, 30); // target position
    popMatrix();
    //stroke(0,255,0);
    //line(0, 0, 0, 20); //point compass
  }
}






class GridTrixel {
  Trixel[] trixel;
  int n = 0;
  int count;
  int angleStart = 2;
  int angleEnd = 6;  
  GridTrixel() {
    count = wCount*hCount*(angleEnd-angleStart);
    trixel = new Trixel[count];
    for(int i=0; i < hCount; i++) {
      for(int j=0; j < wCount; j++) {
        for(int k=angleStart; k < angleEnd; k++) {
          trixel[n++] = new Trixel(j, i, rad, k);  
        }
      }
    }
    
  }
  
  void draw() {
    for (int i = 0; i < count; i++) {
      trixel[i].draw();
    }
  }
}







class Trixel {
  Triangle t;
  float x1, y1, x2, y2, x3, y3;
  float radius;
  int range;
  int changeTrix = 0;
  int changeTime;
  XY a,b,c;
  XY centroid;
  

  
  Trixel(float i, float j, float r, int inv) {
      
      changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
      radius = r;
      x1 = (i-(wCount-1)/2)*radius;      
      y1 = (j-(hCount-twothird)/2)*(radius + radius*twothird+radius*0.065625)+radius/2+radius*0.065625;
      
      float angle = (TWO_PI / 6) * inv;
      x2 = x1 + cos( angle ) * radius;
      y2 = y1 + sin( angle ) * radius;
      
      x3 = x1 + (cos(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
      y3 = y1 + (sin(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
      
      a = new XY(x1,y1);
      b = new XY(x2,y2);
      c = new XY(x3,y3);
      centroid = new XY(-1,-1);
      XY bc = new XY(b.x+(c.x-b.x)/2, b.y+(c.y-b.y)/2);
      centroid.set( int(a.x+(bc.x-a.x)*twothird) , int(a.y+(bc.y-a.y)*twothird) );
      t = new Triangle(x1,y1,x2,y2,x3,y3);
      //ENGINE
      
      range = int(random(rangeTrixType));

  }
    
  void draw() {

    changeTrix = changeTrix + 1;
    if(changeTrix>changeTime) { //warnning
      fill(255,int(random(255)));
      if(changeTrix>changeTime+20) { //actived
        resetTrix();
      }
    } else {
      noFill();
    }
    
    
    if(range == 0) { //enemy
      fill(255);  
    }
    if(range == 1) { //life
      troid();
    }
    

    
    
    if(checkCollision(mx,my,t)){
      
      if(range > 1) {
        fill(0,int(random(128)));  
      }
      
      if(range == 0 && blowMic<200) { //enemy        
        fill(int(random(255)),int(random(100)));
        energy = energy - 4;
        soundEnemy.play();
        gameTransions = "Static";
        hurtRange = 300;
        //hurt();
        pebug("energy " + energy);
        resetTrix();
        trixBAD.num = 0;
      }
      if(range == 1) { //score
        energy = energy + 2;
        score = score + 1;
        checkScore();
        pebug("energy " + energy);
        soundMagnetic.play();
        soundScore.play();
        gameTransions = "Blackout";
        resetTrix();
        trixGOOD.num = 0;
        
      }
    } else {
      hurtRange = hurtRange + (0-hurtRange)/100;
    }
        
    
    t.draw();
  }

  void resetTrix() {
    range = int(random(rangeTrixType));
    changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
    changeTrix = 0;
  }
  
  void troid() {
    stroke(0);
    fill(0);
    stroke(0); 
    ellipse(centroid.x, centroid.y, 10, 10);
    noFill();
  }
  

  boolean checkCollision(float x, float y, Triangle t) {
    float tArea,t1Area,t2Area,t3Area;
    tArea  = triangleArea(t.point1x, t.point1y, t.point3x, t.point3y, t.point2x, t.point2y);
    t1Area = triangleArea(x,y, t.point2x, t.point2y, t.point3x, t.point3y);
    t2Area = triangleArea(x,y, t.point3x, t.point3y, t.point1x, t.point1y);
    t3Area = triangleArea(x,y, t.point2x, t.point2y, t.point1x, t.point1y);    
    float totalArea = t1Area+t2Area+t3Area;
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
  
  
}



class Triangle {
  float point1x;
  float point1y;
  float point2x;
  float point2y;
  float point3x;
  float point3y;
  
  Triangle(float point1x,float point1y,float point2x,float point2y,float point3x,float point3y){
    this.point1x = point1x;
    this.point1y = point1y;
    this.point2x = point2x;
    this.point2y = point2y;
    this.point3x = point3x;
    this.point3y = point3y;        
  }
  
  void draw() {
    stroke(#ffffff);
    strokeWeight(1);
    triangle(point1x, point1y, point2x, point2y, point3x, point3y);
  }
}






class XY
{
    float x, y;
    
    XY (float xx, float yy)
    {
        x=xx; 
        y=yy;
    }
    
    boolean inside (int xx, int yy)
    { 
        return (xx>x-5 && xx<x+5 && yy>y-5 && yy<y+5); 
    }
    
    void set ( int _x, int _y )
    {
        x=_x; 
        y=_y;
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
