import processing.sound.*;
Player p1;
Obstacle o1;
Obstacle rightCounter;
Obstacle topCounter;
Obstacle leftCounter;
Crate bunCrate;
Crate cheeseCrate;
Crate tomatoCrate;
Crate lettuceCrate;
Crate meatCrate;
Plate heldPlate;
Ingredient heldIngredient;
Recipe currentRecipe;
Button playButton;
Button controlsButton;
Button backButton;
Button replayButton;
Button exitButton;

PImage bunImg;
PImage cheeseImg;
PImage tomatoImg;
PImage lettuceImg;
PImage rawImg;
PImage scImg;
PImage stImg;
PImage slImg;
PImage cookedImg;
SoundFile chopSound;
SoundFile backgroundSound;

int plateSpawn1X;
int plateSpawn1Y;
int plateSpawn2X;
int plateSpawn2Y;

int score;
int gameState;
int missedOrders;
int wrongOrders;
int gameStartTime;
int gameTimeLimit;

boolean hasIngredient=false;
boolean ingredientCollected=false;

int startOrder;
int currentOrder;
int orderInterval;

ArrayList<Obstacle> obstacleList;
ArrayList<Crate> crateList;
ArrayList<Ingredient> ingredientList;
ArrayList<Station> stationList;
ArrayList<Plate> plateList;
ArrayList<Recipe> recipeList;

void setup() {
  //fullScreen();
  size(1280, 800);
  imageMode(CENTER);
  bunImg=loadImage("bun.png");
  cheeseImg=loadImage("cheese.png");
  tomatoImg=loadImage("tomato.png");
  lettuceImg=loadImage("lettuce.png");
  rawImg=loadImage("raw.png");
  scImg=loadImage("SC.png");
  stImg=loadImage("ST.png");
  slImg=loadImage("SL.png");
  cookedImg=loadImage("Cooked.png");
  chopSound=new SoundFile(this, "chop.mp3");
  backgroundSound= new SoundFile(this, "background.mp3");
  Sound.volume(0.4);
  score=0;
  gameState=0;
  missedOrders = 0;
  wrongOrders = 0;
  gameStartTime = millis();
  gameTimeLimit = 180000;

  p1=new Player(width/2, 600, 50, 50);
  o1=new Obstacle(width/2, height/2, 400, 300);
  rightCounter=new Obstacle(width-50, height/2, 100, height);
  topCounter=new Obstacle(width/2, 50, width-200, 100);
  leftCounter = new Obstacle(50, height/2, 100, height);

  plateSpawn1X = width/2 - 190;
  plateSpawn1Y = height/2;
  plateSpawn2X = width/2 + 190;
  plateSpawn2Y = height/2;

  obstacleList=new ArrayList<Obstacle>();
  obstacleList.add(o1);
  obstacleList.add(rightCounter);
  obstacleList.add(topCounter);
  obstacleList.add(leftCounter);

  crateList=new ArrayList<Crate>();
  crateList.add(new Crate(75, 180, 50, 50, 0)); //bun
  crateList.add(new Crate(75, 300, 50, 50, 1)); //cheese
  crateList.add(new Crate(75, 420, 50, 50, 2)); //tomato
  crateList.add(new Crate(75, 540, 50, 50, 3)); //lettuce
  crateList.add(new Crate(75, 660, 50, 50, 4)); //meat

  ingredientList=new ArrayList<Ingredient>();
  heldIngredient=null;

  stationList=new ArrayList<Station>();
  //chopping stations
  stationList.add(new Station(width/2-60, (height/2)-130, 0));
  stationList.add(new Station(width/2+60, (height/2)-130, 0));
  //stoves
  stationList.add(new Station(width-80, height/4, 1));
  stationList.add(new Station(width-80, height/2, 1));
  stationList.add(new Station(width-80, 3*height/4, 1));
  //delivery station
  stationList.add(new Station(width/2, 70, 2));

  plateList=new ArrayList<Plate>();
  heldPlate=null;
  plateList.add(new Plate(plateSpawn1X, plateSpawn1Y));
  plateList.add(new Plate(plateSpawn2X, plateSpawn2Y));

  recipeList=new ArrayList<Recipe>();
  recipeList.add(new Recipe());
  startOrder=millis();
  orderInterval=30000;

  currentRecipe=new Recipe();
  playButton = new Button(width/2, height/2 + 90, 120, color(112, 168, 108));
  controlsButton = new Button(width/2, height/2 + 165, 120, color(95, 145, 180));
  backButton = new Button(width/2, 500, 120, color(200, 200, 100));
  replayButton = new Button(width/2, height/2 + 145, 120, color(112, 168, 108));
  exitButton = new Button(width/2, height/2 + 210, 120, color(95, 145, 180));
}

void draw() {
  background(42);
  if (gameState==0) {
    drawStartScreen();
  } else if (gameState==1) {
    drawShowControlsScreen();
  } else if (gameState==2) {
    drawGame();
  } else if (gameState==3) {
    drawEndScreen();
  }
}
void drawGame() {
  if (backgroundSound.isPlaying()==false) {
    backgroundSound.play();
  }
  drawFloor();
  p1.move();

  for (Obstacle anObstacle : obstacleList) {
    anObstacle.render();
    anObstacle.playerCollide(p1);
  }

  for (Crate aCrate : crateList) {
    aCrate.render();
  }
  for (Ingredient anIngredient : ingredientList) {
    anIngredient.render();
  }

  for (Station aStation : stationList) {
    if (aStation.type!=0) {
      aStation.render();
    }
    if (aStation.type==1 && aStation.currentIngredient!=null) {
      Ingredient item=aStation.currentIngredient;
      if (item.type==4 && item.isCooking) {
        int timeCooking=millis()-item.cookStartTime;
        if (item.state==0 && timeCooking>=12000) {
          item.state=2;
          item.cookStartTime=millis();
          println("meat cooked");
        } else if (item.state==2 && timeCooking>=13000) {
          item.state=3;
          item.isCooking=false;
          println("meat burned");
        }
      }
    }
  }
  for (Plate aPlate : plateList) {
    aPlate.render();
  }
  currentOrder=millis();
  if (currentOrder-startOrder>orderInterval) {
    recipeList.add(new Recipe());
    println("new order");
    startOrder=currentOrder;
  }
  for (int index=0; index<recipeList.size(); index++) {
    Recipe aRecipe = recipeList.get(index);
    aRecipe.renderRecipe(width/2 + 180 + index * 150);
  }
  for (int index=recipeList.size()-1; index>=0; index--) {
    Recipe aRecipe=recipeList.get(index);
    if (aRecipe.timeLeft()<=0) {
      recipeList.remove(index);
      missedOrders+=1;
      println("order missed");
    }
  }
  if ((missedOrders>=3) || (wrongOrders>=3) || (millis()-gameStartTime>=gameTimeLimit)) {
    gameState=3;
  }
  p1.render();
  rectMode(CENTER);
  noStroke();
  fill(#B5B4B1);
  rect(o1.x, o1.y - o1.h/2 + 20, o1.w, 40);
  for (Station aStation : stationList) {
    if (aStation.type==0) {
      aStation.render();
    }
  }
  fill(#39A7A5);
  rectMode(CORNER);
  noStroke();
  fill(0, 120);
  rect(30, 30, 180, 60, 12);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(18);
  text("Score", 50, 50);

  fill(#F2D94E);
  textSize(24);
  text(score, 120, 50);
}

void keyPressed() {
  if (key=='a') {
    p1.isMovingLeft=true;
  }
  if (key=='d') {
    p1.isMovingRight=true;
  }
  if (key=='w') {
    p1.isMovingUp=true;
  }
  if (key=='s') {
    p1.isMovingDown=true;
  }

  if (key == ' ') {
    if (p1.ingredientHeld == -1 && heldPlate==null) {
      boolean pickedUp = false;
      //gets ingredient from crate
      for (Crate aCrate : crateList) {
        if (pickedUp==false && aCrate.isPlayerTouching(p1)) {
          heldIngredient = new Ingredient(p1.x, p1.y, aCrate.ingredientType);
          heldIngredient.isWithPlayer=true;
          heldIngredient.isAtStation = false;
          heldIngredient.isOnFloor = false;
          heldIngredient.isInCrate = false;
          p1.ingredientHeld=aCrate.ingredientType;
          p1.state=0;
          println("ingredient gathered");
          pickedUp = true;
          break;
        }
      }
      //picks up ingredient from station
      for (Station aStation : stationList) {
        if (pickedUp==false && aStation.currentIngredient != null &&
          aStation.isInteracting(p1)) {
          if (aStation.type==1 && aStation.currentIngredient.type==4 &&
            aStation.currentIngredient.state==3) {
            aStation.currentIngredient = null;
            println("burnt meat discarded");
            pickedUp = true;
            break;
          }
          heldIngredient = aStation.currentIngredient;
          heldIngredient.isCooking=false;
          heldIngredient.isWithPlayer = true;
          heldIngredient.isAtStation = false;
          heldIngredient.isOnFloor = false;
          heldIngredient.isInCrate = false;
          p1.ingredientHeld = heldIngredient.type;
          p1.state = heldIngredient.state;
          aStation.currentIngredient = null;
          println("picked up from station");
          pickedUp = true;
          break;
        }
      }

      //picks up ingredient from floor
      if (!pickedUp) {
        //look through the ingredients on floor
        for (int index=0; index<ingredientList.size(); index++) {
          Ingredient anIngredient =ingredientList.get(index);
          if (anIngredient.isOnFloor && anIngredient.isTouchingPlayer(p1)) {
            heldIngredient=anIngredient;
            heldIngredient.isWithPlayer = true;
            heldIngredient.isAtStation = false;
            heldIngredient.isOnFloor = false;
            heldIngredient.isInCrate = false;
            p1.ingredientHeld=heldIngredient.type;
            p1.state = heldIngredient.state;
            ingredientList.remove(index);
            println("picked up from floor");
            pickedUp=true;
            break;
          }
        }
      }
      if (pickedUp==false) {
        for (int index=0; index<plateList.size(); index++) {
          Plate aPlate=plateList.get(index);
          if (aPlate.isWithPlayer==false && aPlate.isTouchingPlayer(p1)) {
            heldPlate=aPlate;
            heldPlate.isWithPlayer=true;
            heldPlate.isOnCounter=false;
            println("picked up plate");
            pickedUp=true;
            break;
          }
        }
      }
    } else if (heldIngredient!=null) {
      boolean placed = false;
      //places ingredient on station
      for (Station aStation : stationList) {
        if (aStation.isInteracting(p1) && aStation.currentIngredient == null) {
          heldIngredient.isWithPlayer = false;
          heldIngredient.isAtStation = true;
          heldIngredient.isOnFloor = false;
          heldIngredient.isInCrate = false;
          aStation.currentIngredient=heldIngredient;
          if (aStation.type==1 && aStation.currentIngredient.type==4) {
            aStation.currentIngredient.isCooking=true;
            aStation.currentIngredient.cookStartTime=millis();
          }
          if (aStation.type!=1) {
            aStation.currentIngredient.isCooking = false;
          }
          if (aStation.type==1) {
            Ingredient item=aStation.currentIngredient;
            if (item.type==4) {
              if (item.state==0) {
                println("cooking");
              } else if (item.state==2) {
                println("cooked");
              } else if (item.state==3) {
                println("burnt");
              }
            } else {
              println("cannot cook");
            }
          }
          p1.ingredientHeld=-1;
          p1.state=0;
          heldIngredient=null;
          placed=true;
          println("placed on station");
          break;
        }
      }
      if (placed==false) {
        for (Plate aPlate : plateList) {
          if (aPlate.isWithPlayer==false && aPlate.isTouchingPlayer(p1) &&
            aPlate.addIngredient(heldIngredient)) {
            p1.ingredientHeld=-1;
            p1.state=0;
            heldIngredient=null;
            println("added ingredient to plate");
            placed=true;
            break;
          }
        }
      }
      //places ingredient on counter
      if (placed==false) {
        boolean touchingCrate=false;
        boolean isPlacedOnCounter=false;
        for (Crate aCrate : crateList) {
          if (aCrate.isPlayerTouching(p1)) {
            touchingCrate=true;
            break;
          }
        }
        if (touchingCrate==false) {
          for (Obstacle anObstacle : obstacleList) {
            if (anObstacle.isTouchingPlayer(p1)) {
              heldIngredient.isWithPlayer=false;
              heldIngredient.isAtStation=false;
              heldIngredient.isOnFloor=true;
              heldIngredient.isInCrate=false;
              //making it so that ingredient places on counter
              if (o1.isTouchingPlayer(p1)) {
                if (p1.x<o1.left) {
                  heldIngredient.x=p1.x+45;
                  heldIngredient.y=p1.y;
                }
                if (p1.x>o1.right) {
                  heldIngredient.x=p1.x-45;
                  heldIngredient.y=p1.y;
                }
                if (p1.y>o1.bottom) {
                  heldIngredient.x=p1.x;
                  heldIngredient.y=p1.y-45;
                }
                if (p1.y<o1.top) {
                  heldIngredient.x=p1.x;
                  heldIngredient.y=p1.y+45;
                }
              } else if (leftCounter.isTouchingPlayer(p1) || rightCounter.isTouchingPlayer(p1)
                || topCounter.isTouchingPlayer(p1)) {
                if (p1.x<rightCounter.left && rightCounter.isTouchingPlayer(p1)) {
                  heldIngredient.x=p1.x+45;
                  heldIngredient.y=p1.y;
                } else if (p1.x>leftCounter.right && leftCounter.isTouchingPlayer(p1)) {
                  heldIngredient.x=p1.x-45;
                  heldIngredient.y=p1.y;
                } else if (p1.y>topCounter.bottom && topCounter.isTouchingPlayer(p1)) {
                  heldIngredient.x=p1.x;
                  heldIngredient.y=p1.y-45;
                }
              }
              ingredientList.add(heldIngredient);
              heldIngredient=null;
              p1.ingredientHeld=-1;
              p1.state=0;
              println("placed on counter");
              isPlacedOnCounter=true;
              break;
            }
          }
        }
        //drops ingredient on floor
        if (isPlacedOnCounter==false) {
          heldIngredient.isWithPlayer = false;
          heldIngredient.isAtStation = false;
          heldIngredient.isOnFloor = true;
          heldIngredient.isInCrate = false;
          heldIngredient.x = p1.x;
          heldIngredient.y = p1.y - 10;
          ingredientList.add(heldIngredient);
          heldIngredient=null;
          p1.ingredientHeld = -1;
          p1.state=0;
          println("placed on floor");
        }
      }
    } else if (heldPlate!=null) {
      boolean delivered=false;
      boolean placedPlate=false;
      for (Station aStation : stationList) {
        if (aStation.isInteracting(p1) && aStation.type==2) {
          boolean matchedRecipe=false;
          for (int index=0; index<recipeList.size(); index++) {
            Recipe aRecipe=recipeList.get(index);

            if (heldPlate.matchesRecipe(aRecipe)) {
              println("order delivered");
              recipeList.remove(index);
              matchedRecipe=true;
              score+=10;
              break;
            }
          }
          if (matchedRecipe==false) {
            println("wrong order");
            score-=10;
            wrongOrders+=1;
          }
          for (int index=0; index<plateList.size(); index++) {
            if (plateList.get(index)==heldPlate) {
              plateList.remove(index);
              break;
            }
          }
          heldPlate=null;
          delivered=true;
          respawnPlate();
          break;
        }
      }
      if (delivered==false) {
        for (Obstacle anObstacle : obstacleList) {
          if (anObstacle.isTouchingPlayer(p1)) {
            heldPlate.isWithPlayer=false;
            heldPlate.isOnCounter=true;
            if (o1.isTouchingPlayer(p1)) {
              if (p1.x<o1.left) {
                heldPlate.x=p1.x+45;
                heldPlate.y=p1.y;
              }
              if (p1.x>o1.right) {
                heldPlate.x=p1.x-45;
                heldPlate.y=p1.y;
              }
              if (p1.y>o1.bottom) {
                heldPlate.x=p1.x;
                heldPlate.y=p1.y-45;
              }
              if (p1.y<o1.top) {
                heldPlate.x=p1.x;
                heldPlate.y=p1.y+45;
              }
            } else if (leftCounter.isTouchingPlayer(p1) || rightCounter.isTouchingPlayer(p1)
              || topCounter.isTouchingPlayer(p1)) {
              if (p1.x<rightCounter.left && rightCounter.isTouchingPlayer(p1)) {
                heldPlate.x=p1.x+45;
                heldPlate.y=p1.y;
              } else if (p1.x>leftCounter.right && leftCounter.isTouchingPlayer(p1)) {
                heldPlate.x=p1.x-45;
                heldPlate.y=p1.y;
              } else if (p1.y>topCounter.bottom && topCounter.isTouchingPlayer(p1)) {
                heldPlate.x=p1.x;
                heldPlate.y=p1.y-45;
              }
            }

            println("plate placed");
            heldPlate=null;
            placedPlate=true;
            break;
          }
        }
        if (placedPlate==false) {
          println("plate must be placed on counter");
        }
      }
    }
  }
  if (key=='j') {
    for (Station aStation : stationList) {
      if (aStation.isInteracting(p1) && aStation.currentIngredient!=null) {
        Ingredient item=aStation.currentIngredient;
        if (aStation.type==0) {
          if ((item.type==1 || item.type==2 || item.type==3) && item.state==0) {
            item.chopProgress+=1;
            println("chop");
            chopSound.play();
            if (item.chopProgress>=3) {
              item.state=1;
              item.chopProgress=3;
              println("ingredient chopped");
            }
          } else if (item.state==1) {
            println("already chopped");
          } else {
            println("cannot chop");
          }
        }
        break;
      }
    }
  }
}
void keyReleased() {
  if (key=='a') {
    p1.isMovingLeft=false;
  }
  if (key=='d') {
    p1.isMovingRight=false;
  }
  if (key=='w') {
    p1.isMovingUp=false;
  }
  if (key=='s') {
    p1.isMovingDown=false;
  }
}

void drawStartScreen() {
  float panelX = width/2;
  float panelY = height/2 + 110;

  rectMode(CORNER);
  textAlign(CENTER, CENTER);

  // wall
  background(186, 170, 145);

  // floor
  noStroke();
  fill(92, 62, 38);
  rect(0, height * 0.62, width, height * 0.38);

  stroke(65, 42, 24);
  strokeWeight(1);
  for (int row = int(height * 0.62); row < height; row += 36) {
    if (((row / 36) % 2) == 0) {
      fill(110, 74, 46);
    } else {
      fill(96, 64, 40);
    }
    rect(0, row, width, 36);

    int offset = (((row / 36) % 2) == 0) ? 0 : 60;
    for (int col = offset; col < width; col += 120) {
      line(col, row, col, row + 36);
    }
  }

  // title shadow
  fill(0, 70);
  textSize(68);
  text("Pico's Pantry", width/2 + 4, 116);

  // title
  fill(255, 244, 214);
  text("Pico's Pantry", width/2, 110);

  // subtitle
  fill(90, 60, 35);
  textSize(22);
  text("Cook, Chop, Deliver", width/2, 165);

  // Pico above panel
  p1.idleAnim.isAnimating = true;
  p1.idleAnim.display(width/2, height/2 - 20);

  // menu panel shadow
  rectMode(CENTER);
  noStroke();
  fill(0, 55);
  rect(panelX + 5, panelY + 5, 360, 220, 24);

  // menu panel
  fill(248, 236, 214);
  stroke(170, 145, 110);
  strokeWeight(2);
  rect(panelX, panelY, 360, 220, 24);

  // actual buttons
  playButton.render();
  controlsButton.render();

  // button text
  fill(255);
  textSize(28);
  text("Play", playButton.x, playButton.y);
  text("Controls", controlsButton.x, controlsButton.y);
}

void drawShowControlsScreen() {
  backButton.render();

  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("Controls", width/2, 80);

  textSize(22);
  text("WASD = move", width/2, 180);
  text("SPACE = interact / pick up / place / drop", width/2, 220);
  text("J = chop", width/2, 260);

  fill(200, 200, 100);
  rect(width/2, 450, 220, 60);
  fill(0);
  text("Back", backButton.x, backButton.y);
}

void drawEndScreen() {
  float panelX = width/2;
  float panelY = height/2 + 80;

  rectMode(CORNER);
  textAlign(CENTER, CENTER);

  // wall
  background(186, 170, 145);

  // floor
  noStroke();
  fill(92, 62, 38);
  rect(0, height * 0.62, width, height * 0.38);

  stroke(65, 42, 24);
  strokeWeight(1);
  for (int row = int(height * 0.62); row < height; row += 36) {
    if (((row / 36) % 2) == 0) {
      fill(110, 74, 46);
    } else {
      fill(96, 64, 40);
    }
    rect(0, row, width, 36);

    int offset = (((row / 36) % 2) == 0) ? 0 : 60;
    for (int col = offset; col < width; col += 120) {
      line(col, row, col, row + 36);
    }
  }

  // title shadow
  fill(0, 70);
  textSize(62);
  text("Game Over", width/2 + 4, 116);

  // title
  fill(255, 244, 214);
  text("Game Over", width/2, 110);

  // Pico above panel
  p1.idleAnim.isAnimating = true;
  p1.idleAnim.display(width/2, height/2 - 35);

  replayButton.x = int(panelX);
  replayButton.y = int(panelY + 105);
  exitButton.x = int(panelX);
  exitButton.y = int(panelY + 175);

  // panel shadow
  rectMode(CENTER);
  noStroke();
  fill(0, 55);
  rect(panelX + 5, panelY + 5, 390, 340, 24);

  // panel
  fill(248, 236, 214);
  stroke(170, 145, 110);
  strokeWeight(2);
  rect(panelX, panelY, 390, 340, 24);

  // score label
  fill(90, 60, 35);
  textSize(24);
  text("Final Score", panelX, panelY - 95);

  // score value
  fill(#E3B341);
  textSize(42);
  text(score, panelX, panelY - 55);

  // missed orders
  fill(120, 80, 55);
  textSize(18);
  text("Orders Missed: " + missedOrders, panelX, panelY - 10);
  text("Wrong Orders: " + wrongOrders, panelX, panelY + 18);

  // flavor text
  fill(90, 60, 35);
  textSize(18);
  if (score < 20) {
    text("The kitchen got a little chaotic.", panelX, panelY + 52);
  } else if (score < 50) {
    text("Nice work keeping Pico's pantry moving.", panelX, panelY + 52);
  } else {
    text("Chef Pico crushed the rush.", panelX, panelY + 52);
  }

  // actual buttons
  replayButton.render();
  exitButton.render();

  // button text
  fill(255);
  textSize(24);
  text("Replay", replayButton.x, replayButton.y);
  text("Exit", exitButton.x, exitButton.y);
}

void restartGame() {
  score=0;
  missedOrders = 0;
  wrongOrders = 0;
  gameStartTime = millis();
  gameTimeLimit = 180000;
  p1.x=width/2;
  p1.y=600;
  p1.ingredientHeld=-1;
  p1.isMovingLeft = false;
  p1.isMovingRight = false;
  p1.isMovingUp = false;
  p1.isMovingDown = false;

  heldIngredient = null;
  heldPlate = null;

  ingredientList.clear();
  plateList.clear();
  recipeList.clear();

  for (Station aStation : stationList) {
    aStation.currentIngredient = null;
  }

  plateList.add(new Plate(plateSpawn1X, plateSpawn1Y));
  plateList.add(new Plate(plateSpawn2X, plateSpawn2Y));

  recipeList.add(new Recipe());

  startOrder = millis();
}

void respawnPlate() {
  boolean spot1Taken = false;
  boolean spot2Taken = false;

  for (Plate aPlate : plateList) {
    if (aPlate.x == plateSpawn1X && aPlate.y == plateSpawn1Y) {
      spot1Taken = true;
    }
    if (aPlate.x == plateSpawn2X && aPlate.y == plateSpawn2Y) {
      spot2Taken = true;
    }
  }

  if (!spot1Taken) {
    plateList.add(new Plate(plateSpawn1X, plateSpawn1Y));
  } else if (!spot2Taken) {
    plateList.add(new Plate(plateSpawn2X, plateSpawn2Y));
  }
}

void mousePressed() {
  if (gameState==0) {
    if (playButton.isInButton()) {
      restartGame();
      gameState=2;
    }
    if (controlsButton.isInButton()) {
      gameState=1;
    }
  } else if (gameState==1) {
    if (backButton.isInButton()) {
      gameState=0;
    }
  } else if (gameState==3) {
    if (replayButton.isInButton()) {
      restartGame();
      gameState=2;
    }
    if (exitButton.isInButton()) {
      gameState=0;
    }
  }
}

void drawFloor() {
  background(92, 62, 38);

  stroke(65, 42, 24);
  strokeWeight(1);
  rectMode(CORNER);

  for (int row = 0; row < height; row += 40) {
    if ((row / 40) % 2 == 0) {
      fill(110, 74, 46);
    } else {
      fill(96, 64, 40);
    }

    rect(0, row, width, 40);

    int offset = 0;
    if ((row / 40) % 2 == 1) {
      offset = 60;
    }

    for (int col = offset; col < width; col += 120) {
      line(col, row, col, row + 40);
    }

    stroke(140, 100, 70, 40);
    line(0, row + 4, width, row + 4);

    stroke(65, 42, 24);
  }
}
