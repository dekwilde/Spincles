class Tcompass {  
  Tcompass() {
    smooth();

  }
  void frame(angleCompass) {
    pushMatrix();
    translate(160, 240); 
    rotate(radians(angleCompass));
    
    //println(angleCompass);
    noFill();
    stroke(0);
    ellipse(0, 0, 250, 250);
    fill(0);
    ellipse(-125, 0, 15, 15);
    popMatrix();
  }  
}
