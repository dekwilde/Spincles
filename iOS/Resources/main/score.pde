int score = 0;
int energy = 0;
int level = 0;
String scoreResult = "RECORD";
int recordScore = 0;
class ScoreInfo {
    int dw = 100;
    int dh = 10;
    float px = width - dw - 10;
    float py = 10;  
    

  
    ScoreInfo() {
      //Setuo do botão 
    }
    
    void draw() {
      
      if(energy > 100) {
          levelUp();
      }
      
      
      if(energy < 0) {
          gameOver();
      }
      
      
      if(energy>=25) {
        numSegment = 4;
        numOfArms = 10;  
        WeightSegmentTouch = random(hurtTimer/10);
        angleSpeedTouch =   - random(hurtTimer/100);
        angleRadiusTouch =  - random(hurtTimer/100);
      }         
      else if(energy>20 && energy<24) {
        numSegment = 3;
        numOfArms = 8;
        WeightSegmentTouch = random(1.0, 3.0 + hurtTimer/50);
        angleSpeedTouch =  - random(hurtTimer/100);
        angleRadiusTouch = - random(hurtTimer/100);

      } 
      else if(energy>10 && energy<19) {
        numSegment = 2;
        numOfArms = 5;
        WeightSegmentTouch = random(3.0, 6.0 + hurtTimer/20);
        angleSpeedTouch =  - random(hurtTimer/100);
        angleRadiusTouch = - random(hurtTimer/100);
      }
      else if(energy>1 && energy<9) {
        numSegment = 1;
        numOfArms = 3;  
        WeightSegmentTouch = random(8.0, 12.0 + hurtTimer/10);
        angleSpeedTouch =  - random(0.05, 0.3);
        angleRadiusTouch =  - random(-6.0, 6.0);
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

      fill(255,204,0,128);
      stroke(0);
      rect(px, py, dw, dh);
      
      fill(0);
      noStroke();
      rect(px, py, energy, dh);
    
      stroke(255);
      line(px+10, py+dh/2, px+80, py+dh/2);
      line(px+10, py+ dh/5, px+10, py+ dh - dh/5);
      line(px+80, py+ dh/5, px+80, py+ dh - dh/5);    
      

      textFont(fontText, 14);
      textAlign(RIGHT);
      text(score, px-5, py+10); 

    }

}

void levelUp() {
  energy = 30;
  level += 1;
  saveScore();
  gameTransions = "Level";
}

void clearScore() {
  energy = 30;
  level = 0;
  score = 0;
  recordScore = 0;
  iphone.saveState("");  
}

void loadScore() {
      // Load the previously saved state of the app
    Array[] load = split(iphone.loadState(), ",");
    if (load.length >= 2) {
      recordScore = int(load[0]);
      level = int(load[1]);
    }
}

void saveScore() {
  if(score>recordScore) {
    iphone.saveState(score+","+level);
  } else {
    iphone.saveState(recordScore+","+level);
  }
}


void setScore() {
    //First time score
  if(!recordScore || recordScore == null || recordScore == "null") {
    recordScore = score;
    iphone.saveState(recordScore+","+level);
    scoreResult = "New Record";
  } else {
    //check if the score is a new record
    if(score>recordScore) {
      scoreResult = "New Record";
      recordScore = score;
      iphone.saveState(recordScore+","+level);
    } else {
      scoreResult = "Record";
    }     
  } 
}
