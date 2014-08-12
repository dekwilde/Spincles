class Tcompass {  
  TrixelMatrix trixelMtx;
  float pX = 0.0;
  float pY = 0.0;
  
  Tcompass() {
    trixelMtx = new TrixelMatrix();
  }
  void draw() {
    //trixelX += (spinX - trixelX)*easing;
    //trixelY += (spinY - trixelY)*easing;
    
    trixelX = spinX;
    trixelY = spinY;
    

    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(trixelY-height/2, trixelX-width/2);
    rotate(a);
    trixelMtx.draw();
    popMatrix();
  }  
}
