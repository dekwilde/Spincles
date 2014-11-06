PImage video;

int index = 0;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel

boolean loadCamera = false;
boolean checkCamera = false;

void Camera() {
  //background(0,0,0,0);
  checkCamera = iphone.checkCamera();
  if (checkCamera && !loadCamera) {
    println("4 - getCamera in pde: " + iphone.getCamera());
    video = requestImage(iphone.getCamera());
    loadCamera = true;
  } //end if checkCamera
  
 
    if(loadCamera) {
      
      
      
      
      println("6 - loaded image - ready Pixels Image");
      
      /*
      float brightestValue = 0; // Brightness of the brightest video pixel
      // Search for the brightest pixel: For each row of pixels in the video image and
      // for each pixel in the yth row, compute each pixel's index in the video
      video.loadPixels();
      for (int y = 0; y < video.height; y++) {
        for (int x = 0; x < video.width; x++) {
          // Get the color stored in the pixel
          int pixelValue = video.pixels[index];
          // Determine the brightness of the pixel
          float pixelBrightness = brightness(pixelValue);
          // If that value is brighter than any previous, then store the
          // brightness of that pixel, as well as its (x,y) location
          if (pixelBrightness > brightestValue) {
            brightestValue = pixelBrightness;
            brightestY = y;
            brightestX = x;
          }
          index++;
        }
      }
      */
      
            
      loadCamera = false;
      iphone.updateSquare();
    }
  
  
  // Draw a large, yellow circle at the brightest pixel
  //image(video, 0, 0, video.width, video.height);
  image(video, 0, 0, width/2, height/2);
  noStroke();
  fill(0,0,255);
  ellipse(brightestX*10, brightestY*10, 50, 50);
}

