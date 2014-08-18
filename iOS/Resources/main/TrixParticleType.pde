TrixParticle trixBAD;
TrixParticle trixGOOD;
ArrayList particles;

class TrixParticle {
  int num;
  int amount = 5;
  String tp;
  
  TrixParticle(String type) {
    tp = type;
    particles = new ArrayList();
    num = 0;
  }
  
  void draw(){
    num += 1;
    if(num<amount) {
      particles.add(new Particle(tp));
    }
    for(int i=0; i < particles.size(); i++){
      Particle p = (Particle) particles.get(i);
      p.run();
      //p.gravity();
      p.display();
      p.conect();
      p.dead();
      if(p.death){
        particles.remove(i);
      }
    }
  }
  
  
}


class Particle{
  float x;
  float y;
  float xspeed = 0;
  float yspeed = 0;
  float myDiameter= 2;
  float distance = 90;
  float delay = random(0.001, 0.01);
  float elastic = 0.98;
  int life =0, lifeTime = 50+int(random(200));
  boolean death = false;
  String tp;

  
  Particle(String type){
    tp = type;
    if(tp == "good") {
      x= int(random(width));
      y= int(random(height));
    }
    if(tp == "bad") {
      x= spinX;
      y= spinY;
      xspeed= random(-2, 2);
      yspeed= random(-2, 2);  
    }
  }
    
  void run(){
    if(tp == "good") {
      float dx = spinX - x;
      float dy = spinY - y;
      xspeed = dx*delay+xspeed*elastic;
      yspeed = dy*delay+yspeed*elastic;
      x = x+xspeed;
      y = y+yspeed;
    }
    if(tp == "bad") {
      x = x+xspeed;
      y = y+yspeed; 
    }
    
  }
    
  void display(){
    noStroke();
    fill(0);
    ellipse(x, y, 2, 2);
  }
  
  void gravity(){
    yspeed += 0.01;
  }
  
  void dead() {
    life += 1;
    if(life>lifeTime) {
      death = true;  
    } else {
      death = false;
    } 
  }
  
  void conect() {
    for (int i = 0; i <particles.size() ; i++) {
      
      Particle other = (Particle) particles.get(i);
 
      if (this != other) {
        if (dist(x, y, other.x, other.y)<distance) {
          stroke(0,0,0,70);
          line(x, y, other.x, other.y);
          noStroke();
          fill(0, 0, 0, random(100));
          ellipse(x,y,myDiameter*5,myDiameter*5);
        }
      }
    } //end for
  }
  
    
}
