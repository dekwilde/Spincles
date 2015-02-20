int score = 0;
int energy = 0;
int level = 0;
String scoreResult = "RECORD";
int recordScore = 0;
class ScoreInfo {
    int dw = 100;
    int dh = 10;
    float px,py;  
    

  
    ScoreInfo() {
      //Setuo do botão 
    }
    
    void draw() {
      
      px = width - dw - 10;
      py = 30;
      
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
        WeightSegmentTouch = random(12.0, 16.0 + hurtTimer/10);
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
      
      /*
      stroke(255);
      line(px+10, py+dh/2, px+80, py+dh/2);
      line(px+10, py+ dh/5, px+10, py+ dh - dh/5);
      line(px+80, py+ dh/5, px+80, py+ dh - dh/5);    
      */

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
  saveStrings("record", 0);
  saveStrings("level", 0);  
}

void loadScore() {
      recordScore = int(loadStrings("record"));
      level = int(loadStrings("level"));
}

void saveScore() {
  if(score>recordScore) {
    saveStrings("record",score);
    saveStrings("level",level);
  } else {
    saveStrings("record",recordScore);
    saveStrings("level",level);
  }
}


void setScore() {
    //First time score
  if(!recordScore || recordScore == null || recordScore == "null") {
    recordScore = score;
    saveStrings("record",recordScore);
    saveStrings("level",level);
    scoreResult = "New Record";
  } else {
    //check if the score is a new record
    if(score>recordScore) {
      scoreResult = "New Record";
      recordScore = score;
      saveStrings("record",recordScore);
      saveStrings("level",level);
    } else {
      scoreResult = "Record";
    }     
  } 
}
