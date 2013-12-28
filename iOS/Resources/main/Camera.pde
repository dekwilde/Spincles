PImage video;
color track;
int closestX = 0;
int closestY = 0;
  
int loc = 0;

boolean loadCamera = false;

void Camera() {
  ctx.clearRect(0,0,width,height);// part of the canvasAPI that creates a clear rect
  //background(0,0,0,0);
  checkCamera = iphone.checkCamera();
  if (checkCamera && !loadCamera) {
    println("requestImage: " + iphone.getCamera());
    track = color(20);
    //prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
    //prevFrame.updatePixels();
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
      video.loadPixels();      
      loc = 0;
      float closestDiff = 200.0f;
      for (int cx = 0; cx < video.width; cx ++ ) {
        for (int cy = 0; cy < video.height; cy ++ ) {
          color current = video.pixels[loc];
           
          
          float r1 = red(current); float g1 = green(current); float b1 = blue(current);
          float r2 = red(track); float g2 = green(track); float b2 = blue(track);
          float d = dist(r1,g1,b1,r2,g2,b2);
                     
          if (d < closestDiff) {
            closestDiff = d;
            closestX = cx;
            closestY = cy;
          }
          loc++;
        }
      }
            
      loadCamera = false;
      iphone.updateSquare();
    }
  }
  
  
  // Draw a large, yellow circle at the brightest pixel
  image(video, 0, 0, video.width, video.height);
  noStroke();
  fill(200,0,0);
  ellipse(closestX*10-40, closestY*10-100, 20, 20);
}
