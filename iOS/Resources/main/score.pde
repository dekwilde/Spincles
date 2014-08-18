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
      
      
      if(energy>100) {
        energy = 100;
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
      textFont(fontText, 14);
      textAlign(RIGHT);
      text(score, px-5, py+10);        

    }

}
