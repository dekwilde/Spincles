IntroTrix introtrix;
void setup() {
  size(320,480, P2D);
  introtrix = new IntroTrix();
}

void draw() {

  introtrix.draw();

}

class IntroTrix {

  float x1, y1, x2, y2, x3, y3;
  float radius;
  float scaleTri;
  float scaleInit;
  float acce = 0.05;
  
    
  void IntroTrix() {

    scaleInit = 12.0;
    scaleTri = scaleInit;
    
    radius = 100;
    x1 = 0;      
    y1 = -radius/2;
    
    float angle = (TWO_PI / 6) * 2;
    x2 = x1 + cos( angle ) * radius;
    y2 = y1 + sin( angle ) * radius;
    
    x3 = x1 + (cos(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
    y3 = y1 + (sin(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
    
  }
  
  void draw() {
    //pushMatrix();
    translate(width/2, height/2);  
    scale(scaleTri);
    
    scaleTri = scaleTri-scaleTri*acce;
    if(scaleTri<0.1) {
     scaleTri = scaleInit;
     if(acce<0.99) {
       acce = acce + acce*0.05;
     } else {
       fill(0);
       rect(0,0,width,height);
       noLoop();
     }
    } 
    triangle(x1, y1, x2, y2, x3, y3);
    //popMatrix();
  }
}




