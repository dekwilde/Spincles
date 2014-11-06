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
        textFont(fontText, 14);
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
          
          textFont(fontText, 20);
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
          textFont(fontText, 20);
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



class ButtonClose {
    boolean overButton = false;
    int pX = 285;
    int pY = 25;
    int dm = 15; 
    
    ButtonClose() {  
      
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
        strokeWeight(1);
        noFill();
        line(pX-dm, pY-dm, pX+dm, pY+dm);
        line(pX-dm, pY+dm, pX+dm, pY-dm);
        
        if (overButton == true) {
           background(0);
           pInfo = 480;    
           gameState = "Game";
           println("close");
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





class ButtonCamera {
    boolean overButton = false;
    boolean pressButton = false;
    int dm = 20;
    int pX = 20;
    int pY = height -dm - 20; 
    
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


