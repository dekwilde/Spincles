PImage video;
PImage prevFrame;
  
float threshold;
int Mx = 0;
int My = 0;
int ave = 0;
  
int ballX = 16;
int ballY = 24;
int loc = 0;
int rsp = 25;
float prc = 5;

boolean loadCamera = false;

void Camera() {
  ctx.clearRect(0,0,width,height);// part of the canvasAPI that creates a clear rect
  //background(0,0,0,0);
  checkCamera = iphone.checkCamera();
  if (checkCamera && !loadCamera) {
    println("requestImage: " + iphone.getCamera());
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
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
      prevFrame.loadPixels();
       
      Mx = 0;
      My = 0;
      ave = 0;
      loc = 0;
      threshold = 30;
      for (int cx = 0; cx < video.width; cx ++ ) {
        for (int cy = 0; cy < video.height; cy ++ ) {
          color current = video.pixels[loc];     
          color previous = prevFrame.pixels[loc];
           
          
          float r1 = red(current); float g1 = green(current); float b1 = blue(current);
          float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
          float diff = dist(r1,g1,b1,r2,g2,b2);
           
           
          if (diff > threshold) {
            threshold = diff;
            Mx = cx;
            My = cy;           
          }
          loc++;
        }
      }
      
      println("Mx " + Mx + " " + "My " + My);
      
      loadCamera = false;
      iphone.updateSquare();
    }
  }
  
  
  // Draw a large, yellow circle at the brightest pixel
  image(video, video.width, 0, video.width, video.height);
  image(prevFrame, 0, video.height, video.width, video.height);
  noStroke();
  fill(200,0,0);
  ellipse(Mx*10-40, My*10-100, 20, 20);
}
