int lastTime = 0;
int interval = 5000;
float lt;
float lg;
float al;
float hd;
float sp;
 
float targetLT = -21.793933;
float targetLG = -48.170929;
float currentLT;
float currentLG;
float compassDEGREE = 0, targetDEGREE = 0;
var touches = {};






void gestureStarted() {
  startAngle = iAngle;
  startEscala = iScale;
}

void gestureChanged() {
  iAngle = startAngle + gestureRotation;
  //iScale = startEscala * gestureScale;
  if (iAngle > 360) {
          iAngle = iAngle - 360;
  }
  if (iAngle < 0) {
          iAngle = 360 + iAngle;
  }
        
}

void gestureStopped() {
  startAngle = iAngle;
  startEscala = iScale;
}


void touchStart(t) {
    
  for (int i = 0; i < t.touches.length; i++) {
    var id = t.touches[i].identifier;
    if (!touches[id]) {
      touches[id] = color(random(255), random(255), random(255), 128);
    }

    touch1X = t.touches[0].offsetX;
    touch1Y = t.touches[0].offsetY;
    
    //pebug("touch "+ touch1X + " " + touch1Y);
    
    //disply pebug
    noStroke();
    fill(touches[id]);
    ellipse(t.touches[i].offsetX, t.touches[i].offsetY, 30, 30);
    

    
    if (touch1X > bx-bs && touch1X < bx+bs && 
    touch1Y > by-bs && touch1Y < by+bs) {
         bover = true;       
    } else {
  
      
    }
    
    if(bover) { 
      locked = true;
      
    } else {
      locked = false;
    }
    bdifx = touch1X-bx; 
    bdify = touch1Y-by; 
    
  }
}

void touchMove(t) {
  for (int i = 0; i < t.touches.length; i++) {
    var id = t.touches[i].identifier;
    //disply pebug
    noStroke();
    fill(touches[id]);
    ellipse(t.touches[i].offsetX, t.touches[i].offsetY, 30, 30);
  }
  
  touch1X = t.touches[0].offsetX;
  touch1Y = t.touches[0].offsetY;
  
  if(locked) {
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }
  
} 
void touchEnd(t) {
  locked = false;  
  touch1X = -1;
  touch1Y = -1;
}


void locationChanged() {
  println(coords.longitude + ", " + coords.latitude);
}  


void pointCompass() {
    currentLT = lt;
    currentLG = lg;
        
    float diffLT = targetLT - currentLT;
    float diffLG = targetLG - currentLG;
    
    /*
    if (diffLT == 0) {
        if (diffLG > 0) {
            targetDEGREE = 90;
        }
        else {
            targetDEGREE = 270;
        }
    }
    else {
        targetDEGREE = atan2(diffLT, diffLG) * 180 / PI;
        
    }

    if (diffLT < 0) {
        targetDEGREE = targetDEGREE + 180;
    }
    */
    
    targetDEGREE = atan2(diffLT, diffLG) * 180 / PI;
    //pebug(targetDEGREE);
}

void acce() {

  gravityX = acceleration.x/10;
  gravityY = -acceleration.y/10;    
  //pebug("x: " + gravityX + " " + "y: " + gravityY);  
}
void mic() {
  //pebug("Mic: " + microfone);
}




void compass() {
  
  //pebug(orientation.compassHeading);

  float theta = orientation.compassHeading;
  float dtheta = theta - compassDEGREE;
  if (abs(dtheta) < 180) {
    compassDEGREE += dtheta * easing;
  } else {
    compassDEGREE = theta;
  }
  
  angleCompass = compassDEGREE + iAngle;
  
  if (angleCompass > 360) {
          angleCompass = angleCompass - 360;
  }
  if (angleCompass < 0) {
          angleCompass = 360 + angleCompass;
  }
  
}



