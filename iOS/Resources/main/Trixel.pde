int rad; //triangle radius 215 is default
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
  TrixParticle particleExplode;
  float x1, y1, x2, y2, x3, y3;
  float s, h, radius, angle;
  float x, y;
  int v;
  int id;

  int range;
  int changeTrix = 0;
  int changeTime = 10000;
  int changeActive = 30;
  
  float collisionX, collisionY;
  
  boolean enemyActive = false;
  boolean enemyDraw = false;

  Trixel(float tx, float ty, int inv, int num) {
      particleExplode = new TrixParticle("explode");
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



    noFill();

    pushMatrix();
    translate(x, y); 
    if(v == 1 || v == 3) {
      rotate(radians(180));
    }  
        
    if(range == 3) { //enemy
      stroke(255);
      strokeWeight(1);
      if(enemyActive) {
        fill(255,204,0);
        particleExplode.draw();
      } else {
        noFill();
      }
      triangle(x1,y1,x2,y2,x3,y3);
      
            
      rotate(radians(180));
      
      scale(0.12);
      fill(0,random(100));
      triangle(x1,y1,x2,y2,x3,y3);
      
      scale(0.4);
      fill(0);
      triangle(x1,y1,x2,y2,x3,y3);

      

    }    
    
    if(range == 0) { //enemy
      fill(0);
    }
    
    if(range == 1) { //energy/score
      stroke(255);
      strokeWeight(1);
      noFill();
      triangle(x1,y1,x2,y2,x3,y3);
      
      scale(0.25);
      rotate(radians(180));
//      fill(255,int(random(255)));
//      triangle(0,0,x1,y1,x2,y2);
//      fill(255,int(random(255)));
//      triangle(0,0,x2,y2,x3,y3);
//      fill(255,int(random(255)));
//      triangle(0,0,x3,y3,x1,y1);
      fill(255,int(random(255)));
      triangle(x1,y1,x2,y2,x3,y3);
      noFill();
    }
    
    
    if(checkCollision(collisionX,collisionY)){
      
      if(range > 1) {
       fill(255,204,0,int(random(204))); 
      }
      
      if(range == 0) { //enemy 
        hurt();
        collisionTrix();
      }
      if(range == 3 && !enemyDraw) { //enemy
          gameTransions = "Blackout";
          particleExplode.init(2, collisionX, collisionY);
          //particleMagnetic.init(2, spinX+random(-rad+100,rad+100),spinY+random(-rad+100,rad+100));
          //gameEnemy = "Magnetic";
          enemyActive = true;
          enemyDraw = true;     
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

    /*
    if(effect) {
      stroke(255,204,0);
      triangle(x1, y1, x2, y2, x3, y3);
      strokeWeight(1);
      stroke(0);
      point(x1, y1);
      point(x2, y2);
      point(x3, y3);
    } else {
      strokeWeight(1);
      stroke(255,255-alphaBG);
      triangle(x1, y1, x2, y2, x3, y3);
    }
    */
    
    strokeWeight(1);
    stroke(255,255-alphaBG);
    triangle(x1, y1, x2, y2, x3, y3);
    
    
    if(range == 0) { //enemy
      trifract(0, 0, radius,int(random(4)), false);
      trifract(0, 0, radius/2,int(random(3)), true);
      //trifract(0, 0, radius/4,int(random(1,4)), false);
    }
    
    //change Animation
    changeTrix = changeTrix + 1;
    if(changeTrix>changeTime) { //warnning
      
      int fl = floor((changeTrix-changeTime)*(128/changeActive));
      float st = ((changeTrix-changeTime)*(150/changeActive))/100;
      if(st>1.0) {
        st = 1.0;
        fl = int(random(255));
        range = rangeTrixType;
      }
      if(range > 1) {
        fill(0,fl);
        scale(st);
      }
      if(range == 0) { //0 == enemy 
        fill(255,fl);
        scale(1);
      }
      //stroke(255);
      noStroke();
      triangle(x1, y1, x2, y2, x3, y3);
      
      if(changeTrix>changeTime+changeActive) { //actived
        resetTrix();
      }
    } 
    
    popMatrix();

  } //end draw



  

  boolean checkCollision(float cx, float cy) {
    float tArea,t1Area,t2Area,t3Area,totalArea;
    tArea  = triArea(x1,y1,x3,y3,x2,y2);
    t1Area = triArea(cx,cy,x2,y2,x3,y3);
    t2Area = triArea(cx,cy,x3,y3,x1,y1);
    t3Area = triArea(cx,cy,x2,y2,x1,y1);    
    totalArea = t1Area+t2Area+t3Area;
    return (totalArea == tArea);
  } 
  
  float triArea(float p1, float p2, float p3, float p4, float p5, float p6) {
    float a,b,c,d;
    a = p1 - p5;
    b = p2 - p6;
    c = p3 - p5;
    d = p4 - p6;
    return (0.5* abs((a*d)-(b*c)));
  }
  
  void trifract(float x, float y, float l, int level, boolean inv){
    pushMatrix();
    rotate(radians(180));
    if(inv) {
      rotate(radians(180));
    } 
    
    stroke(255);  
    if(int(random(2)) == 0){line(x, y+l,x+l*sqrt(3)/2, y-l/2);}
    if(int(random(2)) == 0){line(x+l*sqrt(3)/2, y-l/2,x-l*sqrt(3)/2, y-l/2);}
    if(int(random(2)) == 0){line(x, y+l,x-l*sqrt(3)/2, y-l/2);}
    
    
    /*
    fill(0,random(128));
    noStroke();
    triangle(x, y+l,x+l*sqrt(3)/2, y-l/2,x-l*sqrt(3)/2, y-l/2);
    */
    popMatrix();
    
    if (level>1){
        l*=.5;
        level= level-1;
        trifract(x, y+l, l, level, inv);
        trifract(x+l*sqrt(3)/2, y-l/2, l, level, inv);
        trifract(x-l*sqrt(3)/2, y-l/2, l, level, inv);
    }    
  }

  
  void resetTrix() {
    enemyActive = false;
    enemyDraw = false;
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
