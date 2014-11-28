class IntroGame {

  float x1, y1, x2, y2, x3, y3;
  float radius = 300;
  float scaleTri = 4.0;
  float scaleInit = 4.0;
  float acce = 0.05;
  float angle = (TWO_PI / 6) * 2;
  
    
  void IntroGame() {
    //
  }
  
  void draw() {
    
    x1 = 0;      
    y1 = -radius/2;
    
    x2 = x1 + cos( angle ) * radius;
    y2 = y1 + sin( angle ) * radius;
    
    x3 = x1 + (cos(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
    y3 = y1 + (sin(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
    
    
    
    pushMatrix();
    translate(width/2, height/2);  
    scale(scaleTri);
    stroke(255, 204, 0);
    fill(0, round(random(255)));
    strokeWeight(1);
    triangle(x1, y1, x2, y2, x3, y3);
    popMatrix();


    if(scaleTri>scaleInit-0.2) {
     soundTransOUT.rewind();
     soundTransOUT.play();
    }    
    
    scaleTri = scaleTri-scaleTri*acce;
    

    
    if(scaleTri<0.1) {

     fill(255);
     rect(0,0,width,height);
     scaleTri = scaleInit;
     
     if(acce>0.2 && acce<0.3) {
       soundStartUP.play();  
     }
     
     
     if(acce<0.9999) {
       acce = acce + acce*0.2;
     } else {
       fill(0);
       rect(0,0,width,height);
       startGame();
     }
    } 
    

  }
}
