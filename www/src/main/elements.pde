class Dialog {
  Trix trix;
  float scl, aph;
  Dialog() {
    trix = new Trix(150);
  }
  void draw(String t1, String t2, String t3, boolean loop) {
    
    pushMatrix();
    rotate(0);
    translate(width/2,height/2);
    scale(1.0);
    dialogTimer += 4;
    scl = 1.6 - (dialogTimer*2)/100;
    aph = sin((dialogTimer*2)/50)*255;
    if(scl < 1.0) {
      scl = 1.0;
    }
    scale(scl);
    
    noStroke();
    fill(255,204,0, aph);
    
    pushMatrix();
    rotate(radians(180));
    triangle(trix.x1, trix.y1, trix.x2, trix.y2, trix.x3, trix.y3);
    popMatrix();
  
    fill(0, aph);
    textAlign(CENTER);
    textFont(fontText);
    textSize(16);
    text(t1, 0, -10); 
    textSize(36);
    text(t2, 0, 20);
    textSize(16);
    text(t3, 0, 10);
    
    popMatrix();
    
    if(dialogTimer>100) {
      if(loop) {
        dialogLoop = false;
      } else {
        dialogLoop = true;
      }
      dialogTimer = 0;
      gameDialog = "Null";
    }
  }
}

class Trix {
  float x1, y1, x2, y2, x3, y3;
  float s, h, r, a, ri;
  
  Trix(float w) {
    s = w; 
    h = 0.5 * sqrt(3) * s; 
    r = sqrt(3)/3 * s;
    ri = sqrt(3)/6 * s;
    a = (TWO_PI / 6) * 2;
       
    x1 = 0;
    y1 = -r;
      
    x2 = x1 + cos( a ) * s;
    y2 = y1 + sin( a ) * s;
    
    x3 = x1 + (cos(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
    y3 = y1 + (sin(atan2(y2-y1,x2-x1)-PI/3) * dist(x1,y1,x2,y2));
    
  }
}

class Logo {
  pL[] pArr;
  float logoscale = 0.3;
  
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
  void draw(int t) {
   
    pushMatrix();
    
    translate(width/2-(500*logoscale), height/2-(200*logoscale)+20+t); // a logo tem o tamanho original com 1000x400
    scale(logoscale);
   
    
    fill(255);
    //S
    stroke(0);
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
    noStroke();
    ellipse(pArr[5].x,pArr[5].y,8,8);
    ellipse(pArr[4].x,pArr[4].y,8,8);
    ellipse(pArr[3].x,pArr[3].y,8,8);

    //p
    stroke(0);
    strokeWeight(18);
    line(pArr[7].x,pArr[7].y,pArr[8].x,pArr[8].y);
    strokeWeight(12);
    line(pArr[8].x,pArr[8].y,pArr[9].x,pArr[9].y);
    strokeWeight(12);
    line(pArr[9].x,pArr[9].y,pArr[10].x,pArr[10].y);
    strokeWeight(8);
    line(pArr[10].x,pArr[10].y,pArr[11].x,pArr[11].y);    
    noStroke();
    ellipse(pArr[7].x,pArr[7].y,8,8);
    ellipse(pArr[8].x,pArr[8].y,8,8);
    stroke(0);
    
    //i
    strokeWeight(18);
    line(pArr[12].x,pArr[12].y,pArr[13].x,pArr[13].y);
    noStroke();
    ellipse(pArr[13].x,pArr[13].y,8,8);
    stroke(0);
    
    
    //n
    strokeWeight(18);
    line(pArr[14].x,pArr[14].y,pArr[15].x,pArr[15].y);
    strokeWeight(18);
    line(pArr[16].x,pArr[16].y,pArr[17].x,pArr[17].y);
    strokeWeight(12);
    line(pArr[17].x,pArr[17].y,pArr[18].x,pArr[18].y);
    strokeWeight(8);
    line(pArr[18].x,pArr[18].y,pArr[19].x,pArr[19].y);
    noStroke();
    ellipse(pArr[14].x,pArr[14].y,8,8);
    stroke(0);
    
    
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
    noStroke();
    ellipse(pArr[23].x,pArr[23].y,8,8);
    ellipse(pArr[24].x,pArr[24].y,8,8);
    stroke(0);
    
    
    
    //l
    strokeWeight(18);
    line(pArr[26].x,pArr[26].y,pArr[27].x,pArr[27].y);
    noStroke();
    ellipse(pArr[26].x,pArr[26].y,8,8);
    ellipse(pArr[27].x,pArr[27].y,8,8);
    stroke(0);
    
    
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
    noStroke();
    ellipse(pArr[31].x,pArr[31].y,8,8);
    ellipse(pArr[32].x,pArr[32].y,8,8);
    stroke(0);
    
    
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
    noStroke();
    ellipse(pArr[38].x,pArr[38].y,8,8);
    ellipse(pArr[40].x,pArr[40].y,8,8);
    stroke(0);
    
    popMatrix();  
    
    for(int i=0; i<42; i++) {
      pArr[i].draw();
    }
  }
}

class pL {
  float iX, iY, x,y;
  float rand = random(10);
  int n;
  float timer = random(10, 100);
  
  pL(float px, float py) {
    iX = px;
    iY = py;
  }
  void draw() {
    float rm = rand*(1+microfone/20);
    x = random(iX-rm, iX+rm);
    y = random(iY-rm, iY+rm);
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




class TrixelEffect {
  float w = scW * 0.2, h = 0.5 * sqrt(3) * w;  
  float tx = 0;
  float ty = 0; 
  float rd = 0;
  TrixelEffect() {
    
  }
  void draw0() {
    noFill();
    stroke(255);
    strokeWeight(microfone/20+2);
    for(int i=0; i<((width/w)+1)*2;i++) {
      for(int j=0; j<((height/h)+1)*2;j++) {    
          rd = microfone*4;
          for (float x = 0; x < width+w; x += w)
            for (float y = 0; y < height+h; y += 2*h)
              if (i*w/2 >= x && i*w/2 <= x+w)
                if (j*h/2 >= 2*abs(i*w/2-x-w/2)+y && j*h/2 <= y+h)
                  //triangle(x+random(-rd, rd),y+h+random(-rd, rd),x+w/2+random(-rd, rd),y+random(-rd, rd),x+w+random(-rd, rd),y+h+random(-rd, rd));
                  
                  point(x+random(-rd, rd),y+h+random(-rd, rd));
                  //point(x+w/2+random(-rd, rd),y+random(-rd, rd));
                  //point(x+w+random(-rd, rd),y+h+random(-rd, rd));
                            
          for (float x = -w/2; x < width+w; x += w)
            for (float y = 0; y < height+h; y += 2*h)
              if (i*w/2 >= x && i*w/2 <= x+w)
                if (j*h/2 <= -2*abs(i*w/2-x-w/2)+y+h && j*h/2 >= y)
                  //triangle(x+random(-rd, rd),y+random(-rd, rd),x+w/2+random(-rd, rd),y+h+random(-rd, rd),x+w+random(-rd, rd),y+random(-rd, rd));
                  
                  point(x+random(-rd, rd),y+random(-rd, rd));                  
                  //point(x+w/2+random(-rd, rd),y+h+random(-rd, rd));
                  //point(x+w+random(-rd, rd),y+random(-rd, rd));        
                  
      }              
    }
  }
  
  void draw1() {
    noStroke();
    for(int i=0; i<((width/w)+1)*2;i++) {
      for(int j=0; j<((height/h)+1)*2;j++) {    
          fill(255,random(255));
          for (float x = 0; x < width; x += w)
            for (float y = 0; y < height; y += 2*h)
              if (i*w/2 >= x && i*w/2 <= x+w)
                if (j*h/2 >= 2*abs(i*w/2-x-w/2)+y && j*h/2 <= y+h)
                  triangle(x,y+h,x+w/2,y,x+w,y+h);
          
          for (float x = -w/2; x < width; x += w)
            for (float y = h; y < height; y += 2*h)
              if (i*w/2 >= x && i*w/2 <= x+w)
                if (j*h/2 >= 2*abs(i*w/2-x-w/2)+y && j*h/2 <= y+h)
                  triangle(x,y+h,x+w/2,y,x+w,y+h);
          
          for (float x = -w/2; x < width; x += w)
            for (float y = 0; y < height; y += 2*h)
              if (i*w/2 >= x && i*w/2 <= x+w)
                if (j*h/2 <= -2*abs(i*w/2-x-w/2)+y+h && j*h/2 >= y)
                  triangle(x,y,x+w/2,y+h,x+w,y);
          
          for (float x = 0; x < width; x += w)
            for (float y = h; y < height; y += 2*h)
              if (i*w/2 >= x && i*w/2 <= x+w)
                if (j*h/2 <= -2*abs(i*w/2-x-w/2)+y+h && j*h/2 >= y)
                  triangle(x,y,x+w/2,y+h,x+w,y);    
      }              
    }
  }
  
  void draw2(float n, color c) {
    noStroke();
    for(int j=0; j<n;j++) {    
          fill(c,random(255));
          tx = random(width);
          ty = random(height);
          for (float x = 0; x < width; x += w)
            for (float y = 0; y < height; y += 2*h)
              if (tx >= x && tx <= x+w)
                if (ty >= 2*abs(tx-x-w/2)+y && ty <= y+h)
                  triangle(x,y+h,x+w/2,y,x+w,y+h);
       
          for (float x = -w/2; x < width; x += w)
            for (float y = h; y < height; y += 2*h)
              if (tx >= x && tx <= x+w)
                if (ty >= 2*abs(tx-x-w/2)+y && ty <= y+h)
                  triangle(x,y+h,x+w/2,y,x+w,y+h);
       
          for (float x = -w/2; x < width; x += w)
            for (float y = 0; y < height; y += 2*h)
              if (tx >= x && tx <= x+w)
                if (ty <= -2*abs(tx-x-w/2)+y+h && ty >= y)
                  triangle(x,y,x+w/2,y+h,x+w,y);
       
          for (float x = 0; x < width; x += w)
            for (float y = h; y < height; y += 2*h)
              if (tx >= x && tx <= x+w)
                if (ty <= -2*abs(tx-x-w/2)+y+h && ty >= y)
                  triangle(x,y,x+w/2,y+h,x+w,y);
      }              
  }
  
  
}

class TrixParticle {
  int num;
  int amount;
  String tp;
  float particleX = 0;
  float particleY = 0;
  
  TrixParticle(String type) {
    tp = type;
    amount = 3;
    particles = new ArrayList();
    num = 0;
  }
  void init(int n, float posX, float posY) {
    num = 0;
    amount = n;
    particleX = posX;
    particleY = posY;
  }
  
  
  void draw(float cx, float cy){
    num += 1;
    if(num<=amount) {
      particles.add(new Particle(tp,particleX,particleY));
    }
    for(int i=0; i < particles.size(); i++){
      Particle p = (Particle) particles.get(i);
      p.draw();
      //p.gravity();
      p.display();
      //p.conect();
      p.collision(cx,cy);
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
  float initX, initY, initAlpha;
  float r;
  int dg;
  float sr;
  float xspeed,yspeed;
  float diameter = rad*.15;
  float distance = rad/2;
  float speedActive;
  float delay = random(0.001, 0.01);
  float elastic = 0.8;
  int life =0, lifeTime = 50+int(random(150));
  boolean death = false;
  String tp;
  
  Trix trix;

  
  Particle(String type, float posX, float posY){
    trix = new Trix(rad*.25);
    tp = type;
    x= posX;
    y= posY;
    initX = posX;
    initY = posY;
    initAlpha = 0;
    speedActive = 2 + random(5);
    r = random(360);
    dg = random(-1, 1);
    sr = 1+random(10);
    if(tp == "magnetic") {
      xspeed= random(10/10, 40/10);
      yspeed= random(10/10, 40/10); 
    }
    if(tp == "explode") {
      xspeed= random(-40/10, 40/10);
      yspeed= random(-40/10, 40/10); 
    }
  }
    
  void draw(){
      
    switch( tp ) { 
      case "explode":
        x = x+xspeed;
        y = y+yspeed; 
      break; 
      
      case "magnetic":
        float dx = spinX - x;
        float dy = spinY - y;
        xspeed = dx*delay+xspeed*elastic;
        yspeed = dy*delay+yspeed*elastic;
        x = x+xspeed;
        y = y+yspeed;
      break; 
    }
    
  }
    
  void display(){
    if(initAlpha<255) {
      initAlpha = initAlpha + speedActive;
    } else {
      initAlpha = 255;  
    }
    strokeWeight(1);
    noStroke();    
    fill(0,initAlpha);
    pushMatrix();
    translate(x,y);
    r = r + dg*(sr);
    rotate(radians(r));
    triangle(trix.x1, trix.y1, trix.x2, trix.y2, trix.x3, trix.y3);
    popMatrix();
    //ellipse(x, y, 2, 2);
  }
  
  void gravity(){
    yspeed += 0.01;
  }
  
  void collision(float cx, float cy) {
    pebug(dist(x,y,initX,initY));
    if(initAlpha>250 && dist(x,y,cx,cy)<diameter) {
      pebug("collisioon");
      death = true;
      hurt();
    }
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
    diameter = rad/25;
    for (int i = 0; i <particles.size() ; i++) {
      
      Particle other = (Particle) particles.get(i);
 
      if (this != other) {
        if (dist(x, y, other.x, other.y)<distance) {
          
          if(tp == "magnetic") {
            diameter = diameter*2;
          }
          if(tp == "explode") {
            diameter = 0;
          }
          stroke(0,70);
          line(x, y, other.x, other.y);
        }
      }
    } //end for
  }
     
}
