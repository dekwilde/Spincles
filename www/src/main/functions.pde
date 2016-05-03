void pebug(String m) {
  //println(m);
}



void tw33n(float start, float end, int time) {
  int m = millis();
  int t = m % time;
  float d = (end-start)/time;
  float a = d*t; 
  return a;
}

void contains([] a, int obj) {
    var i = a.length;
    while (i--) {
       if (a[i] === obj) {
           return obj;
       }
    }
    return false;
}


void hurt() {
  energy = energy - hurtLife;
  
  infectSegment = new float[0];
  infectArm     = new float[0];
  control = new Control(1);
  
  
  soundEnemy.play();
  gameTransions = "Static";
  hurtRange += hurtValue;
  body.reset();

  pebug("energy " + energy);
}


void infect() {
  collisionParticleX = spinX;
  collisionParticleY = spinY;
  
  int rdArm = 1 + int(random(numOfArms)-1);
  int rdSeg = 2 + int(random(numSegment-2));

  if(infectArm.length < maxSprings) {
    append(infectArm, rdArm);
    append(infectSegment, rdSeg);
    
    control = new Control(infectArm.length);  
  }
  pebug("infectArm " + infectArm);
  pebug("infectSegment " + infectSegment); 
}

void gotch() {
  if(level == 0) {
    energy = energy + 4;  
  } else {
    energy = energy + 2;  
  }
  score = score + 1;
  saveScore();
  pebug("energy " + energy);
  soundMagnetic.play();
  soundScore.play();
  gameTransions = "Yellowout";
  gameDialog = "Score";
  //trixGOOD.num = 0;
  body.reset();
  
  infectSegment = new float[0];
  infectArm     = new float[0];
  if(control.numSprings != 1) {
    control = new Control(1);
  }
  
}

void clawTouchStart() {
  soundTouchTimer.volume((hurtTimer/100) + 0.01);
    
  hurtTimer += 4;
    
  
  //pebug("hurt " + hurtTimer);
  if(hurtTimer>10*hurtTimer && hurtTimer<11*hurtTimer) {
    bover = false;
    locked = true;
    energy = energy - 2;
    hurtRange += hurtValue;
    //hurt();
    //trixBAD.num = 0;
  }
  if(hurtTimer>200) {
    gameState = "NoTouch";
  }
}

void clawTouchStop() {
  hurtRange = 0;
  hurtTimer -= 1;
  soundTouchTimer.volume(hurtTimer/100 + 0.01);
  if(hurtTimer<0) {
    hurtTimer = 0;
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
    background(colorR, colorG, colorB, 255);
    fill(colorR, colorG, colorB, 255);
    noStroke();        
    rect(0,0,width,height);  
  }

  
}



void activeGame() {
  trixelmatrix.reset(); 
}


void startGame() {
    gameTransions = "Flash";
    loadScore();
    resetGame();
    
    soundStart.stop();
	soundStart.volume(0);
    soundLoopBG.play();
    soundLoopBG.loop(true);

	soundTouchTimer.play();
    soundTouchTimer.loop(true);
	soundTouchTimer.volume(0.01);

    
    gameState = "GameStart";
    //gameTransions = "Flash";
    gameDialog = "Start";
}
void resetGame() {
  energy = 30;
  score = 0;
  hurtRange = 0;
  hurtTimer = 0;
}
void againGame() {
    resetGame();
    gameState = "GameLevel";
    //gameTransions = "Flash";
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


