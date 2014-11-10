/* @pjs transparent="true"; preload="text2.png"; */
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word
 */
 
Particle[] particles=new Particle[0];
boolean free=true;  //when this becomes false, the particles move toward their goals

float pAccel=.05;  //acceleration rate of the particles
float pMaxSpeed=2;  //max speed the particles can move at

color bgColor=color(255);

PImage words;  //holds the image container the words
color testColor=color(0);  //the color we will check for in the image. Currently black
 
void setup(){
  words=loadImage("text2.png");
  size(480,320);
  noCursor();
  
  //go through the image, find all black pixel and create a particle for them
  //start by drawing the background and the image to the screen
  background(bgColor);
  image(words,0,0);  //draw the image to screen
  loadPixels();  //lets us work with the pixels currently on screen
  
  //go through the entire array of pixels, creating a particle for each black pixel
  for (int x=0; x<width; x++){
    for (int y=0; y<height; y++){
      if (pixels[GetPixel(x,y)] == testColor){
        particles=(Particle[])append(particles, new Particle(x,y));
      }
    }
  }
  
}

void draw(){
  background(bgColor);
  
  for (int i=0; i<particles.length; i++){
    if (particles[i].y<0){
      //println("TOO FUCKNG HIGH");
    }
    particles[i].Update();
  }
  //saveFrame("pic/edu-####.png");
}


void mousePressed(){
  free=false;
}

//returns the locaiton in pixels[] of the point (x,y)
int GetPixel(int x, int y) {
  return(x+y*width);
}
 
 
