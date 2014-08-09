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
  
         angleSpeedTouch =  random(0.02, 0.14);
         angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
         WeightSegmentTouch =  random(4.0, 10.0);
         //println("touch_on"); 
         
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

void shakeEvent()
{
  println("shaked");
}

void playloopBG() {
  
    int m = round(millis()/1000);
    
    if(m == 1) {
        sound1.play();
        sound1.loop();
    }
    if(m == 4) {
        sound2.play();
        sound2.loop();  
    }

    //sound1.setVolume(microfone*10);
    //sound2.setVolume(microfone*10);

}
void startGame() {
    iphone.startMicMonitor();
    iphone.startAccelerometer();
    iphone.startCompass();
    //iphone.startLocation();
    score = 30;
    gameState = "Game";
    println(gameState); 
}
void resetGame() {
    score = 30;
    gameState = "Game";
    println(gameState);   
}



