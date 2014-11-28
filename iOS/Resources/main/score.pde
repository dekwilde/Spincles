int score = 0;
int energy = 0;
String scoreResult = "";
int recordScore;
class ScoreInfo {

    
    int dw = 100;
    int dh = 10;
    float px = width - dw - 10;
    float py = 10;  
    

  
    ScoreInfo() {
      //Setuo do botão 
    }
    
    void draw() {
      if(energy < 0) {
          gameOver();
      }
      
      
      if(energy>=25) {
        numSegment = 4;
        numOfArms = 10;  
      }         
      else if(energy>20 && energy<24) {
        numSegment = 4;
        numOfArms = 8;  
      } 
      else if(energy>15 && energy<19) {
        numSegment = 3;
        numOfArms = 7;  
      }
      else if(energy>10 && energy<14) {
        numSegment = 3;
        numOfArms = 6;  
      }
      else if(energy>5 && energy<9) {
        numSegment = 2;
        numOfArms = 5;  
      }
      else if(energy>1 && energy<4) {
        numSegment = 1;
        numOfArms = 3;  
      }

      pushMatrix();
      scale(1.0);
      
      stroke(0);
      noFill();
      rect(px, py, dw, dh);
      
      fill(0);
      noStroke();
      rect(px, py, energy, dh);
      
      stroke(255);

      line(px+10, py+dh/2, px+80, py+dh/2);
      line(px+10, py+ dh/5, px+10, py+ dh - dh/5);
      line(px+80, py+ dh/5, px+80, py+ dh - dh/5);    
    
      popMatrix();
      
      pushMatrix();
      textFont(fontText, 14);
      textAlign(RIGHT);
      text(score, px-5, py+10); 
      popMatrix();      

    }

}

void setScore() {
    //First time score
  if(!recordScore || recordScore == null || recordScore == "null") {
    recordScore = score;
    iphone.saveState(recordScore);
    scoreResult = "New Record";
  } else {
    //check if the score is a new record
    if(score>recordScore) {
      scoreResult = "New Record";
      recordScore = score;
      iphone.saveState(recordScore);
    } else {
      scoreResult = "Last Record";
    }
  } 
}


