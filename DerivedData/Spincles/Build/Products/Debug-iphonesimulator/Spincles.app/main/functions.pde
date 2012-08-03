void gestureStarted() {
	startAngle = iAngle;
	startEscala = iScale;
}

void gestureChanged() {
	iAngle = startAngle + gestureRotation;
	iScale = startEscala * gestureScale;
	if (iAngle > 360) {
		iAngle = iAngle - 360;
	}
	if (iAngle < 0) {
		iAngle = 360 + iAngle;
	}
}

void gestureStopped() {
	startAngle = iAngle;
	startEscala = iScale;
}

void touch1Started() {
  //GEsture Drag Spincles
  if (touch1X > bx-bs && touch1X < bx+bs && 
	touch1Y > by-bs && touch1Y < by+bs) {
     bover = true;  
  }
  
  if(bover) { 
    sound2.setVolume(100);
    locked = true;
  } else {
    locked = false;

  }
  bdifx = touch1X-bx; 
  bdify = touch1Y-by; 
}

void touch1Moved() {
  if(locked) {
    sound2.setVolume(100);
    bx = touch1X-bdifx; 
    by = touch1Y-bdify;
  }
}

void touch1Stopped() {
  if (infoShow && pInfo<1) {
      buttonLink(90, 458, 60, 12, "http://spincles.dekwilde.com.br/support");
      buttonLink(230, 458, 60, 12, "mailto:spincles@dekwilde.com.br");
  }
  sound2.setVolume(0);
  // click info var
  //btClose.overButton = false;
  //btInfo.overButton = false;
  //btSupport.overButton = false;
  //btContact.overButton = false;
  
  // gesture var
  //bover = false;
  locked = false;
}


void buttonLink(int pX, int pY, int Width, int Height, char Str) {
      if (touch1X > pX-Width && touch1X < pX+Width && touch1Y > pY-Height && touch1Y < pY+Height) {
        println("link out " + Str);
        link(Str, "_new");
        // infoShow = false;
      }
}
