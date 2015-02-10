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


// For touchscreens
void touchStart(t) {
  for (int i = 0; i < t.touches.length; i++) {
    var id = t.touches[i].identifier;
    if (!touches[id]) {
      touches[id] = color(random(255), random(255), random(255));
    }

    if(id == 0) {
      touch1X = t.touches[id].offsetX;
      touch1Y = t.touches[id].offsetY;
    }

    fill(touches[id]);
    ellipse(t.touches[i].offsetX, t.touches[i].offsetY, 10, 10);
    

    
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
    fill(touches[id]);
    ellipse(t.touches[i].offsetX, t.touches[i].offsetY, 10, 10);
  }
  
  if(id == 0) {
    touch1X = t.touches[0].offsetX;
    touch1Y = t.touches[0].offsetY;
  }
  
  if(locked) {
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }
  
} 
void touchEnd(t) {
  locked = false;  
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

  // Remap axis value to something within the sketch bounds
  gravityX = map(acceleration.x, -1.0, 1.0, 0, width);
  gravityY = map(acceleration.y, -1.0, 1.0, 0, height);    
  //pebug("x: " + gravityX + " " + "y: " + gravityY);  
}
void mic() {
  //pebug("Mic: " + microfone);
}
void compass() {
  // Only show the compass if the device supports one
  if (orientation.compassHeading >= 0 && orientation.compassAccuracy >= 0) {
    // Ease the previous heading to the current heading
    float theta = orientation.compassHeading;
    float dtheta = theta - compassDEGREE;
    if (abs(dtheta) < 180) {
      compassDEGREE += dtheta * easing;
    } else {
      compassDEGREE = theta;
    }
  
    // Convert degree heading to an x/y co-ordinate;
    int compassX = 100 * sin(radians(compassDEGREE));
    int compassY = 100 * cos(radians(compassDEGREE));
    
    //display
    ellipse(width/2 - compassX, height/2 - compassY, 20, 20);
  }  
  
}



