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



void Bover() {
  if (touch1X > bx-bs && touch1X < bx+bs && 
  touch1Y > by-bs && touch1Y < by+bs) {
       bover = true;       
  } else {
    //
  }
  if(bover) { 
    locked = true;
    
  } else {
    locked = false;
  }
  bdifx = touch1X-bx; 
  bdify = touch1Y-by; 
}

void Locked() {
  if(locked) {
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }  
}
void unLocked() {
  locked = false;  
  touch1X = 0;
  touch1Y = 0;  
  touch2X = 0;
  touch2Y = 0;  
}




boolean gestureMobile = false;
void gestureStarted() {
  gestureMobile = true;
  startAngle = iAngle;
  startEscala = iScale;
}

void gestureChanged() {
  iAngle = startAngle + gesture.rotation;
  iScale = startEscala * gesture.scale;
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



float pinchDistance = 0;
float pinchAngle = 0;
void touchStart(t) {
    
  for (int i = 0; i < t.touches.length; i++) {
    var id = t.touches[i].identifier;
    if (!touches[id]) {
      touches[id] = color(random(255), random(255), random(255), 128);
    }

    //pebug("touch "+ touch1X + " " + touch1Y);
    //disply pebug
    noStroke();
    fill(touches[id]);
    ellipse(t.touches[i].offsetX, t.touches[i].offsetY, 30, 30); 
  }
  
  touch1X = t.touches[0].offsetX;
  touch1Y = t.touches[0].offsetY;
  if(t.touches.length>1) {
    touch2X = t.touches[1].offsetX;
    touch2Y = t.touches[1].offsetY;
  } else {
    touch2X = 0;
    touch2Y = 0;
  }
  Bover();
  
  //GESTURE
  if(!gestureMobile) {
    if(t.touches.length>1) {
      startAngle = iAngle;
      startEscala = iScale;
      pinchDistance = dist(touch2X, touch2Y, touch1X, touch1Y);
    } else {
      pinchDistance = 0;
      pinchAngle = 0
    }
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
  if(t.touches.length>1) {
    touch2X = t.touches[1].offsetX;
    touch2Y = t.touches[1].offsetY;
  } else {
    touch2X = 0;
    touch2Y = 0;
  }
  Locked();
  
  
  if(!gestureMobile) {
    if(!(pinchDistance <= 0)) {
      float newDistance = dist(touch2X, touch2Y, touch1X, touch1Y);
      pinchAngle = degrees(atan2(touch2Y - touch1Y, touch2X - touch1X));  
      
      iAngle = startAngle + pinchAngle;
      iScale = startEscala * (newDistance/pinchDistance);
      if (iAngle > 360) {
              iAngle = iAngle - 360;
      }
      if (iAngle < 0) {
              iAngle = 360 + iAngle;
      }
    }
  }
  
} 





void touchEnd(t) {
  unLocked();
  
  if(!gestureMobile) {
    startAngle = iAngle;
    startEscala = iScale;
    pinchDistance = 0;
    pinchAngle = 0;
  }
  
}






boolean mouse = false;
void mousePressed() {
  mouse = true;
  touch1X = mouseX;
  touch1Y = mouseY; 
  Bover();
  
  startAngle = iAngle;
  startEscala = iScale;
  pinchDistance = dist(mouseX, mouseY, bx, by);
  
}
void mouseDragged() {
  Locked();
  //display pebug
  stroke(255);
  noFill();
  line(bx,by,mouseX, mouseY);
  ellipse(bx,by,bs,bs);
  pinchAngle = degrees(atan2(mouseY-by, mouseX-bx));
  float newDistance = dist(mouseX, mouseY, bx, by);
  
  iAngle = startAngle + pinchAngle;
  iScale = startEscala * (newDistance/pinchDistance);
  if (iAngle > 360) {
          iAngle = iAngle - 360;
  }
  if (iAngle < 0) {
          iAngle = 360 + iAngle;
  }
  
  
}
void mouseMoved() {
  if(!mousePressed) {
    gravityX = (mouseX - width/2)/1000;
    gravityY = (mouseY - height/2)/1000;
  }
}

void mouseReleased() {
  unLocked();
  
  startAngle = iAngle;
  startEscala = iScale;
  pinchDistance = 0;
  pinchAngle = 0;
  
}

boolean zigPressed = false;
void zig() {
  if(zigDevice) {    
    gravityX = (zigCursorX - width/2)/1000;
    gravityY = (zigCursorY - height/2)/1000;
   
    if(zigPush) {
      iAngle = zigDegrees;
      iScale = zigScale;
      if(!zigPressed) {
        zigPressed = true;
        touch1X = zigCursorX;
        touch1Y = zigCursorY;
        pebug("zigPressd: " + zigCursorX + ",  " + zigCursorY);        
      }
    } else {
      zigPressed = false;  
    }
    
  } 
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
  if(!mouse || !zigDevice) {
    gravityX = acceleration.x/10;
    gravityY = -acceleration.y/10;    
    //pebug("x: " + gravityX + " " + "y: " + gravityY);     
  }

}
void mic() {
  microfone = media.miclevel*mic_perc;
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



