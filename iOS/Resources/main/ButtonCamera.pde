class ButtonCamera {
    boolean overButton = false;
    boolean pressButton = false;
    int dm = 20;
    int pX = 20;
    int pY = height -dm - 20;
;   
    
    ButtonCamera() {  
        
    }    
    void draw() {
        checkButton();
          // Left buttom
        if (overButton) {
          pressButton = true;
          overButton = false;
          cameraShow = true;
          println("camera " + cameraShow);
          iphone.squareCamera();    
          noStroke();
          fill(255);
 
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();    
        }
        rect(pX, pY, dm, dm);
    }
    void checkButton() {   
          if (!pressButton && touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}

