class ButtonStart {
 
    boolean overButton = false;
    
    int pX, pY;
    int dw = 160;
    int dh = 40;
    int fSize = 20;
    
    ButtonStart() {
        //
    }
    
    void draw() {
        pX = width/2;
        pY = height/2+150;
      
        checkButton();
        // Left buttom
        strokeWeight(1);
        stroke(0);
        fill(255,204,0);
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(0);  
        if (overButton == true) {
          stroke(255);
          fill(0);
          rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
          fill(255);
          pInfo = 3;
          gameState = "LoadGame"; 
          overButton = false;
          soundClick.play();   
        }
        textFont(fontText, fSize);
        text("START", pX, pY);
    } 
    
    
    void checkButton() {
          if (touch1X > pX-dw && touch1X < pX+dw && touch1Y > pY-dh && touch1Y < pY+dh) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
  
}


class ButtonClose {
    boolean overButton = false;
    int pX, pY;
    int dm = 15; 
    
    ButtonClose() {  
      
    }
    
    void draw(int c) {
        pX = width - 30;
        pY = 30;
      
        checkButton();
              // Left buttom
        if (overButton == true) {          
          // o "X"
          stroke(255,034,0);          
        } else {
          // o "X"
          stroke(c);
        }
        strokeWeight(1);
        line(pX-dm, pY-dm, pX+dm, pY+dm);
        line(pX-dm, pY+dm, pX+dm, pY-dm);
        
        if (overButton == true) {
           background(0);
           soundClick.play();
           if(isGame) {
             gameState = "GameLevel";
           } else {
             gameState = "Start";
           }
           pebug("close");
        }
    } 
    
    void checkButton() {
          if (touch1X > pX-dm*4 && touch1X < pX+dm*4 && touch1Y > pY-dm*4 && touch1Y < pY+dm*4) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}

class MenuSlider {
    float st_x = width/2;
    float st_y = height/2 -120;
    int st_s = 30;
    float st_difx = 0.0; 
    float st_dify = 0.0; 
    float init, end;
        
    MenuSlider() {  
    }
    
    void draw() {
      init = width/2 - 160 + 35;
      end = width/2 - 160 + 285;
      st_y = height/2 -120;
      
      // Draw the button
      if (st_x>end) {
        st_x = end;
      }
      if (st_x<init) {
        st_x = init;
      }     
      mic_perc = (st_x-init) / ((end-init)/100);
      //pebug(perc);
      
      if(mic_perc<2) {
        micStop();  
      } else {
        micStart();
      }
      
      if (touch1X > init-(st_s*1.5) && touch1X < end+(st_s*1.5) && 
        touch1Y > st_y-(st_s*1.5) && touch1Y < st_y+(st_s*1.5)) {
           st_x = touch1X;  
           soundClick.play();
           touch1X = 0;
           touch1Y = 0;
         } else {
           st_x = st_x;
      } 
      
      
      stroke(255,204,0);
      fill(0);
      line(init, st_y, end, st_y);
      ellipse(st_x, st_y, st_s, st_s);
      
    }
} // end class

class ButtonAgain {
    boolean overButton = false;
    
    int pX, pY;
    int dw = 160;
    int dh = 40;
    int fSize = 20;
    
    ButtonAgain() {
        //
    }
    
    void draw() {
        pX = width/2;
        pY = height/2+200;
      
        checkButton();
        // Left buttom
        strokeWeight(1);
        if (overButton == true) {
          stroke(255,204,0);          
        } else {
          stroke(255);
        }
        fill(0);
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(255,204,0);
        textFont(fontText, fSize);
        text("TRY AGAIN", pX, pY);
        
        if (overButton == true) {
            overButton = false;
            soundClick.play();
            againGame();
            //activeGame();   
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

class ButtonHow {
    boolean overButton = false;
    
    int pX,pY;
    int dw = 200;
    int dh = 40;
    int fSize = 20;
    
    ButtonHow() {
      //
    }
    
    void draw(int t) {
        pX = width/2;
        pY = height/2+t;
      
        checkButton();
        // Left buttom
        strokeWeight(1);
        stroke(255,204,0);
        fill(0);
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(255,204,0);
        textFont(fontText, fSize);
        text("How to Play", pX, pY);
        
        if (overButton == true) {
            pInfo = 480;
            overButton = false;
            soundClick.play();
            gameState  = "How";
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


class ButtonClear {
    boolean overButton = false;
    
    int pX,pY;
    int dw = 200;
    int dh = 40;
    int fSize = 20;
    
    ButtonClear() {
      //
    }
    
    void draw() {
      
        pX = width/2;
        pY = height/2+160;
      
        checkButton();
        // Left buttom
        strokeWeight(1);
        stroke(255,204,0);
        fill(0);
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(255,204,0);
        textFont(fontText, fSize);
        text("clear record", pX, pY);
        
        if (overButton == true) {
            clearScore();
            overButton = false;
            soundClick.play();
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

class ButtonLeaderBoard {
    boolean overButton = false;
    
    int pX,pY;
    int dw = 200;
    int dh = 40;
    int fSize = 20;
    
    ButtonLeaderBoard() {
      //
    }
    
    void draw() {
      
        pX = width/2;
        pY = height/2+110;
      
        checkButton();
        // Left buttom
        strokeWeight(1);
        stroke(255,204,0);
        fill(0);
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(255,204,0);
        textFont(fontText, fSize);
        text("leaderboard", pX, pY);
        
        if (overButton == true) {
            overButton = false;
            touch1X = 0;
            touch1Y = 0;
            soundClick.play();
            showGameCenter();
            stateLoad("InfoShow");
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

class ButtonShare {
    boolean overButton = false;
    
    int pX, pY;
    int dw = 200;
    int dh = 40;
    int fSize = 20;
    
    ButtonShare() {
      //
    }
    
    void draw() {

        pX = width/2;
        pY = height/2+210;
      
        if (overButton == true) {
          fill(255,204,0);
        } else {
          fill(0); 
        }
        strokeWeight(1);
        stroke(255,204,0);  
        rect(pX-dw/2, pY-dh/2-fSize/4, dw, dh);
        fill(255);
        textFont(fontText, fSize);
        text("share", pX, pY);

        if (overButton == true) {
          overButton = false;
          pInfo = 480;
          load = 0;
          touch1X = 0;
          touch1Y = 0;
          soundClick.play();
          stateLoad("Share");
        }

        checkButton();
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
    int pX,pY;

    
    ButtonInfo() {  
    }    
    void draw() {
      
        pX = width - dm - 10;
        pY = height - dm - 10;
      
        checkButton();
        strokeWeight(1);
        if (overButton == true) {
          pInfo = 480;
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
        textAlign(CENTER);
        text("||", pX+dm/2-9, pY+dm/2-5);
    }
    void checkButton() {
          if (touch1X > pX-dm && touch1X < pX+dm && touch1Y > pY-dm && touch1Y < pY+dm) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}






