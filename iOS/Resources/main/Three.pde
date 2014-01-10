var r3d = 0;
PShape model;   

void setupThree() {
  model = loadShape("Falcon.obj");
}

void Three() {

  translate(width/2, height/2, -10);
  rotateX(r += 0.001);   
  rotateY(r += 0.001); 
  rotateZ(r += 0.001); 
  scale(10);  
  hint(ENABLE_DEPTH_TEST);
  shape(model);

}
