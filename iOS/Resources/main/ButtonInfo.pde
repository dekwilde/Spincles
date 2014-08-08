class ButtonInfo {
    boolean overButton = false;
    int dm = 20;   
    int pX = width - dm - 10;
    int pY = height - dm - 10;

    
    ButtonInfo() {  
    }    
    void draw() {
        checkButton();
          // Left buttom
        if (overButton == true) {
          gameState = "InfoShow";
          println("info");
          
          textAlign(CENTER);
          
          // circulo          
          noStroke();
          fill(0);
          ellipse(pX, pY, dm, dm);
          
          fill(255);
          text("i", pX, pY+dm/2);
          
        } else {
          // circulo
          stroke(0);
          strokeWeight(1);
          noFill();
          ellipse(pX, pY, dm, dm);
          
          fill(0);
          text("i", pX, pY+dm/2);
          

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
