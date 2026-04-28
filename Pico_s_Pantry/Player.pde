class Player {
  int x;
  int y;
  int w;
  int h;

  boolean isMovingLeft;
  boolean isMovingRight;
  boolean isMovingUp;
  boolean isMovingDown;

  int speed;
  int state;
  int chopProgress;
  int cookStartTime;
  boolean isCooking;

  boolean hasBun;
  boolean hasCheese;
  boolean hasTomato;
  boolean hasLettuce;
  boolean hasMeat;

  int left;
  int right;
  int top;
  int bottom;

  PImage[] upImages;
  PImage[] downImages;
  PImage[] leftImages;
  PImage[] rightImages;
  PImage[] idleImages;

  Animation upAnim;
  Animation downAnim;
  Animation leftAnim;
  Animation rightAnim;
  Animation idleAnim;

  int ingredientHeld=-1;

  Player(int startingX, int startingY, int startingW, int startingH) {
    x=startingX;
    y=startingY;
    w=startingW;
    h=startingH;

    isMovingLeft=false;
    isMovingRight=false;
    isMovingUp=false;
    isMovingDown=false;

    speed=15;
    state=0;
    chopProgress=0;
    cookStartTime=0;
    isCooking=false;

    hasBun=false;
    hasCheese=false;
    hasTomato=false;
    hasLettuce=false;
    hasMeat=false;

    updateHitBox();
    upImages = new PImage[8];
    downImages = new PImage[7];
    leftImages = new PImage[8];
    rightImages = new PImage[8];
    idleImages = new PImage[1];

    for (int index=0; index<= upImages.length-1; index++) {
      upImages[index] = loadImage("ratChefUp" + index + ".png");
    }
    for (int index=0; index<= downImages.length-1; index++) {
      downImages[index] = loadImage("ratChefDown" + index + ".png");
    }
    for (int index=0; index<= leftImages.length-1; index++) {
      leftImages[index] = loadImage("ratChefLeft" + index + ".png");
    }
    for (int index=0; index<= rightImages.length-1; index++) {
      rightImages[index] = loadImage("ratChefRight" + index + ".png");
    }
    for (int index=0; index<= idleImages.length-1; index++) {
      idleImages[index] = loadImage("ratChefIdle" + index + ".png");
    }

    ingredientAnimations();

    upAnim = new Animation(upImages, 0.1, 1);
    downAnim = new Animation(downImages, 0.1, 1);
    leftAnim = new Animation(leftImages, 0.1, 1);
    rightAnim = new Animation(rightImages, 0.1, 1);
    idleAnim = new Animation(idleImages, 0.1, 1);
  }

  void render() {
    rectMode(CENTER);
    fill(0, 0, 200);
    stroke(0);

    if (ingredientHeld !=-1) {
      if (ingredientHeld==0) {
        renderBun();
        return;
      } else if (ingredientHeld==1) {
        if (heldIngredient !=null && heldIngredient.state==1) {
          renderSC();
        } else {
          renderCheese();
        }
        return;
      } else if (ingredientHeld==2) {
        if (heldIngredient !=null && heldIngredient.state==1) {
          renderST();
        } else {
          renderTomato();
        }
        return;
      } else if (ingredientHeld==3) {
        if (heldIngredient !=null && heldIngredient.state==1) {
          renderSL();
        } else {
          renderLettuce();
        }
        return;
      } else if (ingredientHeld==4) {
        if (heldIngredient == null || heldIngredient.state==0) {
          renderRaw();
          return;
        } else if (heldIngredient.state==2) {
          renderCooked(); // cooked meat
          return;
        } else if (heldIngredient.state==3) {
          return;
        }
      }
    }
    if (heldPlate!=null) {
      ellipseMode(CENTER);
      noStroke();
      fill(0, 40);
      ellipse(x + 2, y - 88, 44, 44);

      fill(245);
      ellipse(x, y-80, 46, 46);

      fill(230);
      ellipse(x, y-80, 34, 34);

      fill(250);
      ellipse(x, y-80, 24, 24);
      if (heldPlate.hasBun) {
        fill(#A58E64);
        rect(x, y - 64, 18, 8);
        rect(x, y - 96, 18, 6);
      }

      if (heldPlate.hasCheese) {
        fill(#C8C935);
        rect(x, y - 90, 18, 6);
      }
      if (heldPlate.hasTomato) {
        fill(#C9353A);
        rect(x, y - 84, 18, 6);
      }
      if (heldPlate.hasLettuce) {
        fill(#35C93D);
        rect(x, y - 78, 18, 8);
      }
      if (heldPlate.hasMeat) {
        fill(#6F1E1E);
        rect(x, y - 70, 18, 8);
      }
    }
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downAnim.display(x, y);
      downAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftAnim.display(x, y);
      leftAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightAnim.display(x, y);
      rightAnim.isAnimating=true;
    } else {
      idleAnim.display(x, y);
      idleAnim.isAnimating=true;
    }
  }

  void updateHitBox() {
    left=x-w/2;
    right=x+w/2;
    top=y-h/2;
    bottom=y+h/2;
  }

  void move() {
    if (isMovingLeft==true) {
      x-=speed;
    }
    if (isMovingRight==true) {
      x+=speed;
    }
    if (isMovingUp==true) {
      y-=speed;
    }
    if (isMovingDown==true) {
      y+=speed;
    }
    updateHitBox();
  }

  PImage[] downBunImages;
  PImage[] leftBunImages;
  PImage[] rightBunImages;
  PImage[] idleBunImages;
  Animation downBunAnim;
  Animation leftBunAnim;
  Animation rightBunAnim;
  Animation idleBunAnim;

  PImage[] downCheeseImages;
  PImage[] leftCheeseImages;
  PImage[] rightCheeseImages;
  PImage[] idleCheeseImages;
  Animation downCheeseAnim;
  Animation leftCheeseAnim;
  Animation rightCheeseAnim;
  Animation idleCheeseAnim;

  PImage[] downTomatoImages;
  PImage[] leftTomatoImages;
  PImage[] rightTomatoImages;
  PImage[] idleTomatoImages;
  Animation downTomatoAnim;
  Animation leftTomatoAnim;
  Animation rightTomatoAnim;
  Animation idleTomatoAnim;

  PImage[] downLettuceImages;
  PImage[] leftLettuceImages;
  PImage[] rightLettuceImages;
  PImage[] idleLettuceImages;
  Animation downLettuceAnim;
  Animation leftLettuceAnim;
  Animation rightLettuceAnim;
  Animation idleLettuceAnim;

  PImage[] downRawImages;
  PImage[] leftRawImages;
  PImage[] rightRawImages;
  PImage[] idleRawImages;
  Animation downRawAnim;
  Animation leftRawAnim;
  Animation rightRawAnim;
  Animation idleRawAnim;

  PImage[] downCookedImages;
  PImage[] leftCookedImages;
  PImage[] rightCookedImages;
  PImage[] idleCookedImages;
  Animation downCookedAnim;
  Animation leftCookedAnim;
  Animation rightCookedAnim;
  Animation idleCookedAnim;

  PImage[] downSCImages;
  PImage[] leftSCImages;
  PImage[] rightSCImages;
  PImage[] idleSCImages;
  Animation downSCAnim;
  Animation leftSCAnim;
  Animation rightSCAnim;
  Animation idleSCAnim;

  PImage[] downSTImages;
  PImage[] leftSTImages;
  PImage[] rightSTImages;
  PImage[] idleSTImages;
  Animation downSTAnim;
  Animation leftSTAnim;
  Animation rightSTAnim;
  Animation idleSTAnim;

  PImage[] downSLImages;
  PImage[] leftSLImages;
  PImage[] rightSLImages;
  PImage[] idleSLImages;
  Animation downSLAnim;
  Animation leftSLAnim;
  Animation rightSLAnim;
  Animation idleSLAnim;


  void ingredientAnimations() {
    downBunImages = new PImage[6];
    leftBunImages = new PImage[8];
    rightBunImages = new PImage[7];
    idleBunImages = new PImage[1];
    for (int index=0; index<= downBunImages.length-1; index++) {
      downBunImages[index] = loadImage("ratChefDownBun" + index + ".png");
    }
    for (int index=0; index<= leftBunImages.length-1; index++) {
      leftBunImages[index] = loadImage("ratChefLeftBun" + index + ".png");
    }
    for (int index=0; index<= rightBunImages.length-1; index++) {
      rightBunImages[index] = loadImage("ratChefRightBun" + index + ".png");
    }
    for (int index=0; index<= idleBunImages.length-1; index++) {
      idleBunImages[index] = loadImage("ratChefIdleBun" + index + ".png");
    }

    downBunAnim = new Animation(downBunImages, 0.1, 1);
    leftBunAnim = new Animation(leftBunImages, 0.1, 1);
    rightBunAnim = new Animation(rightBunImages, 0.1, 1);
    idleBunAnim = new Animation(idleBunImages, 0.1, 1);

    downCheeseImages = new PImage[6];
    leftCheeseImages = new PImage[8];
    rightCheeseImages = new PImage[8];
    idleCheeseImages = new PImage[1];
    for (int index=0; index<= downCheeseImages.length-1; index++) {
      downCheeseImages[index] = loadImage("ratChefDownCheese" + index + ".png");
    }
    for (int index=0; index<= leftCheeseImages.length-1; index++) {
      leftCheeseImages[index] = loadImage("ratChefLeftCheese" + index + ".png");
    }
    for (int index=0; index<= rightCheeseImages.length-1; index++) {
      rightCheeseImages[index] = loadImage("ratChefRightCheese" + index + ".png");
    }
    for (int index=0; index<= idleCheeseImages.length-1; index++) {
      idleCheeseImages[index] = loadImage("ratChefIdleCheese" + index + ".png");
    }

    downCheeseAnim = new Animation(downCheeseImages, 0.1, 1);
    leftCheeseAnim = new Animation(leftCheeseImages, 0.1, 1);
    rightCheeseAnim = new Animation(rightCheeseImages, 0.1, 1);
    idleCheeseAnim = new Animation(idleCheeseImages, 0.1, 1);

    downTomatoImages = new PImage[6];
    leftTomatoImages = new PImage[8];
    rightTomatoImages = new PImage[8];
    idleTomatoImages = new PImage[1];
    for (int index=0; index<= downTomatoImages.length-1; index++) {
      downTomatoImages[index] = loadImage("ratChefDownTomato" + index + ".png");
    }
    for (int index=0; index<= leftTomatoImages.length-1; index++) {
      leftTomatoImages[index] = loadImage("ratChefLeftTom" + index + ".png");
    }
    for (int index=0; index<= rightTomatoImages.length-1; index++) {
      rightTomatoImages[index] = loadImage("ratChefRightTom" + index + ".png");
    }
    for (int index=0; index<= idleTomatoImages.length-1; index++) {
      idleTomatoImages[index] = loadImage("ratChefIdleTomato" + index + ".png");
    }

    downTomatoAnim = new Animation(downTomatoImages, 0.1, 1);
    leftTomatoAnim = new Animation(leftTomatoImages, 0.1, 1);
    rightTomatoAnim = new Animation(rightTomatoImages, 0.1, 1);
    idleTomatoAnim = new Animation(idleTomatoImages, 0.1, 1);

    downLettuceImages = new PImage[6];
    leftLettuceImages = new PImage[8];
    rightLettuceImages = new PImage[8];
    idleLettuceImages = new PImage[1];
    for (int index=0; index<= downLettuceImages.length-1; index++) {
      downLettuceImages[index] = loadImage("ratChefDownLettuce" + index + ".png");
    }
    for (int index=0; index<= leftLettuceImages.length-1; index++) {
      leftLettuceImages[index] = loadImage("ratChefLeftLet" + index + ".png");
    }
    for (int index=0; index<= rightLettuceImages.length-1; index++) {
      rightLettuceImages[index] = loadImage("ratChefRightLet" + index + ".png");
    }
    for (int index=0; index<= idleLettuceImages.length-1; index++) {
      idleLettuceImages[index] = loadImage("ratChefIdleLettuce" + index + ".png");
    }

    downLettuceAnim = new Animation(downLettuceImages, 0.1, 1);
    leftLettuceAnim = new Animation(leftLettuceImages, 0.1, 1);
    rightLettuceAnim = new Animation(rightLettuceImages, 0.1, 1);
    idleLettuceAnim = new Animation(idleLettuceImages, 0.1, 1);

    downRawImages = new PImage[6];
    leftRawImages = new PImage[8];
    rightRawImages = new PImage[8];
    idleRawImages = new PImage[1];
    for (int index=0; index<= downRawImages.length-1; index++) {
      downRawImages[index] = loadImage("ratChefDownRaw" + index + ".png");
    }
    for (int index=0; index<= leftRawImages.length-1; index++) {
      leftRawImages[index] = loadImage("ratChefLeftRaw" + index + ".png");
    }
    for (int index=0; index<= rightRawImages.length-1; index++) {
      rightRawImages[index] = loadImage("ratChefRightRaw" + index + ".png");
    }
    for (int index=0; index<= idleRawImages.length-1; index++) {
      idleRawImages[index] = loadImage("ratChefIdleRaw" + index + ".png");
    }

    downRawAnim = new Animation(downRawImages, 0.1, 1);
    leftRawAnim = new Animation(leftRawImages, 0.1, 1);
    rightRawAnim = new Animation(rightRawImages, 0.1, 1);
    idleRawAnim = new Animation(idleRawImages, 0.1, 1);

    downCookedImages = new PImage[6];
    leftCookedImages = new PImage[8];
    rightCookedImages = new PImage[8];
    idleCookedImages = new PImage[1];
    for (int index=0; index<= downCookedImages.length-1; index++) {
      downCookedImages[index] = loadImage("ratChefDownCooked" + index + ".png");
    }
    for (int index=0; index<= leftCookedImages.length-1; index++) {
      leftCookedImages[index] = loadImage("ratChefLeftCooked" + index + ".png");
    }
    for (int index=0; index<= rightCookedImages.length-1; index++) {
      rightCookedImages[index] = loadImage("ratChefRightCooked" + index + ".png");
    }
    for (int index=0; index<= idleCookedImages.length-1; index++) {
      idleCookedImages[index] = loadImage("ratChefIdleCooked" + index + ".png");
    }

    downCookedAnim = new Animation(downCookedImages, 0.1, 1);
    leftCookedAnim = new Animation(leftCookedImages, 0.1, 1);
    rightCookedAnim = new Animation(rightCookedImages, 0.1, 1);
    idleCookedAnim = new Animation(idleCookedImages, 0.1, 1);

    downSCImages = new PImage[7];
    leftSCImages = new PImage[8];
    rightSCImages = new PImage[8];
    idleSCImages = new PImage[1];

    for (int index=0; index<downSCImages.length; index++) {
      downSCImages[index] = loadImage("ratChefDownSC" + (index + 1) + ".png");
    }
    for (int index=0; index<leftSCImages.length; index++) {
      leftSCImages[index] = loadImage("ratChefLeftSC" + index + ".png");
    }
    for (int index=0; index<rightSCImages.length; index++) {
      rightSCImages[index] = loadImage("ratChefRightSC" + index + ".png");
    }
    for (int index=0; index<idleSCImages.length; index++) {
      idleSCImages[index] = loadImage("ratChefIdleSC" + index + ".png");
    }

    downSCAnim = new Animation(downSCImages, 0.1, 1);
    leftSCAnim = new Animation(leftSCImages, 0.1, 1);
    rightSCAnim = new Animation(rightSCImages, 0.1, 1);
    idleSCAnim = new Animation(idleSCImages, 0.1, 1);

    downSTImages = new PImage[7];
    leftSTImages = new PImage[8];
    rightSTImages = new PImage[8];
    idleSTImages = new PImage[1];

    for (int index=0; index<downSTImages.length; index++) {
      downSTImages[index] = loadImage("ratChefDownST" + (index + 1) + ".png");
    }
    for (int index=0; index<leftSTImages.length; index++) {
      leftSTImages[index] = loadImage("ratChefLeftST" + index + ".png");
    }
    for (int index=0; index<rightSTImages.length; index++) {
      rightSTImages[index] = loadImage("ratChefRightST" + index + ".png");
    }
    for (int index=0; index<idleSTImages.length; index++) {
      idleSTImages[index] = loadImage("ratChefIdleST" + index + ".png");
    }

    downSTAnim = new Animation(downSTImages, 0.1, 1);
    leftSTAnim = new Animation(leftSTImages, 0.1, 1);
    rightSTAnim = new Animation(rightSTImages, 0.1, 1);
    idleSTAnim = new Animation(idleSTImages, 0.1, 1);

    downSLImages = new PImage[7];
    leftSLImages = new PImage[8];
    rightSLImages = new PImage[8];
    idleSLImages = new PImage[1];

    for (int index=0; index<downSLImages.length; index++) {
      downSLImages[index] = loadImage("ratChefDownSL" + (index + 1) + ".png");
    }
    for (int index=0; index<leftSLImages.length; index++) {
      leftSLImages[index] = loadImage("ratChefLeftSL" + index + ".png");
    }
    for (int index=0; index<rightSLImages.length; index++) {
      rightSLImages[index] = loadImage("ratChefRightSL" + index + ".png");
    }
    for (int index=0; index<idleSLImages.length; index++) {
      idleSLImages[index] = loadImage("ratChefIdleSL" + index + ".png");
    }

    downSLAnim = new Animation(downSLImages, 0.1, 1);
    leftSLAnim = new Animation(leftSLImages, 0.1, 1);
    rightSLAnim = new Animation(rightSLImages, 0.1, 1);
    idleSLAnim = new Animation(idleSLImages, 0.1, 1);
  }
  void renderBun() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downBunAnim.display(x, y);
      downBunAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftBunAnim.display(x, y);
      leftBunAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightBunAnim.display(x, y);
      rightBunAnim.isAnimating=true;
    } else {
      idleBunAnim.display(x, y);
      idleBunAnim.isAnimating=true;
    }
  }
  void renderCheese() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downCheeseAnim.display(x, y);
      downCheeseAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftCheeseAnim.display(x, y);
      leftCheeseAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightCheeseAnim.display(x, y);
      rightCheeseAnim.isAnimating=true;
    } else {
      idleCheeseAnim.display(x, y);
      idleCheeseAnim.isAnimating=true;
    }
  }
  void renderTomato() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downTomatoAnim.display(x, y);
      downTomatoAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftTomatoAnim.display(x, y);
      leftTomatoAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightTomatoAnim.display(x, y);
      rightTomatoAnim.isAnimating=true;
    } else {
      idleTomatoAnim.display(x, y);
      idleTomatoAnim.isAnimating=true;
    }
  }

  void renderLettuce() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downLettuceAnim.display(x, y);
      downLettuceAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftLettuceAnim.display(x, y);
      leftLettuceAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightLettuceAnim.display(x, y);
      rightLettuceAnim.isAnimating=true;
    } else {
      idleLettuceAnim.display(x, y);
      idleLettuceAnim.isAnimating=true;
    }
  }

  void renderRaw() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downRawAnim.display(x, y);
      downRawAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftRawAnim.display(x, y);
      leftRawAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightRawAnim.display(x, y);
      rightRawAnim.isAnimating=true;
    } else {
      idleRawAnim.display(x, y);
      idleRawAnim.isAnimating=true;
    }
  }

  void renderCooked() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downCookedAnim.display(x, y);
      downCookedAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftCookedAnim.display(x, y);
      leftCookedAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightCookedAnim.display(x, y);
      rightCookedAnim.isAnimating=true;
    } else {
      idleCookedAnim.display(x, y);
      idleCookedAnim.isAnimating=true;
    }
  }
  void renderSC() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downSCAnim.display(x, y);
      downSCAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftSCAnim.display(x, y);
      leftSCAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightSCAnim.display(x, y);
      rightSCAnim.isAnimating=true;
    } else {
      idleSCAnim.display(x, y);
      idleSCAnim.isAnimating=true;
    }
  }

  void renderST() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downSTAnim.display(x, y);
      downSTAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftSTAnim.display(x, y);
      leftSTAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightSTAnim.display(x, y);
      rightSTAnim.isAnimating=true;
    } else {
      idleSTAnim.display(x, y);
      idleSTAnim.isAnimating=true;
    }
  }

  void renderSL() {
    if (isMovingUp==true) {
      upAnim.display(x, y);
      upAnim.isAnimating=true;
    } else if (isMovingDown==true) {
      downSLAnim.display(x, y);
      downSLAnim.isAnimating=true;
    } else if (isMovingLeft==true) {
      leftSLAnim.display(x, y);
      leftSLAnim.isAnimating=true;
    } else if (isMovingRight==true) {
      rightSLAnim.display(x, y);
      rightSLAnim.isAnimating=true;
    } else {
      idleSLAnim.display(x, y);
      idleSLAnim.isAnimating=true;
    }
  }
}
