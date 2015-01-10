void pebug(String m) {
  println(m);
}

void gestureStarted() {
	startAngle = iAngle;
	startEscala = iScale;
}

void gestureChanged() {
	iAngle = startAngle + gestureRotation;
	iScale = startEscala * gestureScale;
	if (iAngle > 360) {
		iAngle = iAngle - 360;
	}
	if (iAngle < 0) {
		iAngle = 360 + iAngle;
	}
}

void gestureStopped() {
	startAngle = iAngle;
	startEscala = iScale;
}

void touch1Started() {
  //GEsture Drag Spincles
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
       bover = true;       
  } else {

    
  }
  
  if(bover) { 
    locked = true;
    
  } else {
    locked = false;
  }
  bdifx = touch1X-bx; 
  bdify = touch1Y-by; 
}

void touch1Moved() {
  if(locked) {
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }
}


void touch1Stopped() {  
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
         //hurt();
  }
  
  // click info var
  //btClose.overButton = false;
  //btInfo.overButton = false;
  //btSupport.overButton = false;
  //btContact.overButton = false;
  
  // gesture var
  //bover = false;
  locked = false;
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
  colorR = 255; // + microfone*20;
  colorG = 204; // + microfone*25;
  colorB = 0;   // + microfone*20;
   
   
  blowMic =  microfone*15;
  if(blowMic>255) {
    blowMic = 255;
  }
  
  //pebug(blowMic);
  
  tweenBG += (hurtRange*10 - tweenBG/4)/10;
  
  if(tweenBG>255) {
    alphaBG = 255;  
  } else {
    alphaBG = round(tweenBG); 
  }
 
  //pebug("alphaBG: " + alphaBG);  

  if (alphaBG>128) {
    ctx.rect(0,0,width,height);
    //background(colorR, colorG, colorB, alphaBG);
    fill(colorR, colorG, colorB, 255-alphaBG);
    noStroke();        
    rect(0,0,width,height);
  } else {
    background(colorR, colorG, colorB, alphaBG*2);
    fill(colorR, colorG, colorB, 128);
    noStroke();        
    rect(0,0,width,height);  
  }

  
}


void startGame() {
    
    loadScore();
    
    iphone.startMicMonitor();
    iphone.startAccelerometer();
    iphone.startCompass();
    //iphone.startLocation();
    //iphone.squareCamera();
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
  
  fill(0);
  textFont(fontTitle, 10);
  text("Welcome to", width/2, height/2-50); 

  pushMatrix();
  translate(width/2-(500*0.3), height/2-(200*0.3)+20); // a logo tem o tamanho original com 1000x400
  scale(0.3);
  logo.draw();
  popMatrix();
  
  textFont(fontText, 10);
  fill(0);
  text("headphone required", width/2, height/2-170-initPosY);
  
  // headhpone
  pushMatrix();
  noFill();
  strokeWeight(3);
  translate(width/2, height/2-140-initPosY);
  scale(0.4);
  rotate(-QUARTER_PI/2+PI);
  arc(0, 0, 80, 80, 0, PI+QUARTER_PI, OPEN);
  
  rotate(+QUARTER_PI/2-PI);
  fill(0);
  strokeWeight(3);
  ellipse(25,15,15,30);
  ellipse(-25,15,15,30);
  
  ellipse(33,15,10,10);
  ellipse(-33,15,10,10);
  popMatrix();
  
  
  
  if(gameTransions == "Null") {
    initPosY = initPosY + (0 - initPosY)/10;
    pushMatrix();
    translate(0, initPosY);
    btStart.draw();
    popMatrix();
  }
  
  

  
  
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
  fill(0, 0, 0, 20);
  rect(0,0,width,height);
  //tint(20);
  if (pInfo<1) {
      pInfo = 0;
      slider.draw();
      btClose.draw(255);
  }
  pInfo = pInfo - pInfo/6;
}

void stateHow() {
  noStroke();
  fill(0, 0, 0, 20);
  rect(0,0,width,height);
  image(howImg, width/2, pInfo+height/2);
  //tint(20);
  if (pInfo<1) {
      pInfo = 0;
      btClose.draw(255);
  }
  pInfo = pInfo - pInfo/6;
  soundTouchTimer.setVolume(0);
}


void stateIntro() {
  //acceMic();
  drawBG();
  //control.draw();
  introgame.draw();
  trixelmatrix.draw();
  //btInfo.draw();
  //scoreInfo.draw();
  spinclesDraw();
}


void stateGame() {
  acceMic();
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
