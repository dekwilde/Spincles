PImage video;
boolean loadCamera = false;
int brightestX, brightestY, brightestValue;

void Camera() {
  ctx.clearRect(0,0,width,height);// part of the canvasAPI that creates a clear rect
  //background(0,0,0,0);
  checkCamera = iphone.checkCamera();
  if (checkCamera && !loadCamera) {
    println("requestImage: " + iphone.getCamera());             
    video = requestImage(iphone.getCamera());
    loadCamera = true;
  } //end if checkCamera
  
  
  
  
  if (video.width == 0) {
    println("loading");
  } else if (video.width == -1) {
    println("error load image");
  } else {
    if(loadCamera) {
      println("loaded Camera");
      brightestX = 0; // X-coordinate of the brightest video pixel
      brightestY = 0; // Y-coordinate of the brightest video pixel
      brightestValue = 0;
      
      //image(video, 0,0, video.width, video.height); // get the pixels      
      video.loadPixels();
      int index = 0;
      for (int cy = 0; cy < video.height; cy++) {
        for (int cx = 0; cx < video.width; cx++) {
          int pixelValue = video.pixels[index];
          float pixelBrightness = brightness(pixelValue);
          if (pixelBrightness > brightestValue) { // if > brightness if < darkness
            brightestValue = pixelBrightness;
            brightestY = cy;
            brightestX = cx;
          }
          index++;
        }
      }
      
      println(brightestX + " " + brightestY);
      loadCamera = false;
      iphone.updateSquare();
    }
  }
  
  
  // Draw a large, yellow circle at the brightest pixel
  //image(video, -20, -50, video.width*10, video.height*10);
  fill(255, 204, 0, 128);
  ellipse(brightestX*10, brightestY*10, 20, 20);
}
