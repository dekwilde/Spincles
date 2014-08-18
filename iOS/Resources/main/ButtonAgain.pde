class ButtonAgain {
    boolean overButton = false;
    
    int pX = width/2;
    int pY = height/2;
    int dw = 60;
    int dh = 15;
    
    ButtonAgain() {
        smooth();
    }
    
    void draw() {
        checkButton();
              // Left buttom
        if (overButton == true) {
          stroke(#ffcc00);          
        } else {
          stroke(255);
        }
        fill(0);
        rect(pX, pY, dw, dh);
        fill(255);
        textFont(fontText, 14);
        textAlign(CENTER);
        text("Try Again", pX, pY);
        
        if (overButton == true) {
            overButton = false;
            resetGame();
        }
    } 
    
    
    void checkButton() {
          if (touch1X > pX-dw && touch1X < pX+dw && touch1Y > pY-dh && touch1Y < pY+dh) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}
