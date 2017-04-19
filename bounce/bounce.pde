/*
bouncing ball demo in only 20 line of (actual) code.

first up we're declaring all our variables.
( We're telling the computer how much memory we're gonna use and we're making up names for the each memory chunk )
they're all float(floating point numbers), which means they can be decimals, as well as whole numbers.
*/
float ball_X, ball_Y, ball_VX, ball_VY, ball_R, ball_D;

// Setup is the function which runs once when the program starts up, it's where we...
void setup(){
  size(400, 400); // define the size of the screen,
 
  ball_X = 200;   // and set the initial values for our variables.
  ball_Y = 200;   // these are the X and Y coordinates of the ball. we're starting it right in the middle.
 
  ball_VX = random(-3, 3); // and these two are the velocity.
  ball_VY = random(-3, 3); // note we're using a random number between -3 and 3, so that it's different every time you run the sketch!
 
  ball_R = 10;             // this is the radius of the ball,
  ball_D = 2 * ball_R;     // and the diameter.
}

// Draw is the function that runs repeatedly while the program is running.
// each time it runs it updates the screen, that's what we call a 'frame'.
void draw(){
  background(202); // this is drawing a fresh background over the previous frame.
  // if you comment it out (put "//" in front of it) you'll see the ball leaves a trail.
 
  //these four "if" statements are the collisions for the four walls of the screen:
  if( ball_X - ball_R <= 0 )   ball_VX = ball_VX * -1; // Left.
  if( ball_Y - ball_R <= 0 )   ball_VY = ball_VY * -1; // Top. (yep, that's right. along the y-axis the coordinate system goes from top to bottom.)
  if( ball_X + ball_R >= 400 ) ball_VX = ball_VX * -1; // Right.
  if( ball_Y + ball_R >= 400 ) ball_VY = ball_VY * -1; // Bottom. (it's not that weird. you get used to it.)
  // inside the parenthesis is the condition:
  // we're asking if the coordinate of the ball has gone past the wall
  // by comparing the two numbers. in case it has crossed the line,
  // we invert the sign of the velocity in that axis by it multiplying by -1,
  // so that the ball starts moving the opposite way.
 
  // and this is how ball moves:
  // each frame we add the velocity to the position,
  // incrementing it slowly over time, creating the illusion of motion.
  ball_X = ball_X + ball_VX;
  ball_Y = ball_Y + ball_VY;
 
  // finally, the ellipse function actually draws the ball on the screen.
  ellipse( ball_X, ball_Y, ball_D, ball_D );
}