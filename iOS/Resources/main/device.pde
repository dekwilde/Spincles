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
float compassDEGREE, targetDEGREE;


void startSensor() {
  //iphone.squareCamera();
  //frame = requestImage(iphone.getCamera());
  iphone.startMicMonitor();
  iphone.startAccelerometer();
  iphone.startCompass();
  //iphone.startLocation();

}

void stopSensor() {
  iphone.stopMicMonitor();
  iphone.stopAccelerometer();
  iphone.stopCompass();
  //iphone.stopLocation();
  //iphone.squareCamera();
}


void photoCancelled() {
  gameState = "InfoShow";
  loop();
}

void photoSelected(String file) {  
  setTimeout(function() {
    iphone.viewDocument(file);
    gameState = "InfoShow";
    loop();
  }, 1000);
  pebug("viewDocument: " + file);
  //var mailto_link = "mailto:"+emailto+"?from="+emailfrom +"&body=" + encodeURIComponent( message ) + "&subject=" + encodeURIComponent("Subject") + "&attachment=" + file;
  //link("mailto:a@gmail.com?subject=myreport&body=seeattachment&attachment='" + file + "'");

}

void photoScreenShot(file) {
    //loop();
    gameState = "Load";
    iphone.viewDocument(file);
    setTimeout(function() {
      //iphone.openPhotos(true);
      gameState = "InfoShow";
    }, 15000);
    pebug("viewDocument: " + file);
}


void gestureStarted() {
  startAngle = iAngle;
  startEscala = iScale;
}

void gestureChanged() {
  iAngle = startAngle + gestureRotation;
  iScale = startEscala * gestureScale;
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

void touch1Started() {
  //GEsture Drag Spincles
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

void touch1Moved() {
  if(locked) {
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }
}


void touch1Stopped() {  
  if (touch1X > bx-bs && touch1X < bx+bs && 
  touch1Y > by-bs && touch1Y < by+bs) {
         //hurt();
  }
  
  // click info var
  //btClose.overButton = false;
  //btInfo.overButton = false;
  //btSupport.overButton = false;
  //btContact.overButton = false;
  
  // gesture var
  //bover = false;
  locked = false;
}


void location() {
   int currentTime = millis();
   if (currentTime > lastTime+interval) {
        Location loc = iphone.getLocation();
        lt = loc.latitude;
        lg = loc.longitude;
        al = loc.altitude;
        hd = loc.heading;
        sp = loc.speed;

        lastTime = currentTime;
        iphone.getCurrentLocation();
        pebug("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp);

    }
    //fill(0); 
    //text("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp, 10, 40);

}


void compassEvent() {
  //pebug(compassHeading);
  compassDEGREE = compassHeading;
}

void locationEvent() {
  //text("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading, 10, 80);
  //pebug("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading);
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
  gravityX = iphone.getAcceleration().x;
  gravityY = -iphone.getAcceleration().y;
  //pebug("x: " + gravityX + " " + "y: " + gravityY);  
}
void mic() {
  microfone = iphone.getMicLevel()*mic_perc;  
  //pebug("Mic: " + microfone);
}
void compass() {
  angleCompass = compassDEGREE + iAngle;
  
  if (angleCompass > 360) {
          angleCompass = angleCompass - 360;
  }
  if (angleCompass < 0) {
          angleCompass = 360 + angleCompass;
  }
  
  //pebug(angleCompass);
  
}


void orientationChanged() {
  pebug(iphone.getOrientation()); 
  pebug(orientation);
}


void shakeEvent() {
  pebug("shaked");
}


PImage video, frame;

int index = 0;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
int videoscale;

boolean loadCamera = false;
boolean checkCamera = false;

void cam() {
  //background(0,0,0,0);
  checkCamera = iphone.checkCamera();
  if (checkCamera && !loadCamera) {
    pebug("4 - getCamera in pde: " + iphone.getCamera());
    video = requestImage(iphone.getCamera());
    loadCamera = true;
  } //end if checkCamera
  if(video.width ==0) {
    pebug("cam loading");
  } else if(video.width == -1) {
    pebug("error load cam");
  } else {
    if(loadCamera) {
      frame = video.get();
      
      pebug("6 - loaded image - ready Pixels Image");
      
      
      float maxCol = 0;

      for (int i=0; i < video.width; i++) {
        for (int j=0; j < video.height; j++) {
          // lies den Farbwert für jeden Pixel aus
          color c = video.get(i, j);
          // Wenn heller als aktuelles Maximum
          // -> ersetze Tracking-Koordinaten
          if (brightness (c) > maxCol) {
            maxCol = brightness (c);
            brightestX = i;
            brightestY = j;
          }
        }
      }
      
      pebug("brigh: " + brightestY + " " + brightestX); 
      
            
      loadCamera = false;
      iphone.updateSquare();
    }
  }
  
  //pebug display
  //image(frame, width/2, height/2, width, height);
  noStroke();
  fill(0,0,255);
  ellipse(width-brightestX*videoscale, brightestY*videoscale, 50, 50);
  
}


/*
function doOnOrientationChange() {
  switch(window.orientation) {  
    case -90:
      orientationMode = "landscape inverse";
    break;
    case 90:
      orientationMode = "landscape";
    break; 
    case 0:
      orientationMode = "portrait";
    break; 
    case 180:
      orientationMode = "inverse";
    break;   
  }   
  pebug(orientationMode);
}
window.addEventListener('orientationchange', doOnOrientationChange);
*/
