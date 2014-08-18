class ButtonStart {
    boolean overButton = false;
    
    int pX = width/2;
    int pY = height/2;
    int dw = 40;
    int dh = 20;
    
    ButtonStart() {  
      
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
        textAlign(CENTER);
        text("Start 17", pX, pY);
        
        if (overButton == true) {
           overButton = false;
           startGame();
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
