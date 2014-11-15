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
  angleSpeedTouch =  random(0.02, 0.14);
  angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
  WeightSegmentTouch =  random(4.0, 10.0);  
}

void shakeEvent() {
  println("shaked");
}

boolean playSound1 = false;
boolean playSound2 = false;
void soundLoopBG() {
  
    int m = round(millis()/1000);
    
    if(!playSound1) {
      playSound1 = true;
      sound1.play();
      sound1.loop();
      println("sound1");
    }
    if(m == 3) {
      if(!playSound2) {
        playSound2 = true;
        sound2.play();
        sound2.loop();
        println("sound2");
      }  
    }
}


void drawBG() {
  colorR = 255; // + microfone*20;
  colorG = 204; // + microfone*25;
  colorB = 0;   // + microfone*20;
   
  ctx.clearRect(0,0,width,height);// part of the canvasAPI that creates a clear rect
  //Camera();
  fill(colorR, colorG, colorB, 255 - delay_mic);
  noStroke();        
  rect(0,0,width,height);
}


void startGame() {
    recordScore = iphone.loadState();
    iphone.startMicMonitor();
    iphone.startAccelerometer();
    iphone.startCompass();
    //iphone.startLocation();
    iphone.squareCamera();
    resetGame();
}


void resetGame() {
  energy = 30;
  score = 0;
  gameState = "Game";
  println(gameState);
  sound1.setVolume(100);
  sound2.setVolume(100);  
}


void gameOver() {
  //First time score
  if(recordScore) {
    recordScore = score;
    iphone.saveState(score);
  } else {
    //check if the score is a new record
    if(score>recordScore) {
      scoreResult = "New Record";
      recordScore = score;
      iphone.saveState(score);
    } else {
      scoreResult = "Record " + (String)recordScore;
    }
  } 
  gameState = "Over";
}

void gameWin() {
  //
}

