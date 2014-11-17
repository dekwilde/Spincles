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
        println("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp);

    }
    //fill(0); 
    //text("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp, 10, 40);

}


void compassEvent() {
  //println(compassHeading);
  compassDEGREE = compassHeading;
}

void locationEvent() {
  //text("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading, 10, 80);
  println("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading);
}

void pointCompass() {
    currentLT = lt;
    currentLG = lg;
        
    diffLT = targetLT - currentLT;
    diffLG = targetLG - currentLG;
    
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
    //println(targetDEGREE);
}

void acceMic() {
  // init vars DONT MOVE    
  gravityX = iphone.getAcceleration().x;
  gravityY = -iphone.getAcceleration().y;
  
  println("x: " + gravityX + " " + "y: " + gravityY);
  println("Mic: " + iphone.getMicLevel());
  
  microfone = pow(iphone.getMicLevel(), 1) * mic_perc;                

}




