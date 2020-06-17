
class Vehicle
{
  PVector loc;
  PVector acc;
  PVector v;
  float size;
  float maxSpeed;
  float maxForce;
  Vehicle(PVector l){
    loc = l;
    acc = new PVector(random(-3,3), random(-3,3) ) ;
    v = new PVector();
    maxSpeed = 5;
    maxForce = 0.5;
    size = 15;    
  }
  void display(){
   float theta = v.heading() + PI/2;
    fill(0,255,0);
    stroke(0);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    endShape(CLOSE);
    popMatrix();
  }
  void checkEdges(){
    if(loc.x > width){
      loc.x = 25;
    }
    if(loc.x < 0){
      loc.x = width - 25;
    }
    if(loc.y > height){
      loc.y = 25;
    }
    if(loc.y < 0){
      loc.y = height - 25;
    }
  }
  void update()
  {
    v.add(acc);
    v.limit(maxSpeed);
    checkEdges();
    
    loc.add(v);
    
    acc.mult(0);
  }
  void applyForce(PVector force){
    acc.add(force);
  }
  void arrive(PVector target)
  {
    PVector desired = PVector.sub(target, loc);
    float dist = desired.mag();
    desired.normalize();
    if(dist < 100){
        float m = map(dist, 0, 70, 0, maxSpeed);
        desired.mult(m);
    }
    else{
      desired.mult(maxSpeed);
    }
    PVector force = PVector.sub(desired, v);
    force.limit(maxForce);
    applyForce(force);
  }
  void flee(PVector target)
  {
    PVector desired = PVector.sub(loc, target);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector force = PVector.sub(desired, v);
    force.limit(maxForce);
    applyForce(force);
  }
  void follow(FlowField flow){
    PVector desired = flow.lookup(loc);
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, v);
    steer.limit(maxForce);
    applyForce(steer);
  }
};
class FlowField{
  PVector[][] field;
  int rows,cols;
  float res;
  FlowField(){
    res = 50;
    rows = int(width/res);
    cols = int(height/res);
    field = new PVector[rows][cols];
    float yoff = 0;
    for(int i = 0; i < rows; ++i){
      float xoff = 0;
      for(int j = 0; j < cols; ++j){
        float theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
        field[i][j] = new PVector(cos(theta),sin(theta) );
        xoff+=0.1;  
      }
      yoff += 0.1;
    }
  }
  void display(){
    for(int i = 0 ; i < rows; ++i){
      for(int j = 0; j < cols; ++j){
        float x = i*res + res/2;
        float y = j*res + res/2;
        float x1 = x+(field[i][j].x*20); 
        float y1 = y + (field[i][j].y *20);
        stroke(255,255,255);
        fill(255,255,255);
        line(x,y,x1 ,y1  );
        ellipse(x1,y1, res/10, res/10);  
      }
    }
  }
  PVector lookup(PVector loc){
    int row= int(loc.x/res);
    int col = int(loc.y/res);
    return field[row][col].get();
  } 
}
