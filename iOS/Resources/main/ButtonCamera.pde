class ButtonCamera {
    boolean overButton = false;
    boolean pressButton = false;
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
        if (overButton) {
          pressButton = true;
          overButton = false;
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
          if (!pressButton && touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}

