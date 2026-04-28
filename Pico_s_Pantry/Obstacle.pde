class Obstacle {
  int x;
  int y;
  int w;
  int h;

  int left;
  int right;
  int top;
  int bottom;

  Obstacle(int startingX, int startingY, int startingW, int startingH) {
    x=startingX;
    y=startingY;
    w=startingW;
    h=startingH;

    left=x-w/2;
    right=x+w/2;
    top=y-h/2;
    bottom=y+h/2;
  }

  void render() {
    drawCounter();
  }

  void playerCollide(Player aPlayer) {
    if (aPlayer.top<=bottom &&
      aPlayer.bottom>=top &&
      aPlayer.right>left &&
      aPlayer.left<=left) {
      aPlayer.isMovingRight=false;
      aPlayer.x=left-aPlayer.w/2;
    }
    if (aPlayer.top<=bottom &&
      aPlayer.bottom>=top &&
      aPlayer.left<right &&
      aPlayer.right>=right) {
      aPlayer.isMovingLeft=false;
      aPlayer.x=right+aPlayer.w/2;
    }
    if (aPlayer.left<=right &&
      aPlayer.right>=left &&
      aPlayer.bottom>top &&
      aPlayer.top<=top) {
      aPlayer.isMovingDown=false;
      aPlayer.y=top-aPlayer.h/2;
    }
    if (aPlayer.left<=right &&
      aPlayer.right>=left &&
      aPlayer.top<bottom &&
      aPlayer.bottom>=bottom) {
      aPlayer.isMovingUp=false;
      aPlayer.y=bottom+aPlayer.h/2;
    }
  }
  boolean isTouchingPlayer(Player aPlayer) {
    if (aPlayer.top <= bottom &&
      aPlayer.bottom >= top &&
      aPlayer.right >= left &&
      aPlayer.left <= right) {
      return true;
    } else {
      return false;
    }
  }
  void drawCounter() {
    rectMode(CENTER);
    noStroke();
    fill(0, 35);
    rect(x + 4, y + 4, w, h);

    fill(170, 170, 165);
    rect(x, y, w, h);

    fill(220, 220, 215);
    rect(x, y - h/2 + 12, w, 24);

    fill(145, 145, 140);
    rect(x, y + 10, w, h - 24);

    stroke(130, 130, 125);
    line(x - w/4, y - h/2 + 24, x - w/4, y + h/2 - 10);
    line(x, y - h/2 + 24, x, y + h/2 - 10);
    line(x + w/4, y - h/2 + 24, x + w/4, y + h/2 - 10);

    line(x - w/2 + 10, y, x + w/2 - 10, y);

    noStroke();
  }
}
