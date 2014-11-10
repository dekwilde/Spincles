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
 
 
class Particle{
 float x,y;  //x and y locaiton of particle
 float xVel, yVel;  //x and y velocity of particle
 float xVelMax, yVelMax;  //will hold the maximum velocity for the particle
 float xAccel, yAccel;  //x and y accelaration
 float ang;  //angle ind egrees that particle should be moving at
 
 float xGoal, yGoal;  //the point that the particle wants to return to
 
 
 //constructor
 Particle(float newXGoal, float newYGoal){
   x=random(width);
   y=random(height);
   xGoal=newXGoal;
   yGoal=newYGoal;
   ang=random(0,2*PI);  //we're using radians
   xVel=0;
   yVel=0;
   
   xAccel=pAccel*cos(ang);
   yAccel=pAccel*sin(ang);
 }
 
 //deals with the frame to frame changes of the particle
 void Update(){
   //println(degrees(ang));
   x+=xVel;
   y+=yVel;
   
   xVel+=xAccel;
   yVel+=yAccel;
   
   //if the particles are not free, move this particle toward its goal
   if (!free){
     //get the ange of the thing point the particle should move toward
     ang= atan2(yGoal-y, xGoal-x);
     xAccel=pAccel*cos(ang);
     yAccel=pAccel*sin(ang);
     
     //slow it down a lot if it's close to the point
     if (abs(x-xGoal) <xVel*3 || abs(y-yGoal)<yVel*3){
       xVel*=0.8;
       yVel*=0.8;
     }
   }else{
     //make it bounce off edges if it's free moving
     CheckEdge();
   }
   
   
   /* MIGHT NOT NEED THIS
   //make sure we're not above the max speed
   xVelMax=pMaxSpeed*cos(ang);
   yVelMax=pMaxSpeed*sin(ang);
   
   if (xVel>0 && xVel>xVelMax)
     xVel=xVelMax;
   if (xVel<0 && xVel< -xVelMax)
     xVel=-xVelMax;
     
   if (yVel>0 && yVel>yVelMax)
     yVel=yVelMax;
   if (yVel<0 && yVel< -yVelMax)
     yVel=-yVelMax;
     
   println(abs(xVel)+abs(yVel));
   */
     
   
   Draw();
 }
 
 //draws the particle on screen
 void Draw(){
   point (x,y);
 }
  
 void CheckEdge(){
  
   if (x>width || x<0 || y>height || y<0){
     xVel=0;
     yVel=0;
     if (y>height){
       yAccel*=-1;
       y=height-1;
     }else if (y<0){
       yAccel*=-1;
       y=1;
     }else if (x>width){
       xAccel*=-1;
       x=width-1;
     }else if (x<0){
       xAccel*=-1;
       x=1;
     }
   }
   
   
   /*
   if (x>width || x<0){
     ang+=PI;
     println("hitEdge");
   }
   if (y>height || y<0){
     ang+=PI;
     println("hitEdge");
   }
   */
 }
  
  
}

