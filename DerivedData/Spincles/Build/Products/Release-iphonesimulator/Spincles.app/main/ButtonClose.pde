class ButtonClose {
    boolean overButton = false;
    int pX = 285;
    int pY = 25;
    int dm = 15; 
    
    ButtonClose() {  
        smooth();
        rectMode(CENTER_RADIUS);
    }
    
    void frame() {
        checkButton();
              // Left buttom
        if (overButton == true) {
           pInfo = 480;    
           infoShow = false;
           println("close " + infoShow);
          
          // o "X"
          stroke(#ffcc00);          
        } else {
          // o "X"
          stroke(255);
        }
        strokeWeight(1);
        noFill();
        line(pX-dm, pY-dm, pX+dm, pY+dm);
        line(pX-dm, pY+dm, pX+dm, pY-dm);
    } 
    
    
    void checkButton() {
          if (touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}
