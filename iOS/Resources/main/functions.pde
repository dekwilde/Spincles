void pebug(String m) {
  println(m);
}



void hurt() {
  //
}

void clawTouchStart() {
  soundTouchTimer.setVolume(hurtTimer/100);
  
  if(hurtTimer<1) {
    soundTouchTimer.play();
    soundTouchTimer.loop();
  }
  
  hurtTimer += 4;
    
  
  //pebug("hurt " + hurtTimer);
  if(hurtTimer>100) {
    bover = false;
    locked = true;
    energy = energy - 2;
    soundGlitch.play();
    hurtRange = hurtValue;
    //hurt();
    //trixBAD.num = 0;
  }
  if(hurtTimer>120) {
    gameState = "NoTouch";
  }
}

void clawTouchStop() {
  
  hurtTimer -= 1;
  soundTouchTimer.setVolume(hurtTimer/100);
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
    fill(colorR, colorG, colorB, 128);
    noStroke();        
    rect(0,0,width,height);  
  }

  
}

void initGame() {
  gameSound = "Start";
  //gameTransions = "Flash";
  trixelmatrix.reset();
}


void startGame() {
    isGame = true;
    loadScore();
    resetGame();
}
void resetGame() {
  energy = 30;
  score = 0;
  hurtRange = 0;
  hurtTimer = 0;
  gameState = "Game";
  gameTransions = "Flash";
  gameSound = "Game";
  gameDialog = "Start";
  pebug(gameState);
}


void gameOver() {
  setScore();
  gameTransions = "Static";
  gameState = "Over";
 
}

void gameWin() {
  //
}


void stateStart() {
  background(255,204,0);
  /*
  ctx.rect(0,0,width,height);
  fill(255,204,0,20);
  noStroke();        
  rect(0,0,width,height);
  */

  
  int Talign = -160;
  fill(0);
  textFont(fontTitle, 10);
  text("Welcome to", width/2, height/2-40+Talign); 

  pushMatrix();
  float logoscale = 0.3;
  translate(width/2-(500*logoscale), height/2-(200*logoscale)+20+Talign); // a logo tem o tamanho original com 1000x400
  scale(logoscale);
  logo.draw();
  popMatrix();
  
  acce();
  compass();
  
  control.draw(); 
  btStart.draw();
  

  
}

void stateOver() {
  int Talign = 0;
  initColorAlpha = initColorAlpha + (255 - initColorAlpha)/20;
  background(255, 204, 0, initColorAlpha);
  fill(0);
  
  textAlign(CENTER);
  textFont(fontTitle, 40);
  text("GAME", width/2, 80+Talign);
  textFont(fontTitle, 48);
  text("OVER", width/2, 160+Talign);
  
  textFont(fontText);
  textSize(16);
  text("score", width/2, 200+Talign);
  textSize(36);
  text(score, width/2, 230+Talign);
  textSize(16);
  text(scoreResult, width/2, 270+Talign);
  textSize(36);
  text(recordScore, width/2, 300+Talign);
  textSize(16);
  text("level", width/2, 340+Talign);
  textSize(36);
  text(level, width/2, 370+Talign);
  
  btAgain.draw();
}


void stateInfoShow() {
  int Talign = height/2-260+pInfo;
  
  noStroke();
  fill(0, 0, 0, 20);
  rect(0,0,width,height+pInfo);
  fill(255);
  textAlign(CENTER);
  textFont(fontTitle, 20);
  text("PAUSED", width/2, 70+Talign);
  textFont(fontText);
  textSize(16);
  text("MIC VOLUME", width/2, 110+Talign);
  text(scoreResult, width/2, 200+Talign); //200
  textSize(36);
  text(recordScore, width/2, 230+Talign); //230
  textSize(16);
  text("level", width/2, 250+Talign); //250
  textSize(36);
  text(level, width/2, 280+Talign); //280
  
  
  if (pInfo<1) {
      pInfo = 0;
      slider.draw();
      btClose.draw(255);
      btHow.draw();
      btClear.draw();
  }
  pInfo = pInfo - pInfo/6;
  

  

  
}

void stateHow() {
  int Talign = height/2-260+pInfo;
  noStroke();
  fill(0, 20);
  rect(0,0,width,height);
  image(howImg, width/2, pInfo+height/2, width, height);
  fill(255);
  textAlign(CENTER);
  textFont(fontTitle, 20);
  text("HOW TO PLAY", width/2, 70+Talign);
  //tint(20);
  if (pInfo<1) {
      pInfo = 0;
      btClose.draw(255);
  }
  pInfo = pInfo - pInfo/6;
  soundTouchTimer.setVolume(0);
}


void stateLoadGame() {
  fill(255,204,0);
  noStroke();
  rect(0,0,width,height);
  fill(0);
  textAlign(CENTER);
  textFont(fontText, 16);
  text("LOADING", width/2, height/2-8);
  
  if (pInfo<1) {
    startGame();
  }
  pInfo += - 1;
}

void stateGame() {
  acce();
  mic();
  compass();
  drawBG();
  //Three();        
  control.draw();  
  trixelmatrix.draw();
  //trixBAD.draw();
  //trixGOOD.draw();
  btInfo.draw();
  //btCamera.draw();
  scoreInfo.draw();
  spinclesDraw();
}

void stateNoTouch() {
  int Talign = -10;
  rotate(0);
  translate(0,0);
  scale(1.0);
  background(255, 204, 0);
  
  tEff.draw1(); 
  fill(0);
  textAlign(CENTER);
  textFont(fontTitle, 50);
  text("DONT", width/2, height/2-80-Talign);
  textFont(fontTitle, 40);
  text("TOUCH", width/2, height/2-Talign);
  
  textFont(fontText, 12);
  fill(0);
  text("Tilt the device", width/2, height/2+60-Talign);
  text("to move", width/2, height/2+80-Talign);
  
  btClose.draw(0);
  btHow.draw();
}
