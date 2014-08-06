class Tcompass {  
  TrixelMatrix trixelMtx;
  float pX = 0.0;
  float pY = 0.0;
  
  Tcompass() {
    trixelMtx = new TrixelMatrix();
  }
  void draw() {
    trixelX = targetX;
    trixelY = targetY;
    
    //pX = pX + (trixelX - pX)/(delaySpeedCompass/2);
    //pY = pY + (trixelY - pY)/(delaySpeedCompass/2);

    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(trixelY-height/2, trixelX-width/2);
    rotate(a);
    trixelMtx.draw();
    popMatrix();
  }  
}
