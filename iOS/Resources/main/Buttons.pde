class MenuSlider {
    float st_x;
    float st_y;
    int st_s = 30;
    float st_difx = 0.0; 
    float st_dify = 0.0; 
    float init = width/2 - 160 + 35;
    float end = width/2 - 160 + 285;
    
    
    MenuSlider() {  
      st_x = 160;
      st_y = height/2 -240 + 100;
    }
    
    void draw() {
      //Draw Line
      line(init, st_y, end, st_y);
      
      // Draw the button
      if (st_x>end) {
        st_x = end;
      }
      if (st_x<init) {
        st_x = init;
      }
      fill(0);
      ellipse(st_x, st_y, st_s, st_s);

      
      mic_perc = (st_x-init) / ((end-init)/100);
      
      //pebug(perc);
      
      
      if (touch1X > st_x-(st_s*1.6) && touch1X < st_x+(st_s*1.6) && 
        touch1Y > st_y-(st_s*1.6) && touch1Y < st_y+(st_s*1.6)) {
           st_x = touch1X;
           soundClick.play();
         } else {
           st_x = st_x;
      }
      
    }
    
 
    
} // end class




class ButtonAgain {
    boolean overButton = false;
    
    int pX = width/2;
    int pY = height/2+200;
    int dw = 160;
    int dh = 40;
    int fSize = 20;
    
    ButtonAgain() {
        smooth();
    }
    
    void draw() {
        checkButton();
        // Left buttom
        strokeWeight(1);
        if (overButton == true) {
          stroke(255,204,0);          
        } else {
          stroke(255);
        }
        noFill();
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(0);
        textFont(fontText, fSize);
        text("TRY AGAIN", pX, pY);
        
        if (overButton == true) {
            overButton = false;
            soundClick.play();
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
    int pY = height/2+160;
    int dw = 120;
    int dh = 40;
    int fSize = 20;
    
    ButtonStart() {  
      
    }
    
    void draw() {
        checkButton();
        strokeWeight(1);
        // Left buttom
        if (overButton == true) {
          stroke(#ffcc00);          
        } else {
          stroke(0);
        }
        noFill();
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill();
        textFont(fontText, fSize);
        text("PLAY", pX, pY);
        
        if (overButton == true) {
           overButton = false;
           soundClick.play();
           gameState = "Intro"; 
           gameSound = "Start"; 
           gameTransions = "Flash";
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
        strokeWeight(1);
        if (overButton == true) {
          gameState = "InfoShow";
          soundClick.play();
          // circulo          
          noStroke();
          fill(0);
          fill(255);
        } else {
          // circulo
          stroke(0);
          noFill();
        }
        ellipse(pX, pY, dm, dm);
        
        fill(0);
        textFont(fontText, 16);
        text("*", pX+dm/2-3, pY+dm/2-5);
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
    int pX = width/2 - 160 + 285;
    int pY = height/2 - 240 + 25;
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
           soundClick.play();
           gameState = "Game";
           pebug("close");
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
          pebug("camera " + cameraShow);
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
