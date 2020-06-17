//Vehicle v;
FlowField f;
void setup(){
  fullScreen();
  //v = new Vehicle(new PVector(200,200) );
  f = new FlowField();
 }
void draw(){
  background(0);
   f.display();
 // v.follow(f);
//  v.update();
//  v.display();
}
