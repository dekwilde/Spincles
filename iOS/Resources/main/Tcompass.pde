class Tcompass {  
  Tcompass() {
    mtrixel = new TrixelMatrix();
  }
  void draw(angleCompass) {
    pushMatrix();
    translate(width/2, height/2);
    float a = atan2(ball.x-height/2, ball.y-width/2);
    rotate(a);
    mtrixel.draw();
    popMatrix();
  }  
}
