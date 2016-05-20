void stateSetup() {
  //scW = screen.width;
  //scH = screen.height;
  
  scW = window.innerWidth;
  scH = window.innerHeight;
 
  pebug("build 5");
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
  
  if(scW>800) {
    scW = 800;
    wCount = 6;
    hCount = 2; 
  } else {
    wCount = 4;
    hCount = 2;     
  }
  endEscala = (scW*0.2)/100;
  iScale = 0.0;
  rad = scW * 0.6;
  
  pebug("wCount: " + wCount + ", hCount: " + hCount);

  pebug("Start sensor");

  control = new Control(1);
  btInfo = new ButtonInfo();
  btStart = new ButtonStart();
  btAgain = new ButtonAgain();
  btHow = new ButtonHow();
  btClear = new ButtonClear();
  btShare = new ButtonShare();
  btLeader = new ButtonLeaderBoard();
  btClose = new ButtonClose();
  slider = new MenuSlider();
  scoreInfo = new ScoreInfo();
  logo = new Logo();
  tEff = new TrixelEffect();
  dialog = new Dialog();

  trixelmatrix = new TrixelMatrix();
  
  body = new Tbody();
  
  
  particleMagnetic = new TrixParticle("magnetic");
    

  body.reset();


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
  gameDialog = "Setup";
  
  soundStart.stop();
  soundStart.play();

  
  hidePageLoadingMsg();
  requestFullScreen();  

  startUserMediaMic();  
 
}


void stateStart() {
  
  //acce();
  mic();
  //compass();
  zig();
  
 
  //background(255,204,0);
   
  ctx.rect(0,0,width,height);
  fill(255,204,0,40);
  noStroke();        
  rect(0,0,width,height);
  tEff.draw2(microfone+10, 0);
  tEff.draw0(); 
  
  
  int Talign = -150;
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
  if(micEnable) {
    micText = "MIC VOLUME ON";
  } else {
    micText = "MIC VOLUME OFF";
  }
  
  noStroke();
  fill(0, 0, 0, 20);
  rect(0,0,width,height+pInfo);
  fill(255);
  textAlign(CENTER);
  textFont(fontTitle, 20);
  text("PAUSED", width/2, 70+Talign);
  textFont(fontText);
  textSize(16);
  text(micText, width/2, 110+Talign);
  text(scoreResult, width/2, 200+Talign); //200
  textSize(36);
  text(recordScore, width/2, 230+Talign); //230
  textSize(16);
  text("level", width/2, 250+Talign); //250
  textSize(36);
  text(level, width/2, 280+Talign); //280
  
  
  if (pInfo<1) {
      pInfo = 0;
      
      btClose.draw(255);
      btHow.draw(60);
      btLeader.draw();
      btClear.draw();
      btShare.draw(); // tem que deixar este botao por ultimo por causa da ordem de renderizacao
      slider.draw();

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
  soundTouchTimer.volume(0.01);
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



void stateGameStart() {
  acce();
  mic();
  compass();
  zig();

  drawBG();
  //cam();
  //Three();        
  control.draw();
  
  
  
   
  if(iScale<endEscala) {
    //iScale = iScale + 0.001*speedEscala;
    iScale = tw33n(0, endEscala+0.1, 15000);
  } else {
    iScale = endEscala;
    
    if(trixScale>1) {
      //trixScale = trixScale - 0.01*speedEscala;
      trixScale = 8.0 - tw33n(0.0, 8.0, 30000);
      pushMatrix();
      scale(trixScale);
      trixelmatrix.draw();
      popMatrix();
    } else {
      gameDialog = "Find";
      gameState = "GameStart";
      trixelmatrix.draw();
    }  
    
  }
  body.draw();
  //btInfo.draw();
  //btCamera.draw();
  //scoreInfo.draw();
  
}

void stateGameLevel() {
  acce();
  mic();
  compass();
  zig();

  drawBG();        
  control.draw();
 
  trixelmatrix.draw();
 
  body.draw();
  btInfo.draw();
  scoreInfo.draw(); 
   
  if(energy > 100) {
      levelUp();
  }
   
  if(energy < 0) {
      gameOver();
  }
  
  
  if(energy>=30) {
    numSegment = 4;
    numOfArms = 10;  
    WeightSegmentTouch = random(hurtTimer/10);
    angleSpeedTouch =   - random(hurtTimer/100);
    angleRadiusTouch =  - random(hurtTimer/100);
    speed = 20;
  }         
  else if(energy>20 && energy<29) {
    numSegment = 3;
    numOfArms = 8;
    WeightSegmentTouch = random(1.0, 3.0 + hurtTimer/50);
    angleSpeedTouch =  - random(hurtTimer/100);
    angleRadiusTouch = - random(hurtTimer/100);
    speed = 40;
  
  } 
  else if(energy>10 && energy<19) {
    numSegment = 2;
    numOfArms = 5;
    WeightSegmentTouch = random(3.0, 6.0 + hurtTimer/20);
    angleSpeedTouch =  - random(hurtTimer/100);
    angleRadiusTouch = - random(hurtTimer/100);
    speed = 80;
  }
  else if(energy>1 && energy<9) {
    numSegment = 1;
    numOfArms = 3;  
    WeightSegmentTouch = random(12.0, 16.0 + hurtTimer/10);
    angleSpeedTouch =  - random(0.05, 0.1);
    angleRadiusTouch =  - random(-3.0, 3.0);
    speed = 120;
  }
  
  if(WeightSegmentTouch>20) {
    WeightSegmentTouch = 20;
  }
  if(angleSpeedTouch>5) {
    angleSpeedTouch = 5;
  }
  if(angleRadiusTouch>3) {
    angleRadiusTouch = 3;
  }


 
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
  btHow.draw(210);
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
