class Tcompass {  
  TrixelMatrix trixelMtx;
  
  
  
  Tcompass() {
    trixelMtx = new TrixelMatrix();
  }
  void draw(angleCompass) {
    trixelX = ball.x;
    trixelY = ball.y;
    
    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(trixelX-height/2, trixelY-width/2);
    rotate(a);
    trixelMtx.draw();
    popMatrix();
  }  
}
