int lastTime = 0;
   char lt;
   char lg;
   char al;
   char hd;
   char sp;

void location()
{
   int currentTime = millis();
   if (currentTime > lastTime+3000) {

        Location loc = iphone.getLocation();
        lt = loc.latitude;
        lg = loc.longitude;
        al = loc.altitude;
        hd = loc.heading;
        sp = loc.speed;
        
        lastTime = currentTime;
        
    }
    fill(0); 
    text("LT:" + lt + " LG:" + lg + " AL:" +al, 10, 40);
    //text("HD:" + hd + " SP:" + sp, 10, 60);
    iphone.getCurrentLocation();
}


void compassEvent() {
  println(compassHeading);
}

void locationEvent() {
  text("LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude, 10, 80);
}

void shakeEvent()
{
  println("shaked");
}






