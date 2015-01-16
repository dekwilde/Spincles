PImage video, frame;

int index = 0;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel

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
      
      
      float brightestValue = 50; // Brightness of the brightest video pixel
      // Search for the brightest pixel: For each row of pixels in the video image and
      // for each pixel in the yth row, compute each pixel's index in the video
      video.loadPixels();
      for (int picy = 0; picy < video.height; picy++) {
        for (int picx = 0; picx < video.width; picx++) {
          // Get the color stored in the pixel
          int pixelValue = video.pixels[index];
          // Determine the brightness of the pixel
          float pixelBrightness = brightness(pixelValue);
          // If that value is brighter than any previous, then store the
          // brightness of that pixel, as well as its (x,y) location
          if (pixelBrightness > brightestValue) {
            brightestValue = pixelBrightness;
            brightestY = picy;
            brightestX = picx;
          }
          index++;
        }
      }
      
      pebug("brigh: " + brightestY + " " + brightestX); 
      
            
      loadCamera = false;
      iphone.updateSquare();
    }
  }
  
  image(frame, width/2, height/2, width, height);
  //pebug display
  noStroke();
  fill(0,0,255);
  ellipse(brightestX, brightestY, 50, 50);
  
}
