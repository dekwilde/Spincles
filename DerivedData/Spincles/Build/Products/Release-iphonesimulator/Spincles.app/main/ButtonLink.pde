class ButtonLink {
    boolean overButton = false;
    int pX;
    int pY;
    int Width;
    int Height;   
    
    ButtonLink(int x, int y, int W, int H) {  
      pX = x;
      pY = y;
      Width = W;
      Height = H;
    }    
    void frame() {
        checkButton(); 
        //fill(255);
        //rect(pX, pY, Width, Height);
    }
    void checkButton() {
          if (touch1X > pX-Width && touch1X < pX+Width && touch1Y > pY-Height && touch1Y < pY+Height) {
            overButton = true;   
          } else {
            overButton = false;
          }
    }
}
