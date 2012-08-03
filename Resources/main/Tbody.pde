class Tbody {
  
  Arm arms;  
   
  Tbody(float x, float y, float rotator, float escala) {

    stroke((0 + microfone*15), 80); 
    translate(x, y);
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
