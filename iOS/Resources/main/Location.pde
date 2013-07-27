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
        iphone.getCurrentLocation();
        println("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp);

    }
    fill(0); 
    text("location LT:" + lt + " LG:" + lg + " AL:" +al + " HD:" + hd + " SP:" + sp, 10, 40);

}


void compassEvent() {
  //println(compassHeading);
}

void locationEvent() {
  text("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading, 10, 80);
  println("locationEvent LT:" + locLatitude + " LG:" + locLongitude + " AL:" +locAltitude + " HD:" + locHeading);
}

void shakeEvent()
{
  println("shaked");
}






