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
      fill(255,204,0,128);
      stroke(0);
      rect(px, py, dw, dh);
      
      fill(0);
      noStroke();
      rect(px, py, energy, dh);
      
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
  gameDialog = "Level";
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
  recordScore = int(loadStrings("record")) || 0;
  level = int(loadStrings("level")) || level;
}

void saveScore() {
  if(score>recordScore) {
    saveStrings("record",score);
    saveStrings("level",level);
    sendScoreGameCenter(score);
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
