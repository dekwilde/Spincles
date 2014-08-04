class ButtonStart {
    boolean overButton = false;
    
    int pX = width/2;
    int pY = height/2;
    int dw = 40;
    int dh = 10;
    
    ButtonStart() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }
    
    void draw() {
        checkButton();
              // Left buttom
        if (overButton == true) {          
          // o "X"
          stroke(#ffcc00);          
        } else {
          // o "X"
          stroke(255);
        }
        fill(0);
        rect(pX, pY, dw, dh);
        fill(255);
        text("Start 12   ", pX, pY);
        
        if (overButton == true) {
           background(#FFCC00);
           pInfo = 480;    
           gameState = "Game";
           println(gameState);
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
