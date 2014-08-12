//LAYOUT and ANIMATION
int wCount = 4;
int hCount = 3;
int rad = 140; //triangle radius
float mx, my; //mouse or object position middle;
float twothird = 2.0/3.0; //triangle use
float trixelX, trixelY;
float angleCompass;
float delaySpeedCompass = 20;

//ENGINE GAME
int rangeCentroid = 10;
int changeTimeRange = 10;
int changeTimeRand = 10;
int changeTimeRandRange = 200;




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

    dgr = abs(radians(angleCompass) - PI)*PI;
    r += (dgr - r)*easing;
    
    
    println("degrees " + angleCompass);
    //println("radians " + r);
    d = dist(width/2, height/2, trixelX, trixelY);
    mx = d*cos(-r);
    my = d*sin(-r);
  
    pushMatrix();
    rotate(r);
    gridtrixel.draw();
    fill(0,255,0);
    ellipse(mx,my, 30, 30); // target position
    popMatrix();
    stroke(0,255,0);
    line(0, 0, 0, 20); //point compass
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
  boolean activeTrix = false;
  float aniTrix;
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
      
      range = int(random(rangeCentroid));

  }
    
  void draw() {
    changeTrix = changeTrix + 1;
    if(changeTrix>changeTime) { //warnning
      fill(255,255,255,int(random(255)));
      if(changeTrix>changeTime+20) { //actived
        resetTrix();
      }
    } else {
      noFill();
    }
    
    if(range == 0) { //enemy
      fill(255);  
    }
    if(range == 1) { //score
      troid();
    }
    

    
    
    if(checkCollision(mx,my,t)){
      if(range == 0) { //enemy
        //rotate(random(10));
        score = score - 1;
        fill(int(random(255)),int(random(100)));
        if(!activeTrix) {
          activeTrix = true;
          aniTrix = changeTrix;
        }
        if(changeTrix>aniTrix+5){
          hurt();
          println("score " + score);
          resetTrix();
          trixBAD.num = 0;
        }
      }
      if(range == 1) { //score
        score = score + 2;
        println("score " + score);
        resetTrix();
        trixGOOD.num = 0;
        
      }
    } else {
      activeTrix = false;
    }
    
    
    
    stroke(255);
    strokeWeight(1);
    t.drawTriangle();
  }

  void resetTrix() {
    range = int(random(rangeCentroid));
    changeTime = changeTimeRange + changeTimeRandRange*int(random(changeTimeRand));
    changeTrix = 0;
    activeTrix = false;
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
  
  void drawTriangle() {
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

