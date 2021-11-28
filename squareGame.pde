int side = 50;        // Width of the shape
float xpos1, ypos1, xpos2, ypos2, xpos3, ypos3;    // Starting position of shape
float xposs, yposs, yposm, yposl , yposi;  //starting positions for the starting buttons.
int colorr1 = 255;
int colorBoardWidth = 3;
int colorr2, colorg2, colorb2;
int hism = 0;
int himed = 0;
int hilg = 0;
ArrayList<Integer> reds = new ArrayList<Integer>();
ArrayList<Integer> greens = new ArrayList<Integer>();
ArrayList<Integer> blues = new ArrayList<Integer>();
boolean block = false;
int score = 0;
int winScore;
float passedTime;
float savedTime;
float timer = 60.0;
float time;
boolean play = false;
boolean small = false;
boolean medium = false;
boolean large = false;
boolean instructions = false;
boolean back = false;
boolean hasWon = false;
boolean hasLost = false;
boolean timeLimit = true;

void setup() 
{
  size(900, 600);
  noStroke();
  frameRate(30);
  // Set the starting position of the shape
 xposs = width/4;
 yposs = height/4;
 yposm = height/4 + side;
 yposl = height/4+2 * side;
 yposi = height/4 + 3 * side;
 surface.setResizable(true);
}

void draw() 
{
  background(102);
  if(hasWon){
    win();
  }
  else if(hasLost){
    finalScore();
  }
  else if(play){
    game();
  }
  else if(instructions){
    instruction();
  }
  else{
    opening();
  }
}
void opening() {
  fill(0);
  textSize(side);
  text("Small", xposs, yposs + side);
  if(timeLimit){
    text("Time Limit", width - xposs * 1.5, yposs + side);
  }
  else{
    text("Speedrun", width - xposs * 1.5, yposs + side);
  }
  text("Medium", xposs, yposm + side);
  text("Large", xposs, yposl + side);
  text("Instructions", xposs, yposi + side);
  if(timeLimit){
    text("hi: " + hism, xposs - 3* side, yposs + side);
    text("hi: " + himed, xposs - 3* side, yposm + side);
    text("hi: " + hilg, xposs - 3* side, yposl + side);
  }
}
void instruction() {
  fill(0);
  textSize(side);
  text("move with wasd", xposs-side, yposs+side);
  text("move red square to", xposs-side, yposm+side);
  text("the other color block", xposs-side, yposl + side);
  text("fill block on the right to win", xposs-side, yposi+side);
  text("BACK", xposs-side, yposi+2*side);
}
void game(){
  fill(colorr1, 0, 0);
  square(xpos1, ypos1, side);
  if(!block){
    generateBlock();
    if(xpos1 == xpos2 && ypos1 == ypos2){
      generateBlock();
    }
    block = true;
  }
  fill(colorr2, colorg2, colorb2);
  square(xpos2, ypos2, side);
  eaten();
  textSize(side);
  fill(0);
  text(score, (width - side * 3)/2, side);
  timePassed();
  blocks();
  if(winScore == score){
    hasWon = true;
  }
}
void keyPressed(){
  if(key == 'a' && xpos1 > 0){
    xpos1 -= side;
  }
  if(key == 'w' && ypos1 > side){
    ypos1 -= side;
  }
  if(key == 'd' && xpos1 < width - side*(1+colorBoardWidth)){
    xpos1 += side;
  }
  if(key == 's' && ypos1 < height - side){
    ypos1 += side;
  }
}
void mouseClicked(){
  if(instructions){
    if(mouseX > xposs && mouseX < (xposs + side*6) && mouseY > yposi && mouseY < yposi + 2 * side){
      instructions = false;
    }
  }
  else if (hasWon){
    if(mouseX > 0+side*4 && mouseX < (0+side*4 + side*12) && mouseY > height/2+side*2.5 && mouseY < yposs + height/2+side*4.5){
      reset();
    }
  }
  else if (hasLost){
    if(mouseX > 0+side*4 && mouseX < (0+side*4 + side*12) && mouseY > height/2+side*2.5 && mouseY < yposs + height/2+side*4.5){
      reset();
    }
  }
  else if(!play){
    if(mouseX > xposs && mouseX < (xposs + side*6) && mouseY > yposs && mouseY < yposs + side){
      surface.setSize(500, 400);
      timer = 15.0;
      colorBoardWidth = 2;
      starting();
      small = true;
    }
    else if(mouseX > xposs && mouseX < (xposs + side*6) && mouseY > yposm && mouseY < yposm + side){
        surface.setSize(900, 600);
        timer = 55.0;
        colorBoardWidth = 3;
        starting();
        medium = true;
    }
    else if(mouseX > xposs && mouseX < (xposs + side*6) && mouseY > yposl && mouseY < yposl + side){
        surface.setSize(1000, 800);
        timer = 180.0;
        colorBoardWidth = 5;
        starting();
        large = true;
    }
    else if(mouseX > xposs && mouseX < (xposs + side*6) && mouseY > yposi && mouseY < yposi + side){
      instructions = true;
    }
    else if(mouseX > width - xposs * 1.5 && mouseX < (width - xposs * 1.5 + side*5) && mouseY > yposs && mouseY < yposs + side){
      if(timeLimit){
        timeLimit = false;
      }else{
        timeLimit = true;
      }
    }
  }
}
void starting(){
  savedTime = millis()/1000.0;
  play = true;
  xpos1 = side * int(random(0, width/side - (1  + colorBoardWidth)));
  ypos1 = side * int(random(1, height/side - 1));
  winScore = colorBoardWidth*(height/side-1);
}
void generateBlock(){
  xpos2 = side * int(random(0, width/side - (1 + colorBoardWidth)));
  ypos2 = side * int(random(side/side, height/side - 1));
  colorr2 = int(random(0, 256));
  colorg2 = int(random(0, 256));
  colorb2 = int(random(0, 256));
}
void eaten(){
  if(xpos1 == xpos2 && ypos1 == ypos2){
    reds.add(colorr2);
    greens.add(colorg2);
    blues.add(colorb2);
    block = false;
    score++;
  }
}
void blocks(){
  xpos3 = width - colorBoardWidth*side;
  ypos3 = side;
  for(int x = 0; x < reds.size(); x++){
    fill(reds.get(x),greens.get(x),blues.get(x));
    square(xpos3, ypos3, side);
    if(xpos3 < width - side){
      xpos3 += side;
    }
    else{
      xpos3 = width - side*colorBoardWidth;
      ypos3 += side;
    }
  }
}
void timePassed() {
  passedTime = millis()/1000.0;
  if(timeLimit){
    timeLimited();
  }else{
    speedRun();
  }
  fill(0);
  text(time, (width - side * 3)/2 + side * 2, side);
}
void timeLimited() {
  time = timer - (passedTime-savedTime);
  textSize(side);
  
  if(time <= 0.000){
    hasLost = true;
  }
}
void speedRun() {
  time = passedTime - savedTime;
}
void win() {
  if (timeLimit){
    saveScore();
  }
  surface.setSize(900,600);
  background(122);
  fill(0);
  textSize(side*4);
  text("YOU WIN!", 0 + side, height/2 + side);
  textSize(side);
  if(!timeLimit){
    text("Total time: " + time, 0+ side * 4, height /2 + side * 2);
  }
  textSize(side * 2);
  text("Play again?", 0+side*4, height/2+side*4);
}
void finalScore() {
  saveScore();
  surface.setSize(900,600);
  background(122);
  fill(0);
  textSize(side*4);
  text("Score: " + score, 0 + side, height/2 + side);
  textSize(side*2);
  text("Play again?", 0+side*4, height/2+side*4);
}
void saveScore(){
  if(small){
    hism = score;
  }
  if(medium){
    himed = score;
  }
  if(large){
    hilg = score;
  }
}
void reset() {
score = 0;
block = false;
play = false;
small = false;
medium = false;
large = false;
instructions = false;
back = false;
hasWon = false;
hasLost = false;
reds = new ArrayList<Integer>();
greens = new ArrayList<Integer>();
blues = new ArrayList<Integer>();
}
