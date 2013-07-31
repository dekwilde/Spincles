class Tcompass {  
  Tcompass() {
    smooth();

  }
  void frame(angleCompass) {
    pushMatrix();
    translate(160, 240); 
    rotate(radians(angleCompass));
    
    //println(angleCompass);
    rect(0, 0, 100, 5);
    ellipse(-100, 0, 15, 15);
    popMatrix(); 
  }  
}
