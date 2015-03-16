void pebug(String m) {
  //println(m);
}



void hurt() {
  energy = energy - hurtLife;
  soundEnemy.play();
  gameTransions = "Static";
  hurtRange += hurtValue;
  spinclesState();
  pebug("energy " + energy);
}

void clawTouchStart() {
  soundTouchTimer.volume(hurtTimer/100);
  
  if(hurtTimer<1) {
    soundTouchTimer.play();
    soundTouchTimer.loop(true);
  }
  
  hurtTimer += 4;
    
  
  //pebug("hurt " + hurtTimer);
  if(hurtTimer>100) {
    bover = false;
    locked = true;
    energy = energy - 2;
    soundGlitch.play();
    hurtRange += hurtValue;
    //hurt();
    //trixBAD.num = 0;
  }
  if(hurtTimer>120) {
    gameState = "NoTouch";
  }
}

void clawTouchStop() {
  
  hurtTimer -= 1;
  soundTouchTimer.volume(hurtTimer/100);
  if(hurtTimer<0) {
    hurtTimer = 0;
    soundTouchTimer.stop();
  }
  //pebug("hurt " + hurtTimer);
}

void drawBG() {
  colorR = 255; 
  colorG = 204; 
  colorB = 0;   
  
  tweenBG += (hurtRange*10 - tweenBG/4)/10;
  
  if(tweenBG>255) {
    alphaBG = 255;  
  } else {
    alphaBG = round(tweenBG); 
  }
 
  //pebug("alphaBG: " + alphaBG);  

  if (alphaBG>128) {
    effect = true;
    ctx.rect(0,0,width,height);
    //background(colorR, colorG, colorB, alphaBG);
    fill(colorR, colorG, colorB, 255-alphaBG);
    noStroke();        
    rect(0,0,width,height);
  } else {
    effect = false;
    background(colorR, colorG, colorB, alphaBG*2);
    fill(colorR, colorG, colorB, 204);
    noStroke();        
    rect(0,0,width,height);  
  }

  
}



void activeGame() {
  trixelmatrix.reset();
}


void startGame() {
    isGame = true;
    gameTransions = "Flash";
    //setTimeout(function() { gameDialog = "Find"; }, 20000);
    loadScore();
    resetGame();
}
void resetGame() {
  energy = 30;
  score = 0;
  hurtRange = 0;
  hurtTimer = 0;
  gameState = "Game";
  //gameTransions = "Flash";
  gameSound = "Game";
  gameDialog = "Start";
}


void gameOver() {
  setScore();
  activeGame();
  gameTransions = "Static";
  gameState = "Over";
  gameEnemy = "Null";
 
}

void share() {
  socialShare("My new record is " + recordScore  + ". Can you score it on the Spincles Game?", "Spincles - Glitch Game", save(), "http://spincles.dekwilde.com.br");
  gameState = "InfoShow";
  
}


