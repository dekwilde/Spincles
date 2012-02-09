Tbody body;

int numSegment = 4;
int numOfArms = 10;
float SegWeightPor = 1.9f;
float radius = 0.0f;
float easing = 0.05f;
float x, y;
float targetX, targetY;
float pi = 0;
float airX = 0.0;
float airY = 0.0;

float [] rotation = new float[numOfArms];
float [] angleRadius = new float[numOfArms];
float [] angleSegment= new float[numOfArms];
float [] angleSpeed = new float[numOfArms];
float [] angle = new float[numOfArms];
float [] WeightSegment = new float[numOfArms];
float [] segLength = new float[numOfArms];

boolean infoShow = false;
PImage infoImg;
ButtonInfo btInfo;
ButtonClose btClose;
ButtonLink btSupport;
ButtonLink btContact;
float pInfo = 480;


void setup() {
  //size(screenWidth, screenHeight);
  size(320, 480);
  frameRate(30);
  //smooth(); 
  stroke(0, 100);
  
  infoImg= loadImage("infos.jpg");
  
  btInfo = new ButtonInfo();
  btClose = new ButtonClose();
  btSupport = new ButtonLink(90, 458, 60, 12);
  btContact = new ButtonLink(230, 458, 60, 12);
  
  for(int i=0; i<numOfArms; i++) {
    rotation[i] = random(0, 360);
    angleRadius[i] = random(0.3, 1.4);
    angleSpeed[i] = random(0.009, 0.03);
    angleSegment[i] = random(0.09, 1.4);
    WeightSegment[i] = random(1.4, 6.1);
    segLength[i] = random(30, 70);
  } 
  
}

void draw() {
      if (infoShow) {
          image(infoImg, 0, pInfo);
        //tint(20);
          if (pInfo<1) {
              pInfo = 0;
              btClose.frame();
              btSupport.frame();
              btContact.frame();
          }
          pInfo = pInfo - pInfo/6;
      } else {
    
      background(#ffcc00);
      
      for(int i=0; i<numOfArms; i++) {
        angle[i] = angle[i] + angleSpeed[i];
      }
      
      targetX = mouseX;
      float dx = targetX - x;
      float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
      airX += easing;
      x += dx * easing + nX*10.2;
      
      targetY = mouseY;
      float dy = targetY - y;
      float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
      airY += easing;  
      y += dy * easing + nY*10.2;
      
      btInfo.frame();
      body = new Tbody(x, y, noise(pi/500)*((x*y)/8000));
       
      //+ noise(pi/10)*2)
      
      pi++;
      


      
     } 
}

void mouseReleased() {
   btClose.overButton = false;
   btInfo.overButton = false;
   btSupport.overButton = false;
   btContact.overButton = false;
}

void mousePressed() {
  if (btInfo.overButton) {
     infoShow = true;
     println("info " + infoShow);  
  }
  if (btClose.overButton) {
     pInfo = 480;    
     infoShow = false;
     println("close " + infoShow);
  }
  if (btSupport.overButton) { 
     link("http://spincles.dekwilde.com.br/support", "_new");  
  }
  if (btContact.overButton) {
     link("mailto:spincles@dekwilde.com.br", "_new"); 
  }
  
} 


class ButtonLink {
    boolean overButton = false;
    int pX;
    int pY;
    int Width;
    int Height;   
    
    ButtonLink(int x, int y, int W, int H) {  
      pX = x;
      pY = y;
      Width = W;
      Height = H;
    }    
    void frame() {
        checkButton(); 
        //fill(255);
        //rect(pX, pY, Width, Height);
    }
    void checkButton() {
          if (mouseX > pX-Width && mouseX < pX+Width && mouseY > pY-Height && mouseY < pY+Height) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}


class ButtonInfo {
    boolean overButton = false;
    int pX = 300;
    int pY = 460;   
    
    ButtonInfo() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }    
    void frame() {
        checkButton();
          // Left buttom
        if (overButton == true) {
          // circulo
          noStroke();
          fill(0);
          ellipse(pX, pY, 16, 16);
          
          // o "i"
          noStroke();
          fill(#ffcc00);
          rect(pX, pY+2, 1, 4);
          
          //ping do i
          noStroke();
          fill(#ffcc00);
          ellipse(pX, pY-4, 2, 2);
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();
          ellipse(pX, pY, 16, 16);
          
          // o "i"
          noStroke();
          fill(0);
          rect(pX, pY+2, 1, 4);
          
          //ping do i
          noStroke();
          fill(0);
          ellipse(pX, pY-4, 2, 2);
        }
    }
    void checkButton() {
          if (mouseX > pX-8 && mouseX < pX+8 && mouseY > pY-8 && mouseY < pY+8) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}







class ButtonClose {
    boolean overButton = false;
    int pX = 285;
    int pY = 25;
    int dm = 15; 
    
    ButtonClose() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }
    
    void frame() {
        checkButton();
              // Left buttom
        if (overButton == true) {
          // o "X"
          stroke(#ffcc00);          
        } else {
          // o "X"
          stroke(255);
        }
        strokeWeight(1);
        noFill();
        line(pX-dm, pY-dm, pX+dm, pY+dm);
        line(pX-dm, pY+dm, pX+dm, pY-dm);
    } 
    
    
    void checkButton() {
          if (mouseX > pX-dm && mouseX < pX+dm && mouseY > pY-dm && mouseY < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}






///////////////////////////////////////////////////////////
class Tbody {
  Arm arms;  
  
  Tbody(float x, float y, float rotator) {

    stroke(0, 100);
    translate(x, y);
    rotate(rotator);
    //
    for(int i=0; i<numOfArms; i++) {
      radius = angleRadius[i] * sin(angle[i]);
      arms = new Arm(radius, WeightSegment[i], segLength[i]);
      rotate(rotation[i]);
      
      //rotate(PI/(numOfArms/2));
      //rotate(random(PI));
    }
  }
}


class Arm {

  Arm(float angleSeg, float WeightSeg, float LengthSeg) {   
      pushMatrix();
      for(int i=0; i<numSegment; i++) {
        if(i>0) {
          segment(LengthSeg, 0, angleSeg*angleSegment[i], ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg);
        } else {
          segment(0, 0, angleSeg, (numSegment+1)*WeightSeg, LengthSeg); 
        }
      }
      popMatrix();
  }
  
  void segment(float x, float y, float a, float Weight, float LengthSeg) {
      translate(x, y);
      rotate(a);
      strokeWeight(Weight/SegWeightPor);
      line(0, 0, LengthSeg, 0);
  }
  
  
}
