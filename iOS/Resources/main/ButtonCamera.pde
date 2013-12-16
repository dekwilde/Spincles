class ButtonCamera {
    boolean overButton = false;
    int pX = 20;
    int pY = 460;
    int dm = 12;   
    
    ButtonCamera() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }    
    void frame() {
        checkButton();
          // Left buttom
        if (overButton == true) {
          cameraShow = true;
          println("camera " + cameraShow);
          iphone.squareCamera();
          
          // circulo          
          noStroke();
          fill(255);
          rect(pX, pY, 8, 8);
          
          
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();
          rect(pX, pY, 8, 8);
          
        }
    }
    void checkButton() {
          if (touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}

