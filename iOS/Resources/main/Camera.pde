PImage video, frame;

int index = 0;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
int videoscale;

boolean loadCamera = false;
boolean checkCamera = false;

void Camera() {
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
