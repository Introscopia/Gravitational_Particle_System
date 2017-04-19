int N, I, J;
float L, m, mm;

void setup(){
  size(400, 400);
  frameRate( 3 );
  textAlign( CENTER, CENTER );
  textSize( 20 );
  N = 8;
  L = width / float(N);
  m = 3;
  mm = m * 2;
  I = 1;
  J = 0;
}
void draw(){
  background(255);
  
  stroke(0);
  for(int i = 1; i < N; ++i){
    float x = map( i, 0, 8, 0, width );
    line( x, 0, x, height );
    line( 0, x, width, x );
  }

  for(int i = 1; i < N; ++i){ // all possible unique pairs 
    for(int j = 0; j < i; j++){
      fill( #A1EBFC );
      stroke( #4CB7D1 );
      rect( (i*L)+m, (j*L)+m, L-mm, L-mm );
    }
  }

  
  for(int i = 1; i < N; ++i){ // the redundant pairs
    for(int j = 0; j < i; j++){
      fill( #FAAAA2 );
      stroke( #D1594C );
      rect( (j*L)+m, (i*L)+m, L-mm, L-mm );
    }
  }
  
  for(int i = 0; i < N; ++i){ // the mirror pairs
    fill( #D3D3D3 );
    stroke( #9B9B9B );
    rect( (i*L)+m, (i*L)+m, L-mm, L-mm );
  }
  
  // animation
  fill( #A1EBFC );
  stroke( #4CB7D1 );
  rect( (I*L)+m, (J*L)+m, L-mm, L-mm );
  println( I, J );
  fill(0);
  text( I + "," + J, (I+0.5)*L, (J+0.5)*L );
  text( J + "," + I, (J+0.5)*L, (I+0.5)*L );
  ++J;
  if( J == I ){
    ++I;
    J = 0;
  }
  if( I >= N ){
    I = 1;
    J = 0;
  }
  
  saveFrame( "###.png" );
}