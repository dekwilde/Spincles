class ButtonInfo {
    boolean overButton = false;
    int pX = 300;
    int pY = 460;
    int dm = 12;   
    
    ButtonInfo() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }    
    void frame() {
        checkButton();
          // Left buttom
        if (overButton == true) {
          infoShow = true;
          println("info " + infoShow);
          iphone.openCamera();   
          // circulo          
          noStroke();
          fill(0);
          ellipse(pX, pY, 16, 16);
          
          // o "i"
          noStroke();
          fill(#ffcc00);
          rect(pX, pY+2, 1, 4);
          
          //ping do i
          noStroke();
          fill(#ffcc00);
          ellipse(pX, pY-4, 2, 2);
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();
          ellipse(pX, pY, 16, 16);
          
          // o "i"
          noStroke();
          fill(0);
          rect(pX, pY+2, 1, 4);
          
          //ping do i
          noStroke();
          fill(0);
          ellipse(pX, pY-4, 2, 2);
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

