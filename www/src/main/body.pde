class Tbody {
 
  int pi = 0;
  float x, y;
  Arm arms;
  Tbody() {
    reset();  
  }
  
  void reset() {
    for(int i=0; i<numOfArms; i++) {
      rotation[i] = random(0, 360);
      angleRadius[i] = random(0.3, 1.9);
      angleSpeed[i] = random(0.009, 0.16);
      angleSegment[i] = random(0.09, 1.4);
      WeightSegment[i] = random(1.4, 6.1);
      segLength[i] = random(25, 65);
    }
  }

  
  
  
  void draw() {
        
    for(int i=0; i<numOfArms; i++) {
      angle[i] = angle[i] + angleSpeed[i] + microfone/100 + angleSpeedTouch;
    }
    
    //targetX = mouseX;
    targetX = control.x;
    float nX = noise(pi/10)*cos(noise(pi/10)*((width/2 - noise(pi/50)*(width))/10));
    x += (targetX - x) * easing + nX*(microfone + random(0,5));
    spinX = x;
    
    //targetY = mouseY;
    targetY = control.y;
    float nY = noise(pi/10)*sin(noise(pi/10)*((height/2 - noise(pi/50)*(height))/10));
    y += (targetY - y) * easing + nY*(microfone + random(0,5));
    spinY = y;
            
    PVector  v1 = new PVector(targetX, targetY);
    PVector  v2 = new PVector(x, y); 
    float d = v1.dist(v2);
    
    rotationT = rotationT + cos(pi/(100-microfone))*0.1 - sin((d*easing)/100);
    
    pushMatrix();
    translate(x, y);
    rotate(rotationT);
    scale(iScale);
    //display pebug
    //fill(255,0,0);
    //rect(0,0,50,50);
    
    for(int i=0; i<numOfArms; i++) {   
      radius = angleRadius[i] * sin(angle[i]);
      arms = new Arm(radius, WeightSegment[i]+WeightSegmentTouch, segLength[i], i);
      rotate(radians(rotation[i]));
    }
    
    popMatrix();
    
    
    pi++;
  }

}


class Arm {
  Trix trix = new Trix(50);
  Arm(float angleSeg, float WeightSeg, float LengthSeg, int ArmNum) {   
      pushMatrix();
            
      for(int i=0; i<numSegment; i++) {
        if(i>0) {          
          draw(LengthSeg, 0, angleSeg*angleSegment[i]-(microfone/50)+angleRadiusTouch, ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg, i, ArmNum);
        } else {
          draw(0, 0,         angleSeg*angleSegment[i]-(microfone/50)+angleRadiusTouch, ((numSegment+1)*WeightSeg)-i*WeightSeg, LengthSeg, i, ArmNum); 
        }
      }
      popMatrix();
  }
  
  void draw(float x, float y, float a, float Weight, float LengthSeg, int SegNum, int ArmNum) {
      translate(x, y);
      rotate(a);
      strokeWeight(Weight/SegWeightPor);
      stroke(0, 90);
      line(0, 0, LengthSeg, 0);
      
      noStroke();
      //pebug("contains " + contains(infectArm, ArmNum));
      if(contains(infectArm, ArmNum) && SegNum == infectSegment[contains(infectArm, ArmNum)]) {
        fill(0);
        triangle(trix.x1, trix.y1, trix.x2, trix.y2, trix.x3, trix.y3);  
      }
      fill(255);
      ellipse(0,0,2,2);
      
  } 
}



