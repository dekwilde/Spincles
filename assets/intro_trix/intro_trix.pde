Triangle t;
float x1, y1, x2, y2, x3, y3;
float radius;
float scaleTri;
float scaleInit;
float acce = 0.05;

  
void setup() {
  size(320,480, P2D);
  
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
  
  t = new Triangle(x1,y1,x2,y2,x3,y3);
  
}

void draw() {
  pushMatrix();
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
  
  
  t.draw();
  popMatrix();
}


class Triangle {
  float p1x;
  float p1y;
  float p2x;
  float p2y;
  float p3x;
  float p3y;
  
  Triangle(float point1x,float point1y,float point2x,float point2y,float point3x,float point3y){
    p1x = point1x;
    p1y = point1y;
    p2x = point2x;
    p2y = point2y;
    p3x = point3x;
    p3y = point3y;        
  }
  
  void draw() {
    triangle(p1x, p1y, p2x, p2y, p3x, p3y);
  }
}

