class Tbody {
  float x, y;  
  Arm arms;  
   
  Tbody(float posX, float posY, float rotator, float escala) {
    x = posX;
    y = posY;
    stroke((0 + microfone*15), 80); 
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
    
  }
}


class Arm {

  Arm(float angleSeg, float WeightSeg, float LengthSeg) {   
      pushMatrix();
      for(int i=0; i<numSegment; i++) {
        if(i>0) {
          segment(LengthSeg, 0, angleSeg*angleSegment[i]+(microfone/50)+angleRadiusTouch, ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg);
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


function spinclesDraw() {
  ///////////////////////////////////////////////// Spincles draw /////////////////////////////////////////////////////////
  
  for(int i=0; i<numOfArms; i++) {
    angle[i] = angle[i] + angleSpeed[i] + microfone/250 + angleSpeedTouch;
  }
  
  //targetX = mouseX;
  targetX = ball.x;
  float dx = targetX - x;
  float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
  x += dx * easing + nX*(microfone/3 + 5.2);
  spinX = x;
  
  //targetY = mouseY;
  targetY = ball.y;
  float dy = targetY - y;
  float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
  y += dy * easing + nY*(microfone/3 + 5.2);
  spinY = y;

  //location();
  //pointCompass();
  //angleCompass = targetDEGREE - compassDEGREE;
  angleCompass = compassDEGREE + gestureRotation;

  //println("angleCompass: " + angleCompass);
          
  rotationT = noise(pi/500)*((dx*dy*easing)/450) + radians(iAngle) + microfone/40;
  
  body = new Tbody(x, y, rotationT, iScale);
  //+ noise(pi/10)*2)
  
  pi++;
}

