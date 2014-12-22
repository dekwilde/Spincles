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
          draw(LengthSeg, 0, angleSeg*angleSegment[i]-(microfone/20)+angleRadiusTouch, ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg);
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
      stroke(blowMic, 80);
      line(0, 0, LengthSeg, 0);
  } 
}


function spinclesDraw() {
  ///////////////////////////////////////////////// Spincles draw /////////////////////////////////////////////////////////
  
  for(int i=0; i<numOfArms; i++) {
    angle[i] = angle[i] + angleSpeed[i] + microfone/250 + angleSpeedTouch;
  }
  
  //targetX = mouseX;
  targetX = chain.x;
  float dx = targetX - x;
  float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
  x += dx * easing + nX*(microfone/2 + 5.2);
  spinX = x;
  
  //targetY = mouseY;
  targetY = chain.y;
  float dy = targetY - y;
  float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
  y += dy * easing + nY*(microfone/2 + 5.2);
  spinY = y;
          
  PVector  v1 = new PVector(targetX, targetY);
  PVector  v2 = new PVector(x, y); 
  float d = v1.dist(v2);
  
  rotationT = rotationT + noise(pi/500)*((d*easing)/50) - microfone/200;
  
  body = new Tbody(x, y, rotationT, iScale);
  //+ noise(pi/10)*2)
  
  pi++;
}
