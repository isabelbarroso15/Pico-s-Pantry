class Plate {
  int x;
  int y;
  int w;
  int h;

  int left;
  int right;
  int top;
  int bottom;

  boolean isWithPlayer;
  boolean isOnCounter;
  boolean hasBun;
  boolean hasCheese;
  boolean hasTomato;
  boolean hasLettuce;
  boolean hasMeat;

  Plate(int x1, int y1) {
    x=x1;
    y=y1;
    w=40;
    h=40;

    isWithPlayer=false;
    isOnCounter=false;
    hasBun=false;
    hasCheese=false;
    hasTomato=false;
    hasLettuce=false;
    hasMeat=false;

    updateHitBox();
  }
  void render() {
    updateHitBox();
    if (isWithPlayer==false) {
      ellipseMode(CENTER);
      noStroke();
      fill(0, 40);
      ellipse(x + 2, y + 4, 44, 44);

      fill(245);
      ellipse(x, y, 46, 46);

      fill(230);
      ellipse(x, y, 34, 34);

      fill(250);
      ellipse(x, y, 24, 24);

      if (hasBun) {
       image(bunImg,x,y);
      } else {
        if (!hasBun) {
          if (hasLettuce) {
            fill(#58B84F);
            ellipse(x - 8, y - 4, 12, 8);
            ellipse(x + 8, y - 4, 12, 8);
            ellipse(x, y - 8, 14, 8);
          }

          if (hasTomato) {
            fill(#D94A4A);
            ellipse(x - 6, y + 2, 10, 10);
            ellipse(x + 6, y + 2, 10, 10);
          }

          if (hasCheese) {
            fill(#F2D94E);
            rectMode(CENTER);
            rect(x, y + 6, 16, 8, 3);
          }

          if (hasMeat) {
            fill(#6F1E1E);
            ellipse(x, y + 8, 20, 10);
          }
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
  boolean addIngredient(Ingredient item) {
    if (item.type==0 && hasBun==false) {
      hasBun=true;
      return true;
    } else if (item.type==1 && item.state==1 && hasCheese==false) {
      hasCheese=true;
      return true;
    } else if (item.type == 2 && item.state == 1 && hasTomato==false) {
      hasTomato = true;
      return true;
    } else if (item.type == 3 && item.state == 1 && hasLettuce==false) {
      hasLettuce = true;
      return true;
    } else if (item.type == 4 && item.state == 2 && hasMeat==false) {
      hasMeat = true;
      return true;
    }
    return false;
  }
  boolean matchesRecipe(Recipe aRecipe) {
    if (hasBun!=aRecipe.needsBun) {
      return false;
    }
    if (hasMeat!=aRecipe.needsMeat) {
      return false;
    }
    if (hasCheese!=aRecipe.needsCheese) {
      return false;
    }
    if (hasTomato!=aRecipe.needsTomato) {
      return false;
    }
    if (hasLettuce!=aRecipe.needsLettuce) {
      return false;
    }
    return true;
  }
  void checkDish() {
  }
}
