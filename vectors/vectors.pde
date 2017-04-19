PVector pos, vel;
float R, D;

void setup(){
  size(400, 400);
 
  pos = new PVector( 200, 200 );
  vel = new PVector( random(-3, 3), random(-3, 3) );
  R = 10;
  D = 2 * R;
}

void draw(){
  background(202);

  if( pos.x - R <= 0 )   vel.x *= -1;
  if( pos.y - R <= 0 )   vel.y *= -1;
  if( pos.x + R >= 400 ) vel.x *= -1;
  if( pos.y + R >= 400 ) vel.y *= -1;
  
  //pos.x += vel.x;
  //pos.y += vel.y;
  pos.add( vel );
 
  ellipse( pos.x, pos.y, D, D );
}