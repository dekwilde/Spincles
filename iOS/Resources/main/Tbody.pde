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
