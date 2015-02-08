/* @pjs 
transparent="true"; 
crisp="false";
*/

PFont fontTitle, fontText;

float easing = 0.02;
float spring = 0.02;
float gravity = 10.0;
float gravityX = 0.0;
float gravityY = 0.0;
float bx;
float by;
int bs = 120;
boolean bover = false;
boolean locked = false;
boolean effect = false;
float bdifx = 0.0; 
float bdify = 0.0;

float iAngle;
float startAngle;
float iScale;
float startEscala;

float microfone = 1.0;
float mic_perc = 100; // 0 a 100

//float dim = 40;


PGraphics pimg;
int dim = 1300;


Tbody body;

int scW,scH;
int wCount, hCount;

int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float radius = 0.00;

float x = width/2; 
float y = height/2;
float targetX, targetY;
float spinX, spinY;
float pi = 0;

float [] rotation = new float[numOfArms];
float [] angleRadius = new float[numOfArms];
float [] angleSegment= new float[numOfArms];
float [] angleSpeed = new float[numOfArms];
float [] angle = new float[numOfArms];
float [] WeightSegment = new float[numOfArms];
float [] segLength = new float[numOfArms];
float angleSpeedTouch = 0.0f;
float angleRadiusTouch = 0.0f;
float WeightSegmentTouch = 0.0f;
float rotationT = 0.0;

boolean cameraShow = false;
boolean isGame = false;

PImage howImg, logoImg;

float initColorAlpha = 0.0;
float endColorAlpha = 0.0;
float initPosY = 0.0;
int initColor = 255;
int alphaBG = 0;
float tweenBG = 0.0;
float tween = 0.0;
int load = 0;
float dialogTimer = 0;

float hurtRange = 0.0;
int hurtTimer = 0;
int hurtValue = 128;
int hurtLife = 20;

float gx,gy;
float mx, my; //mouse or object position middle;
float trixelX, trixelY;
float nX, nY;
float angleCompass;
float atan;

Logo logo;
TrixelEffect tEff;
float pInfo = height;


// Transitions

String gameState, gameEnemy, gameTransions, gameSound, gameDialog;

void setup() {  
  stateSetup();   
}

void draw() {
  stateSite();   
}
class Tbody {
  float x, y;  
  Arm arms;  
   
  Tbody(float posX, float posY, float rotator, float escala) {
    pushMatrix();
    x = posX;
    y = posY;
    translate(posX, posY);
    rotate(rotator);
    scale(escala);
    //
    for(int i=0; i<numOfArms; i++) {
      radius = angleRadius[i] * sin(angle[i]);
      arms = new Arm(radius, WeightSegment[i]+WeightSegmentTouch, segLength[i]);
      rotate(rotation[i]);
      
      //rotate(PI/(numOfArms/2));
      //rotate(random(PI));
    }
    popMatrix();
  }
}


class Arm {

  Arm(float angleSeg, float WeightSeg, float LengthSeg) {   
      pushMatrix();
      for(int i=0; i<numSegment; i++) {
        if(i>0) {
          draw(LengthSeg, 0, angleSeg*angleSegment[i]-(microfone/50)+angleRadiusTouch, ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg);
        } else {
          draw(0, 0, angleSeg, (numSegment+1)*WeightSeg, LengthSeg); 
        }
      }
      popMatrix();
  }
  
  void draw(float x, float y, float a, float Weight, float LengthSeg) {
      translate(x, y);
      rotate(a);
      strokeWeight(Weight/SegWeightPor);
      fill(255,255);
      noStroke();
      ellipse(0,0,2,2);
      stroke(0, 90);
      line(0, 0, LengthSeg, 0);
  } 
}

void spinclesState() {
  for(int i=0; i<numOfArms; i++) {
    rotation[i] = random(0, 360);
    angleRadius[i] = random(0.3, 1.9);
    angleSpeed[i] = random(0.009, 0.16);
    angleSegment[i] = random(0.09, 1.4);
    WeightSegment[i] = random(1.4, 6.1);
    segLength[i] = random(25, 65);
  }
}

void spinclesDraw() {
  ///////////////////////////////////////////////// Spincles draw /////////////////////////////////////////////////////////
  
  for(int i=0; i<numOfArms; i++) {
    angle[i] = angle[i] + angleSpeed[i] + microfone/100 + angleSpeedTouch;
  }
  
  targetX = mouseX;
  //targetX = control.x;
  float dx = targetX - x;
  float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
  x += dx * easing + nX*(microfone + random(0,5));
  spinX = x;
  
  targetY = mouseY;
  //targetY = control.y;
  float dy = targetY - y;
  float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
  y += dy * easing + nY*(microfone + random(0,5));
  spinY = y;
          
  PVector  v1 = new PVector(targetX, targetY);
  PVector  v2 = new PVector(x, y); 
  float d = v1.dist(v2);
  
  rotationT = rotationT + noise(pi/500)*((d*easing)/50) - microfone/200;
  
  body = new Tbody(x, y, rotationT, iScale);
  //+ noise(pi/10)*2)
  
  pi++;
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
  void draw() {
   
    pushMatrix();
    scale(logoscale);
    translate(200-(500*logoscale), 50-(200*logoscale)); // a logo tem o tamanho original com 1000x400
    
   
    
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




class TrixelEffect {
  float w = 160, h = 0.5 * sqrt(3) * w;  
  float tx = 0;
  float ty = 0; 
  TrixelEffect() {
    
  }
  void draw1() {
    noStroke();
    for(int i=0; i<((width/w)+1)*2;i++) {
      for(int j=0; j<((height/h)+1)*2;j++) {    
          fill(255,random(100));
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

void pebug(String m) {
  println(m);
}


void stateSetup() {
  scW = screen.width;
  scH = screen.height;
  size(screenWidth, screenHeight);
  //size(scW, scH, P2D);
  frameRate(30);

  
  //rectMode(CENTER_RADIUS);
  rectMode(CORNER);
  imageMode(CENTER);
  textAlign(CENTER);
  //smooth();

  iScale = 1.6;


  
  logo = new Logo();
  tEff = new TrixelEffect();
  spinclesState();


  bx = width/2;
  by = height/2;
  iAngle = 0;
  initPosY = height + 100;
    
  gameState = "Site";
 
}

void mouseReleased() {
  spinclesState();
}



void stateSite() {
  int Talign = 0;
  rotate(0);
  translate(0,0);
  scale(1.0);
  background(255, 204, 0);
  tEff.draw1(); 
  spinclesDraw();
  logo.draw();
  
}

