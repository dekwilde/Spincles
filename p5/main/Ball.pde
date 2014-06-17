class Ball {
  float diameter;
  float vx = 0;
  float vy = 0;
  
  float left = 100, right = 700, bottom = 100, top = 500;
  float xMax = 10, yMax = 5;
  float x = 400, y = 300;
  float xLimit, yLimit, xSpeed, ySpeed, xDelta, yDelta; 
  
  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
  }
  
  void move() {
        
    if (x < left){
      xDelta = random(0,1);
      angleSpeedTouch =  random(0.02, 0.14);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (x > right){
      xDelta = random (-1,0);
      angleSpeedTouch =  random(0.02, 0.14);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else {
      xDelta = random(-1,1);
      angleSpeedTouch =  random(0.02, 0.14);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    }

    if (y < bottom){
      yDelta = random(0,1);
      angleSpeedTouch =  random(0.02, 0.14);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (y > top){
      yDelta = random (-1,0);
      angleSpeedTouch =  random(0.02, 0.14);
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else {
      yDelta = random(-1,1);
      angleSpeedTouch =  random(0.02, 0.14);
    }

    xSpeed = xSpeed + xDelta;
    ySpeed = ySpeed + yDelta;

    if (xSpeed > xMax){
      xSpeed = xMax;
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (xSpeed < -xMax){
      xSpeed = -xMax;
    }

    if (ySpeed > yMax){
      ySpeed = yMax;
      //angleRadiusTouch = angleRadiusTouch + random(-3.0, 3.0);
    } 
    else if (ySpeed < -yMax){
      ySpeed = -yMax;
    }

    x = x + xSpeed;
    y = y + ySpeed;
    
    angleSpeedTouch = angleSpeedTouch / 1.02;
    angleRadiusTouch = angleRadiusTouch / 1.008;
    WeightSegmentTouch = WeightSegmentTouch / 1.08;
    
  }
  
}
