void pebug(m) {
  //println(m);
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

void clawTouchLoop() {
  soundTouchTimer.setVolume(hurtTimer/100);
  
  if(hurtTimer<1) {
    soundTouchTimer.play();
    soundTouchTimer.loop();
  }
  
  hurtTimer += 2;
    
  
  //pebug("hurt " + hurtTimer);
  if(hurtTimer>100) {
    bover = false;
    locked = true;
    energy = energy - 2;
    soundGlitch.play();
    //gameTransions = "Static";
    hurtRange = 255;
    //hurt();
    trixBAD.num = 0;
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

void shakeEvent() {
  pebug("shaked");
}


void drawBG() {
  colorR = 255; // + microfone*20;
  colorG = 204; // + microfone*25;
  colorB = 0;   // + microfone*20;
   
   
  blowMic =  microfone*15;
  if(blowMic>255) {
    blowMic = 255;
  }
  
  pebug(blowMic);
  
  tweenBG = tweenBG + ((microfone+hurtRange)*15 - tweenBG/4)/10;
  
  if(tweenBG>255) {
    alphaBG = 255;  
  } else {
    alphaBG = tweenBG; 
  }
        
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
    recordScore = iphone.loadState();
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
  pebug(gameState);
}


void gameOver() {
  setScore();
  gameState = "Over";
}

void gameWin() {
  //
}


void stateStart() {
  background(0);
  
  initColorAlpha = initColorAlpha + (255 - initColorAlpha)/20;
  fill(255, 204, 0, initColorAlpha);
  rect(0,0,width,height);
  
  fill(0);
  textFont(fontTitle, 10);
  
  text("Welcome to", width/2, height/2-50); 
  //image(logoImg, width/2, height/2);
  pushMatrix();
  translate(width/2-(500*0.3), height/2-(200*0.3)+20);
  scale(0.3);
  
  logo.draw();
  popMatrix();
  
  textFont(fontText, 10);
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
  
  
  
  if(initColorAlpha>220) {
    initPosY = initPosY + (0 - initPosY)/10;
    pushMatrix();
    translate(0, initPosY);
    btStart.draw();
    popMatrix();
  }
  
  

  
  
}

void stateOver() {
  int Talign = 40;
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
  
  btAgain.draw();
}


void stateInfoShow() {
  fill(0, 0, 0, 20);
  rect(0,0,width,height);
  image(infoImg, width/2, pInfo+height/2);
  //tint(20);
  if (pInfo<1) {
      pInfo = 0;
      slider.draw();
      btClose.draw();
  }
  pInfo = pInfo - pInfo/6;
}

void stateGame() {
  acceMic();
  drawBG();
  //Three();        
  control.draw();  
  compass.draw();
  trixBAD.draw();
  trixGOOD.draw();
  btInfo.draw();
  //btCamera.draw();
  scoreInfo.draw();
  spinclesDraw();
}
