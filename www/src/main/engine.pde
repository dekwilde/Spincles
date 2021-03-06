int rad; //triangle radius 215 is default
int rangeTrixType = 10;
int rangechangeTime = 10;
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
    
    if(infectArm.length>2) {
      float nX = 0;
      float nY = 0;   
    } else {
      float nX = mx*(microfone/50 + 1) - width/2;
      float nY = my*(microfone/50 + 1) - height/2;      
    }

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
      trixel[i].type = rangeTrixType;
      trixel[i].loopTrixInit = millis();
      trixel[i].changeTime = 0;
    } 
  }
}

class Trixel {
  Trix trix;
  TrixParticle particleExplode;
  float x1, y1, x2, y2, x3, y3;
  float s, h, radius, radiusinternal, angle;
  float x, y;
  int v;
  int id;

  int type;
  float loopTrix = 0.0f; 
  float loopTrixInit = millis();
  int changeTime = rangechangeTime*1000;
  int changeActive = loopTrixSpeed/30;
  String trixelState;
  float initAlpha = 0.0;
  float initStroke = rad;
  float tweenAlpha = 255;
  
  float collisionX, collisionY;
  
  boolean enemyActive = false;
  boolean enemyDraw = false;

  Trixel(float tx, float ty, int inv, int num) {
      particleExplode = new TrixParticle("explode");
      trix = new Trix(rad);
      
      id = num;
      if(id == 2) {
        trixelState = "Start";
        type = 0;
      } else {
        trixelState = "Null";
        type = rangeTrixType;
      }
      
      s = rad; 
      h = trix.h; 
      radius = trix.r;
      radiusinternal = trix.ri;
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

    pushMatrix();
    translate(x, y); 
    if(v == 1 || v == 3) {
      rotate(radians(180));
    }
    
    if (initAlpha<100) {      
      //initAlpha = initAlpha + 0.4*speedEscala; 
      initAlpha = round(tw33n(0, 100, 30000));  
    } else {
      initAlpha = 100;
    }
    
    
    stroke(0, initAlpha);
    //strokeWeight(initStroke);
    strokeWeight(2);
    noFill();
    triangle(x1,y1,x2,y2,x3,y3); 
    strokeWeight(0.1);
        
    switch( trixelState ) {
      case "Null":
        //
      break;
      
      case "Start":
        if(gameState == "GameStart" && initAlpha == 100){
          type = 0;
          trixelState = "Active";    
        }
      break;
      
      case "Active":

        if(type == 3) { //enemyMagnetic          
          if(enemyActive) {
            gameEnemy = "Magnetic";
            if(tweenAlpha>0) {
              tweenAlpha = tweenAlpha - 5;
              noStroke();
              fill(255,tweenAlpha);
              triangle(x1,y1,x2,y2,x3,y3);
            } else {
              tweenAlpha = 0;
              noFill();
            }
          } else {      
            rotate(radians(180));
            scale(0.25);
            noStroke();
            fill(0);
            triangle(x1,y1,x2,y2,x3,y3);     
          }
        }
        
        if(type == 2) { //enemyExplode          
          if(enemyActive) {
            particleExplode.draw(collisionX,collisionY);
            if(tweenAlpha>0) {
              tweenAlpha = tweenAlpha - 5;
              noStroke();
              fill(255,tweenAlpha);
              triangle(x1,y1,x2,y2,x3,y3);
            } else {
              tweenAlpha = 0;
              noFill();
            }
          } else {
            rotate(radians(180));
            scale(0.25);
            noStroke();
            fill(0);
            triangle(x1,y1,x2,y2,x3,y3);
          }
        }    
        
        if(type == 1) { //enemyArea
          fill(0);
        }
        
        if(type == 0) { //energy          
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
        
        if(dist(0,0,collisionX,collisionY)<radiusinternal) {
        //if(checkCollision(collisionX,collisionY)){
                
          if(type == 3 && !enemyDraw) { //enemyMagnetic
            gameTransions = "Blackout"; 
            int radscale = 10;
            float radrandX = random(-rad-radscale,rad+radscale);
            float radrandY = random(-rad-radscale,rad+radscale);
                        
            particleMagnetic.init(1, spinX+radrandX,spinY+radrandY);
            enemyActive = true;
            enemyDraw = true;    
          }
          
          
          if(type == 2 && !enemyDraw) { //enemyExplode
            gameTransions = "Blackout";
            
            int radscale = rad;
            //float radrandX = random(-rad/radscale,rad/radscale);
            //float radrandY = random(-rad/radscale,rad/radscale);
            float radrandX = 0;
            float radrandY = 0;            
            particleExplode.init(2, collisionX+radrandX, collisionY+radrandY);
            enemyActive = true;
            enemyDraw = true;     
          } 
          
          if(type == 1) { //enemyArea 
            hurt();
            collisionTrix();
          }          
          
          if(type == 0) { //energy
            gotch();
            collisionTrix();
            if(id == 2) {
              id = 0;
              isGame = true;
              gameState = "GameLevel";
              gameDialog = "Level";  
              activeGame();
            } 
          }
          
        } else {
          hurtRange -= hurtRange*0.01;
        } // end collision
             
            
        // draw triangle      
  
        //strokeWeight(1);
        noStroke();
        triangle(x1, y1, x2, y2, x3, y3);
        
        if(type == 1) { //enemyArea 
          //trifract(0, 0, radius,int(random(4)), false);
          //trifract(0, 0, radius/2,int(random(3)), true);
          //trifract(0, 0, radius/4,int(random(1,4)), false);
        }

      break;         
    } //end switch

    trixTimerChange();
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
  
  void trifract(float x, float y, float l, int lvl, boolean inv){
    pushMatrix();
    rotate(radians(180));
    if(inv) {
      rotate(radians(180));
    } 
    
    stroke(0);  
    if(int(random(2)) == 0){line(x, y+l,x+l*sqrt(3)/2, y-l/2);}
    if(int(random(2)) == 0){line(x+l*sqrt(3)/2, y-l/2,x-l*sqrt(3)/2, y-l/2);}
    if(int(random(2)) == 0){line(x, y+l,x-l*sqrt(3)/2, y-l/2);}
    
    
    /*
    fill(0,random(128));
    noStroke();
    triangle(x, y+l,x+l*sqrt(3)/2, y-l/2,x-l*sqrt(3)/2, y-l/2);
    */
    popMatrix();
    
    if (lvl>1){
        l*=.5;
        lvl= lvl-1;
        trifract(x, y+l, l, lvl, inv);
        trifract(x+l*sqrt(3)/2, y-l/2, l, lvl, inv);
        trifract(x-l*sqrt(3)/2, y-l/2, l, lvl, inv);
    }    
  }

  void resetTrix() { // gameDesign esta aqui nessa funcao e no type de inimigo
    gameEnemy = "Null";
    enemyActive = false;
    enemyDraw = false;
    tweenAlpha = 255;
    type = int(random(rangeTrixType));
    changeTime = 10 + int(random(100-microfone, 200-microfone*2))*int(random(rangechangeTime));
    loopTrixInit = millis();
    
    if(type>3) {
      trixelState = "Null";  
    } else {
      trixelState = "Active";
           
      if(type != rangeTrixType) {
        if(type>0 && level == 0) {
          type = rangeTrixType;  
          rangeTrixType = 10;
          rangechangeTime = 5;
        }

        if(type>0 && level == 1) {
          type = rangeTrixType;  
          rangeTrixType = 10;
          rangechangeTime = 5;
        }

        if(type>0 && level == 2) {
          type = rangeTrixType;  
          rangeTrixType = 5;
          rangechangeTime = 4;
        }

        if(type>1 && level == 3) {
          type = rangeTrixType; 
          rangeTrixType = 10; 
          rangechangeTime = 4;
        }

        if(type>1 && level == 4) {
          type = rangeTrixType; 
          rangeTrixType = 5; 
          rangechangeTime = 3;
        }        
        
        if(type>2 && level == 5) {
          type = rangeTrixType;
          rangeTrixType = 10; 
          rangechangeTime = 3;
        }

        if(type>2 && level == 6) {
          type = rangeTrixType;
          rangeTrixType = 5;  
          rangechangeTime = 2;
        }

        if(type>2 && level > 6) {
          type = rangeTrixType;
          rangeTrixType = 4;  
          rangechangeTime = 1;
        }        
        
      }
    }

    //pebug("changeTime: " + changeTime);
  }
 
  void collisionTrix() {
    trixelState = "Null";
    type = rangeTrixType; 
    changeTime = 0;
    loopTrixInit = millis();
  }
  
  void trixTimerChange() {
    //change Trix
    loopTrix = (millis() - loopTrixInit)/loopTrixSpeed;
    if(loopTrix>changeTime) { //warnning
      
      int fl = floor((loopTrix-changeTime)*(128/changeActive));
      float st = ((loopTrix-changeTime)*(150/changeActive))/100;
      if(st>1.0) {
        st = 1.0;
        fl = int(random(255));
        type = rangeTrixType;
      }
      if(type > 0) {
        fill(0,fl);
        scale(st);
      }
      if(type == 1) { //enemy Area
        fill(255,fl);
        scale(1);
      }
      
      if(loopTrix>changeTime+changeActive) { //actived
        resetTrix();
      }
            
      //stroke(255);
      noStroke();
      triangle(x1, y1, x2, y2, x3, y3);
    } 
  }
}
