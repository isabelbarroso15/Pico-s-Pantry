class Crate {
  int x;
  int y;
  int w;
  int h;
  int ingredientType;

  int left;
  int right;
  int top;
  int bottom;

  Crate(int x1, int y1, int crateW, int crateH, int type1) {
    x = x1;
    y = y1;
    w = crateW;
    h = crateH;
    ingredientType = type1;

    updateHitBox();
  }

  void updateHitBox() {
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }

  void render() {
    drawCrate();
  }

  boolean isPlayerTouching(Player aPlayer) {
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

  void drawCrate() {
    rectMode(CENTER);
    noStroke();
    fill(0, 40);
    rect(x + 3, y + 4, w, h, 6);

    stroke(90, 55, 25);
    strokeWeight(2);
    fill(145, 98, 55);
    rect(x, y, w, h, 6);

    fill(170, 120, 70);
    rect(x, y, w - 10, h - 10, 4);

    stroke(120, 75, 40);
    line(x - w/4, y - h/2 + 6, x - w/4, y + h/2 - 6);
    line(x, y - h/2 + 6, x, y + h/2 - 6);
    line(x + w/4, y - h/2 + 6, x + w/4, y + h/2 - 6);

    line(x - w/2 + 6, y - h/4, x + w/2 - 6, y - h/4);
    line(x - w/2 + 6, y + h/4, x + w/2 - 6, y + h/4);

    if (ingredientType == 0) {
      image(bunImg, x, y);
    } else if (ingredientType == 1) {
      image(cheeseImg, x, y);
    } else if (ingredientType == 2) {
      image(tomatoImg, x, y);
    } else if (ingredientType == 3) {
      image(lettuceImg, x, y);
    } else if (ingredientType == 4) {
      image(rawImg, x, y);
    }
    strokeWeight(1);
  }
}
