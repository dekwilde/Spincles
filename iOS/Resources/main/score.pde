int score = 0;

class ScoreInfo {

    
    int dw = 100;
    int dh = 10;
    float px = width - dw - 10;
    float py = 10;  
    

  
    ScoreInfo() {
        score = 30;      
    }
    
    void draw() {
      if(score < 0) {
          gameState = "Over";   
      }
      if(score>100) {
        score = 100;
      }
      
      println("score " + score);
      
      pushMatrix();
      scale(1.0);
      
      stroke(0);
      noFill();
      rect(px, py, dw, dh);
      
      fill(0);
      noStroke();
      rect(px, py, score, dh);
      
      stroke(255);

      line(px+10, py+dh/2, px+80, py+dh/2);
      line(px+10, py+ dh/5, px+10, py+ dh - dh/5);
      line(px+80, py+ dh/5, px+80, py+ dh - dh/5);     
      popMatrix();
      
        

    }

}
