class Ingredient {
  int type;
  int x;
  int y;
  int w;
  int h;

  int left;
  int right;
  int top;
  int bottom;

  int state;
  int chopProgress;
  int cookStartTime;
  boolean isCooking;

  boolean isWithPlayer; //is it being held?
  boolean isAtStation; //is it at a station?
  boolean isOnFloor; //is it on the floor?
  boolean isInCrate; //is it in the crate?

  Ingredient(int x1, int y1, int ingredientType) {
    x=x1;
    y=y1;
    w=40;
    h=40;
    type=ingredientType;

    left=x-w/2;
    right=x+w/2;
    top=y-h/2;
    bottom=y+h/2;

    state=0;
    chopProgress=0;
    cookStartTime=0;
    isCooking=false;


    isWithPlayer=false;
    isAtStation=false;
    isOnFloor=false;
    isInCrate=true;
  }

  void render() {
    updateHitBox();
    rectMode(CENTER);
    if (isAtStation || isOnFloor) {
      if (type==0) {
        image(bunImg, x, y);
      } else if (type==1) {
        if (state==0) {
          image(cheeseImg, x, y);
        } else if (state==1) {
          image(scImg, x, y);
        }
      } else if (type==2) {
        if (state==0) {
          image(tomatoImg, x, y);
        } else if (state==1) {
          image(stImg, x, y);
        }
      } else if (type==3) {
        if (state==0) {
          image(lettuceImg, x, y);
        } else if (state==1) {
          image(slImg, x, y);
        }
      } else if (type==4) {
        if (state==0) {
          image(rawImg, x, y);
        } else if (state==2) {
          image(cookedImg, x, y);
        } else if (state==3) {
          fill(0); //burnt meat
          circle(x, y, 40);
        }
      }
    }
  }

  void updateHitBox() {
    left=x-w/2;
    right=x+w/2;
    top=y-h/2;
    bottom=y+h/2;
  }
  boolean isTouchingPlayer(Player aPlayer) {
    updateHitBox();
    if (aPlayer.top <= bottom &&
      aPlayer.bottom >= top &&
      aPlayer.right >= left &&
      aPlayer.left <= right) {
      return true;
    } else {
      return false;
    }
  }
}
