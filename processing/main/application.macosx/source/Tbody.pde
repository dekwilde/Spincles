class Tbody {
  
  Arm arms;  
   
  Tbody(float x, float y, float rotator, float escala) {

    stroke(255, 255); 
    translate(x, y);
    rotate(rotator);
    scale(escala);
    //
    for(int i=0; i<numOfArms; i++) {
      radius = angleRadius[i] * sin(angle[i]);
      arms = new Arm(radius, WeightSegment[i]+WeightSegmentTouch, segLength[i]);
      rotate(rotation[i]);
    }
    
  }
}
