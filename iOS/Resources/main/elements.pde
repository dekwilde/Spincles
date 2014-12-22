class Logo {
  pL[] pArr;
  
  Logo() {
    pArr = new pL[42];
    //S
    pArr[0] = new pL(92,275);  //0 
    pArr[1] = new pL(136,302);  
    pArr[2] = new pL(182,276);
    pArr[3] = new pL(191,259);
    pArr[4] = new pL(89,199);
    pArr[5] = new pL(135,172);
    pArr[6] = new pL(181,199);
    
    //p
    pArr[7] = new pL(227,324); //7
    pArr[8] = new pL(227,177);
    pArr[9] = new pL(282,208);
    pArr[10] = new pL(282,269);
    pArr[11] = new pL(227,298);
    
    //i
    pArr[12] = new pL(314,257); //12
    pArr[13] = new pL(314,203);
    
    //n
    pArr[14] = new pL(348,268); //14
    pArr[15] = new pL(348,179);
    pArr[16] = new pL(348,204);
    pArr[17] = new pL(405,172);
    pArr[18] = new pL(460,203);
    pArr[19] = new pL(460,268);
    
    //c
    pArr[20] = new pL(600,268); //20
    pArr[21] = new pL(545,300);
    pArr[22] = new pL(489,268);
    pArr[23] = new pL(489,203);
    pArr[24] = new pL(546,171);
    pArr[25] = new pL(600,203);
    
    //l
    pArr[26] = new pL(629,257); //26
    pArr[27] = new pL(629,75);
    
    //e
    pArr[28] = new pL(777,268); //28
    pArr[29] = new pL(722,300);
    pArr[30] = new pL(664,268);
    pArr[31] = new pL(664,203);
    pArr[32] = new pL(722,171);
    pArr[33] = new pL(768,197);
    pArr[34] = new pL(722,224);
    
    //s
    pArr[35] = new pL(800,268); //35
    pArr[36] = new pL(858,300);
    pArr[37] = new pL(913,268);
    pArr[38] = new pL(810,219);
    pArr[39] = new pL(810,199);
    pArr[40] = new pL(856,172); 
    pArr[41] = new pL(902,199);
  }
  void draw() {
    
    //scale(0.4);
    
    //S
    strokeWeight(8);
    line(pArr[0].x,pArr[0].y,pArr[1].x,pArr[1].y);
    strokeWeight(12);
    line(pArr[1].x,pArr[1].y,pArr[2].x,pArr[2].y);
    strokeWeight(18);
    line(pArr[2].x,pArr[2].y,pArr[3].x,pArr[3].y);
    strokeWeight(24);
    line(pArr[3].x,pArr[3].y,pArr[4].x,pArr[4].y);
    strokeWeight(18);
    line(pArr[4].x,pArr[4].y,pArr[5].x,pArr[5].y);
    strokeWeight(12);
    line(pArr[5].x,pArr[5].y,pArr[6].x,pArr[6].y);
    
    
    //p
    strokeWeight(18);
    line(pArr[7].x,pArr[7].y,pArr[8].x,pArr[8].y);
    strokeWeight(12);
    line(pArr[8].x,pArr[8].y,pArr[9].x,pArr[9].y);
    strokeWeight(12);
    line(pArr[9].x,pArr[9].y,pArr[10].x,pArr[10].y);
    strokeWeight(8);
    line(pArr[10].x,pArr[10].y,pArr[11].x,pArr[11].y);
    
    //i
    strokeWeight(18);
    line(pArr[12].x,pArr[12].y,pArr[13].x,pArr[13].y);
    
    
    //n
    strokeWeight(18);
    line(pArr[14].x,pArr[14].y,pArr[15].x,pArr[15].y);
    strokeWeight(18);
    line(pArr[16].x,pArr[16].y,pArr[17].x,pArr[17].y);
    strokeWeight(12);
    line(pArr[17].x,pArr[17].y,pArr[18].x,pArr[18].y);
    strokeWeight(8);
    line(pArr[18].x,pArr[18].y,pArr[19].x,pArr[19].y);
    
    
    //c
    strokeWeight(8);
    line(pArr[20].x,pArr[20].y,pArr[21].x,pArr[21].y);
    strokeWeight(12);
    line(pArr[21].x,pArr[21].y,pArr[22].x,pArr[22].y);
    strokeWeight(18);
    line(pArr[22].x,pArr[22].y,pArr[23].x,pArr[23].y);
    strokeWeight(12);
    line(pArr[23].x,pArr[23].y,pArr[24].x,pArr[24].y);
    strokeWeight(8);
    line(pArr[24].x,pArr[24].y,pArr[25].x,pArr[25].y);
    
    
    //l
    strokeWeight(18);
    line(pArr[26].x,pArr[26].y,pArr[27].x,pArr[27].y);
    
    
    //e
    strokeWeight(8);
    line(pArr[28].x,pArr[28].y,pArr[29].x,pArr[29].y);
    strokeWeight(12);
    line(pArr[29].x,pArr[29].y,pArr[30].x,pArr[30].y);
    strokeWeight(18);
    line(pArr[30].x,pArr[30].y,pArr[31].x,pArr[31].y);
    strokeWeight(12);
    line(pArr[31].x,pArr[31].y,pArr[32].x,pArr[32].y);
    strokeWeight(18);
    line(pArr[32].x,pArr[32].y,pArr[33].x,pArr[33].y);
    strokeWeight(12);
    line(pArr[33].x,pArr[33].y,pArr[34].x,pArr[34].y);
    
    
    //s
    strokeWeight(8);
    line(pArr[35].x,pArr[35].y,pArr[36].x,pArr[36].y);
    strokeWeight(12);
    line(pArr[36].x,pArr[36].y,pArr[37].x,pArr[37].y);
    strokeWeight(18);
    line(pArr[37].x,pArr[37].y,pArr[38].x,pArr[38].y);
    strokeWeight(18);
    line(pArr[38].x,pArr[38].y,pArr[39].x,pArr[39].y);
    strokeWeight(12);
    line(pArr[39].x,pArr[39].y,pArr[40].x,pArr[40].y);
    strokeWeight(8);
    line(pArr[40].x,pArr[40].y,pArr[41].x,pArr[41].y);
    
    for(int i=0; i<42; i++) {
      pArr[i].draw();
    }
  }
}

class pL {
  float iX, iY, x,y;
  float rand = random(8);
  int n;
  float timer = random(10, 100);
  
  pL(float px, float py) {
    iX = px;
    iY = py;
  }
  void draw() {
    x = random(iX-rand, iX+rand);
    y = random(iY-rand, iY+rand);
    if(n>timer) {
      change();
      n = 0;
      timer = random(10, 100);
    }
    n++;
  }
  void change() {
    rand = random(10);
  }
  
}





// Intro animation
class IntroGame {

  float x1, y1, x2, y2, x3, y3;
  float radius = 300;
  float scaleTri = 8.0;
  float scaleInit = 8.0;
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
       //soundStartUP.play();  
     }
     
     
     if(acce<0.9999) {
       acce = acce + acce*0.26;
     } else {
       fill(0);
       rect(0,0,width,height);
       startGame();
     }
    } 
    

  }
}
