Particle[] PS; //Here's our array of objects

float G = 0.2;

void setup(){
  size(800, 600);
  
  // initialization for the array...
  PS = new Particle[60];
  // and for each object.
  for( int i = 0; i < PS.length; ++i ) PS[i] = new Particle( random(width), random(height), random(-3, 3), random(-3, 3), random(2, 10) );
}

void draw(){
  background(202);

  for( Particle p : PS ) p.exe(); // here where we're running all our particles.
}

// The particle class.
// each particle object in the sketch is what we call an 'instance' of the class;
// they're all identical in structure, but their variables can have different values.
class Particle{
  float R, D;
  PVector pos, vel, acc;
  boolean alive;
  Particle(float x, float y, float vx, float vy, float r){
    R = r;
    D = R * 2;
    pos = new PVector( x, y );
    vel = new PVector( vx, vy );
    acc = new PVector();
    alive = true;
  }
  void step(){
    vel.add(acc);
    pos.add(vel);
    acc = new PVector();
  }
  void collide_w_screen(){
    if( pos.x - R <= 0 ){
      vel.x *= -1;
      pos.x = R;
    }
    if( pos.y - R <= 0 ){
      vel.y *= -1;
      pos.y = R;
    }
    if( pos.x + R >= width ){
      vel.x *= -1;
      pos.x = width-R;
    }
    if( pos.y + R >= height ){
      vel.y *= -1;   
      pos.y = height - R;
    }
  }
  void gravitate( Particle p ){                                                                     
    PVector grav = new PVector(1,0);                                                                
    grav.setMag( G*(p.D) / sq( constrain(dist(pos.x, pos.y, p.pos.x, p.pos.y), 1, 100000) ) );                           
    grav.rotate(atan2(p.pos.y - pos.y, p.pos.x - pos.x ));                                          
    acc.add(grav);
  }
  void display(){
    ellipse( pos.x, pos.y, D, D );
  }
  void exe(){ // the method that gets called in draw().
    if( alive ){
      step();
      collide_w_screen();
      display();
    }
  }
}