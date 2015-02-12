void pebug(String m) {
  //println(m);
}



void hurt() {
  //iphone.vibrate();
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
  gameTransions = "Flash";
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
  //iphone.screenShot();
  pebug("screenshot");
  //noLoop();
}

void stateSetup() {
  //scW = screen.width;
  //scH = screen.height;
  
  scW = window.innerWidth;
  scH = window.innerHeight;
 
  pebug("build 3");
  pebug("width: " + scW + " " + "height: " + scH);
  size(scW, scH, P2D);

  
  //rectMode(CENTER_RADIUS);
  rectMode(CORNER);
  imageMode(CENTER);
  textAlign(CENTER);
  ctx = externals.context;   
  frameRate(30);
  //smooth();


  howImg = loadImage("data/how.png");
  fontTitle = loadFont("data/hexagonica.ttf");        
  fontText = loadFont("data/MicroN55.ttf");
  
  stateLoad();

  if(scW>320 && scH>480) {
    //ipad
    wCount = 4;
    hCount = 2; 
    rad = 430;
    iScale = 1.2;
    videoscale = 24;
  } else {
    //iphone
    wCount = 4; 
    hCount = 2;
    rad = 215;
    iScale = 0.6;
    videoscale = 10;
  }
  
  pebug("wCount: " + wCount + ", hCount: " + hCount);

  pebug("Start sensor");

  control = new Control();
  btInfo = new ButtonInfo();
  btStart = new ButtonStart();
  btAgain = new ButtonAgain();
  btHow = new ButtonHow();
  btClear = new ButtonClear();
  btShare = new ButtonShare();
  btCamera = new ButtonCamera();
  btClose = new ButtonClose();
  slider = new MenuSlider();
  scoreInfo = new ScoreInfo();
  logo = new Logo();
  tEff = new TrixelEffect();
  dialog = new Dialog();

  trixelmatrix = new TrixelMatrix();
  
  
  particleMagnetic = new TrixParticle("magnetic");
    

  spinclesState();


  bx = width/2;
  by = height/2;
  iAngle = 0;
  initPosY = height + 100;
    
  //setupThree();
  //video = loadImage("cam.png");
  
  pebug("4 - Start sequence: main.pde setup()");
    
  gameState = "Start";
  gameEnemy = "Null";
  gameTransions = "Static";
  gameSound = "Intro";
  gameDialog = "Setup";
 
}


void stateStart() {
  background(255,204,0);
  
  acce();
  mic();
  compass();
  
  /*
  ctx.rect(0,0,width,height);
  fill(255,204,0,20);
  noStroke();        
  rect(0,0,width,height);
  */

  
  int Talign = -140;
  fill(0);
  textFont(fontTitle, 10);
  text("Welcome to", width/2, height/2-40+Talign); 


  logo.draw(Talign);
  
  control.draw(); 
  btStart.draw();
  

  
}

void stateOver() {
  int Talign = -240;
  fill(0, 3);
  noStroke();
  rect(0,0,width,height);
  fill(255);
  
  textAlign(CENTER);
  textFont(fontTitle, 40);
  text("GAME", width/2, height/2+80+Talign);
  textFont(fontTitle, 48);
  text("OVER", width/2, height/2+160+Talign);
  
  textFont(fontText);
  textSize(16);
  text("score", width/2, height/2+200+Talign);
  textSize(36);
  text(score, width/2, height/2+230+Talign);
  textSize(16);
  text(scoreResult, width/2,height/2+270+Talign);
  textSize(36);
  text(recordScore, width/2, height/2+300+Talign);
  textSize(16);
  text("level", width/2, height/2+340+Talign);
  textSize(36);
  text(level, width/2, height/2+370+Talign);
  
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
      btShare.draw();
  }
  pInfo = pInfo - pInfo/6;
  
}

void stateHow() {
  int Talign = height/2-260+pInfo;
  noStroke();
  fill(0, 20);
  rect(0,0,width,height);
  image(howImg, width/2, pInfo+height/2, 320, 480);
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
  soundTouchTimer.volume(0.0);
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


void stateLoad(String state) {
  fill(255,204,0);
  noStroke();
  rect(0,0,width,height);
  fill(0);
  textAlign(CENTER);
  textFont(fontText, 16);
  text("LOADING", width/2, height/2-8);
  if(state) {
    gameState  = state;
  }
}



void stateGame() {
  acce();
  mic();
  compass();

  drawBG();
  //cam();
  //Three();        
  control.draw();  
  trixelmatrix.draw();
  spinclesDraw();
  btInfo.draw();
  //btCamera.draw();
  scoreInfo.draw();
  
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

void stateShare() {
  int Talign = height/2-180+pInfo;
  background(255, 204, 0);
  
  pushMatrix();
  rotate(0);
  translate(0,0);
  scale(1.0);
  tEff.draw1(); 
  popMatrix();
  
  fill(0);
  textFont(fontTitle, 10);
  text("Glitch Game", width/2, 20+Talign); 
  logo.draw(-120+pInfo);
  
  fill(0);
  textFont(fontText);
  textSize(24);
  text(scoreResult, width/2, 200+Talign); //200
  textSize(52);
  text(recordScore, width/2, 250+Talign); //230
  textSize(24);
  text("level", width/2, 300+Talign); //250
  textSize(52);
  text(level, width/2, 350+Talign); //280
  
  
  if (pInfo<10) {
    load += 1;
  }
    
  if(load == 2) {
    share();
  }
  
  pInfo = pInfo - pInfo/6;
  
  
}
