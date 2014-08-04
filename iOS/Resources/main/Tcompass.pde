class Tcompass {  
  TrixelMatrix trixelMtx;
  
  Tcompass() {
    trixelMtx = new TrixelMatrix();
  }
  void draw(angleCompass) {
    trixelX = targetX;
    trixelY = targetY;
    
    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(trixelY-height/2, trixelX-width/2);
    rotate(a);
    trixelMtx.draw();
    popMatrix();
  }  
}
