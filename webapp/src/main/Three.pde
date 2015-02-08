var r3d = 0;
PShape model;   

void setupThree() {
  model = loadShape("Falcon.obj");
  
}

void Three() {
  
  pushMatrix();
  hint(DISABLE_DEPTH_TEST);
  translate(width/2, height/2, 80);
  rotateX(r3d += 0.01);
  rotateY(r3d += 0.01);
  rotateZ(r3d += 0.01); 
  scale(8);  
  hint(ENABLE_DEPTH_TEST);
  shape(model);
  popMatrix();
}
