int rad; //triangle radius 215 is default
float mx, my; //mouse or object position middle;
float trixelX, trixelY;
float angleCompass;
float atan;

//ENGINE GAME
int rangeTrixType = 10;
float nX, nY;


//TrixParticle trixBAD;
//TrixParticle trixGOOD;
//ArrayList particles;


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
          trixel[n++] = new Trixel(j, i, k, n);  
        }
      }
    }
  }
  void draw() {

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
    
    nX = mx*(microfone/50 + 1) - width/2;
    nY = my*(microfone/50 + 1) - height/2;
    
    for (int i = 0; i < count; i++) {
      trixel[i].draw(nX,nY);
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
    
  void reset() {
    for (int i = 0; i < count; i++) {
      trixel[i].changeTrix = 0;
      trixel[i].changeTime = 0;
    } 
  }
}



class Trixel {
  Trix trix;
  float x1, y1, x2, y2, x3, y3;
  float s, h, radius, angle;
  float x, y;
  int v;
  int id;

  int range;
  int changeTrix = 0;
  int changeTime = 10000;
  
  float collisionX, collisionY;

  Trixel(float tx, float ty, int inv, int num) {
      trix = new Trix(rad);
      
      id = num;
      if(id == 2) {
        range = 1; 
      } else {
        range = rangeTrixType;
      }
      
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
      
  }
    
  void draw(float spX, float spY) {
    
    x -= spX/20;
    y -= spY/20;
    
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
      range = rangeTrixType;
      fill(0,int(random(255)));
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
       fill(255,204,0,int(random(128))); 
       //pebug display
       //fill(0,0,200); 
      }
      
      if(range == 0) { //enemy 
        iphone.vibrate();
        iphone.beep();
        energy = energy - 4;
        soundEnemy.play();
        gameTransions = "Static";
        hurtRange = hurtValue;
        //hurt();
        pebug("energy " + energy);
        collisionTrix();
        //trixBAD.num = 0;
        spinclesState();
        
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
        //trixGOOD.num = 0;
        spinclesState();
        if(id == 2) {
          id = 0;
          activeGame();
        }
      }
    } else {
      hurtRange -= hurtRange*0.01;
    }
         
        
    // draw triangle      

    
    if(effect) {
      noStroke();
      triangle(x1, y1, x2, y2, x3, y3);
      strokeWeight(2);
      stroke(255);
      point(x1, y1);
      point(x2, y2);
      point(x3, y3);
    } else {
      strokeWeight(1);
      stroke(255);
      triangle(x1, y1, x2, y2, x3, y3);
    }
    
    
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
    changeTime = 10 + int(random(50-microfone, 100-microfone*2))*int(random(10-microfone/100));
    if(changeTime<0) {
      changeTime = 10;
    }
    changeTrix = 0;
    //pebug("changeTime: " + changeTime);
  }
  
  void collisionTrix() {
    range = rangeTrixType; 
    changeTime = 0;
    changeTrix = 0;
  }
  
}
