ArrayList<Particle> PS; //Here's our array of objects
IntList marked;
float G = 0.2, one_over_pi = 1/PI;

float cx, cy;
float torus_x, torus_y, torus_l, torus_b, torus_w, torus_h;  // position and dimensions of the torus box.

byte background_mode = 0;
boolean record = true; //false; //

void setup(){
  size(1000, 500);
  cx = width/2;
  cy = height/2;
  //colorMode(HSB);
  
  float m = 50;
  torus_x = -m;                        // the box is bigger than the screen
  torus_y = -m;                        // to hide the moment when they 'pop' to the other side.
  torus_l = width + m;
  torus_b = height + m;                // this could be facier if you drew a duplicate when the particle is near the edge.
  torus_w = width + (2*m);             // I leave that as a challenge to you!
  torus_h = height + (2*m);
  
  // initialization for the ArrayList...
  PS = new ArrayList();
  // and for each object.
  for( int i = 0; i < 60; ++i ) PS.add( new Particle( random(width), random(height), random(-2, 2), random(-2, 2), random(2, 10) ) );
   
  marked = new IntList();
  
  background(0);
  noStroke();
}

void draw(){
  switch( background_mode ){            // switching through the background modes:
    case 0:
      background(0);                    // no tracks. ( putting a fresh black screen over the previous frame )
      break;
    case 1:                             // fading tracks. ( we draw a semi-transparent screen over the previous frame )
      fill(0, 15);
      rect( 0, 0, width, height );      
      break;
  }                                     // (MODE 2) full tracks. ( do nothing! let the frames draw on top of one another.)
 
 
  //This is where we run the the gravity between all particles.
  for(int i = 1; i < PS.size(); ++i){
    for(int j = 0; j < i; j++){
      if( i != j ) PS.get(i).gravitate_in_torus(PS.get(j) ); 
    }
  }
  
  //rudimentary inelastic collisions
  for(int i = 1; i < PS.size(); ++i){               // loop through the particle array
    for(int j = 0; j < i; j++){                     // only checking each pair of objects once.        
      if( PS.get(i).pos.dist( PS.get(j).pos ) < (PS.get(i).R + PS.get(j).R) * 0.75 ){
        boolean alreadymarked = false;
        for(int k = 0; k < marked.size(); ++k){
          if( i == marked.get(k) || j == marked.get(k) ){
            alreadymarked = true;
            break;
          }
        }
        if( alreadymarked ) continue;
        int a = ( PS.get(i).R > PS.get(j).R )? i : j;                 // the larger one
        int b = ( a == i )? j : i;                                    // absorbs the smaller one.
        float ratio = PS.get(b).area() / PS.get(a).area();
        PS.get(a).vel.add( PS.get(b).vel.mult( ratio ) );             // gains it's kinetic energy,
        PS.get(a).R = sqrt( sq(PS.get(a).R) + sq(PS.get(b).R) );      // it's "mass" (area),
        PS.get(a).D = PS.get(a).R * 2;
        PS.get(a).c = lerpColor( PS.get(a).c, PS.get(b).c, ratio );   // and mixes it's color with it's own.
        marked.append(b);                                             // mark the small one for deletion.
      }
    }
  }
  
  marked.sort();
  for( int i = marked.size()-1; i >= 0 ; --i ) PS.remove( marked.get(i) ); // delete the marked ones.
  marked = new IntList();
  

  for( Particle p : PS ) p.exe();          // here's where we're running all our particles.
  
  
  if( record ){
    saveFrame( year()+"-"+month()+"-"+day()+" "+nf( hour(), 2 )+"."+nf( minute(), 2 )+"."+nf(second(), 2)+" ######.png" );
  }
}

void mousePressed(){
  // pop particles upon click!
  for(int i = 0; i < PS.size(); ++i){
    if( dist( PS.get(i).pos.x, PS.get(i).pos.y, mouseX, mouseY ) < PS.get(i).R ){
      float total_area = 0;     
      while(total_area < PS.get(i).area()){
        float area = random(35, 85);
        if( total_area + area > PS.get(i).area() ){
          area = PS.get(i).area() - total_area;
        }
        total_area += area;
        float a = random( TWO_PI );
        float v = random( 2, 4 );
        PS.add( new Particle( PS.get(i).pos.x, PS.get(i).pos.y, v*cos(a), v*sin(a), sqrt(area*one_over_pi) ) );
        for(int k = 0; k < 12; ++k) PS.get(PS.size()-1).step();
      }
      marked.append(i);
      break;
    }
  }
}

void keyPressed(){
  if( key == 'b' || key == 'B' ){                  // press B to flip through background modes.
    if( background_mode < 2 ) ++background_mode;
    else background_mode = 0;
  }
  if( key == 'r' || key == 'R' ){                  // press R to record. (this makes the sketch very slow!)
    record = !record;  
  }
}

// The particle class.
// each particle object in the sketch is what we call an 'instance' of the class;
// they're all identical in structure, but their variables can have different values.
class Particle{
  float R, D;
  PVector pos, vel, acc;
  color c;
  Particle(float x, float y, float vx, float vy, float r){
    R = r;
    D = R * 2;
    pos = new PVector( x, y );
    vel = new PVector( vx, vy );
    acc = new PVector();
    c = color( random(255), random(255), 0 );
  }
  Particle(float x, float y, float vx, float vy, float r, color co){
    R = r;
    D = R * 2;
    pos = new PVector( x, y );
    vel = new PVector( vx, vy );
    acc = new PVector();
    c = co;
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
  
  void torus(){
    if( pos.x < torus_x ){
      pos.x = torus_l;
    }
    if( pos.y < torus_y ){
      pos.y = torus_b;
    }
    if( pos.x > torus_l ){
      pos.x = torus_x;
    }
    if( pos.y > torus_b ){  
      pos.y = torus_y;
    }
  }
  
  float area(){
    return PI * sq(R);
  }
  
  void gravitate( Particle p ){    
    PVector grav = new PVector(1,0);                                                                
    grav.setMag( G*(p.area()) / sq( constrain(dist(pos.x, pos.y, p.pos.x, p.pos.y), 1, 100000) ) );                           
    grav.rotate(atan2(p.pos.y - pos.y, p.pos.x - pos.x ));                                          
    acc.add(grav);
  }
  
  void gravitate_in_torus( Particle p ){
    PVector grav = new PVector(1,0);
    PVector[] q = { p.pos.get(), 
                    new PVector( p.pos.x + torus_w, p.pos.y ), new PVector( p.pos.x - torus_w, p.pos.y ),
                    new PVector( p.pos.x, p.pos.y + torus_h ), new PVector( p.pos.x, p.pos.y - torus_h ), 
                    new PVector( p.pos.x + torus_w, p.pos.y + torus_h ), new PVector( p.pos.x - torus_w, p.pos.y - torus_h ), 
                    new PVector( p.pos.x - torus_w, p.pos.y + torus_h ), new PVector( p.pos.x + torus_w, p.pos.y - torus_h ) };
    float[] d = new float[9];
    for(int i = 0; i < 9; ++i ) d[i] = dist(pos.x, pos.y, q[i].x, q[i].y);   
    float dist = min( d );
    grav.setMag( G / sq( constrain( dist, 1, 100000) ) );
    int n = 0;
    for(int i = 0; i < 9; ++i ){
      if( dist == d[i] ){
        n = i;
        break;
      }
    }
    grav.rotate(atan2(q[n].y - pos.y, q[n].x - pos.x ));   
    
    acc.add( grav.get().mult(  p.area() ) );                    // this version of the gravitate method is also mutual.
    p.acc.add( grav.get().rotate(PI).mult( this.area() ) );     // we only run it once for each pair, which makes things more efficient!
  }
  
  void display(){
    fill(c);
    ellipse( pos.x, pos.y, D, D );
  }
  
  void exe(){ // the method that get's called in draw().
    step();
    torus();
    //collide_w_screen();
    display();
  }
}