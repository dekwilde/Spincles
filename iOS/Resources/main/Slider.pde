class MenuSlider {
   
    float st_x;
    float st_y;
    int st_s = 30;
    float st_difx = 0.0; 
    float st_dify = 0.0; 
    float init = 35;
    float end = 285;
    
    
    MenuSlider() {  
      st_x = 160;
      st_y = 100;
    }
    
    void draw() {
      //Draw Line
      line(init, st_y, end, st_y);
      
      // Draw the button
      if (st_x>end) {
        st_x = end;
      }
      if (st_x<init) {
        st_x = init;
      }
      fill(0);
      ellipse(st_x, st_y, st_s, st_s);

      
      mic_perc = (st_x-init) / ((end-init)/100);
      
      //println(perc);
      
      
      if (touch1X > st_x-st_s && touch1X < st_x+st_s && 
      	touch1Y > st_y-st_s && touch1Y < st_y+st_s) {
             st_x = touch1X;  
         } else {
           st_x = st_x;
      }
      
    }
    
 
    
} // end class

