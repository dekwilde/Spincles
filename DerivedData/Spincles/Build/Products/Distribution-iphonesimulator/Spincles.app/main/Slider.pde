class Slider {
  
      
    float bx;
    float by;
    int bs = 20;
    float bdifx = 0.0; 
    float bdify = 0.0; 
    float init = 30;
    float end = 290;
    
    
    Slider() {  
      bx = width/2.0;
      by = 40;
      rectMode(RADIUS);  
    }
    
    void frame() {
      //Draw Line
      line(init, by, end, by);
      
      // Draw the button
      if (bx>end) {
        bx = end;
      }
      if (bx<init) {
        bx = init;
      }
      ellipse(bx, by, bs, bs);
      
      mic_perc = (bx-init) / ((end-init)/100);
      
      //println(perc);
      
    }
    
    void touch() {
        if (touch1X > bx-bs && touch1X < bx+bs && 
      	touch1Y > by-bs && touch1Y < by+bs) {
              bdifx = touch1X-bx;  
         } else {
              bx = touch1X-bdifx; 
        }
    }
    
} // end class

