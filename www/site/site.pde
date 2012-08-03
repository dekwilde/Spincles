Tbody body;


int numSegment = 4;
int numOfArms = 13;
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
float angleSpeedTouch = 0.0f;
float angleRadiusTouch = 0.0f;
float WeightSegmentTouch = 0.0f;

void setup() {
  size(screenWidth, screenHeight);
  //size(320, 480);
  frameRate(30);
  //smooth(); 
  stroke(0, 100);
  
  for(int i=0; i<numOfArms; i++) {
    rotation[i] = random(0, 360);
    angleRadius[i] = random(0.4, 1.3);
    angleSpeed[i] = random(0.02, 0.14);
    angleSegment[i] = random(0.09, 1.6);
    WeightSegment[i] = random(1.4, 6.3);
    segLength[i] = random(30, 70);
  } 
  
}


void mousePressed() {
  //angleSpeedTouch = angleSpeedTouch + 0.4;
}

void mouseReleased() {
  angleSpeedTouch =  random(0.02, 0.14);
  angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
  WeightSegmentTouch =  random(4.0, 10.0);
  //angleIntensity = angleIntensity / 1.2;
}

void draw() {
  background(#ffcc00);
  
  
  if (mousePressed == true) {
    //angleIntensity = angleIntensity + 0.08;
  } else {
    angleSpeedTouch = angleSpeedTouch / 1.02;
    angleRadiusTouch = angleRadiusTouch / 1.008;
    WeightSegmentTouch = WeightSegmentTouch / 1.08;
  }
  
  
  
  for(int i=0; i<numOfArms; i++) {
    angle[i] = angle[i] + angleSpeed[i] - angleSpeedTouch;
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
  
  body = new Tbody(x, y, noise(pi/500)*((dx*dy*easing)/1000));
  //+ noise(pi/10)*2)
  
  pi++;
  
}






///////////////////////////////////////////////////////////
class Tbody {
  Arm arms;  
   
  Tbody(float x, float y, float rotator) {

    
    translate(x, y);
    rotate(rotator);
    scale(2.3);
    //
    for(int i=0; i<numOfArms; i++) {
      radius = angleRadius[i] * sin(angle[i]) + angleRadiusTouch;
      arms = new Arm(radius, WeightSegment[i]+WeightSegmentTouch, segLength[i]);
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
