Tbody body;
ButtonInfo btInfo;


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


void setup() {
  //size(screenWidth, screenHeight);
  size(320, 480);
  frameRate(30);
  //smooth(); 
  stroke(0, 100);
  
  infoImg= loadImage("infos.jpg");
  
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
        image(infoImg, 0, 0);
        tint(255, 0.1);
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
      
      btInfo = new ButtonInfo();
      body = new Tbody(x, y, noise(pi/500)*((x*y)/8000));
       
      //+ noise(pi/10)*2)
      
      pi++;
  }
  
}
void mousePressed() {
  if (btInfo.overButton) { 
     infoShow = true;
  }
} 



class ButtonInfo {
    boolean overButton = false;
    int pX = 300;
    int pY = 460;   
    ButtonInfo() {  
        smooth();
        rectMode(CENTER_RADIUS);
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
