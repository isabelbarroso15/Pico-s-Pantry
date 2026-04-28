class Station {
  int type;
  int x;
  int y;
  int w;
  int h;

  int left;
  int right;
  int top;
  int bottom;

  Ingredient currentIngredient=null;

  Station(int x1, int y1, int stationType) {
    x=x1;
    y=y1;
    type=stationType;
    if (type==2) {
      w=220;
      h=70;
    } else {
      w=40;
      h=40;
    }

    left=x-w/2;
    right=x+w/2;
    top=y-h/2;
    bottom=y+h/2;
  }
  void render() {
    if (type==0) {
      drawCuttingBoard();
    }
    if (type==1) {
      drawStove();
    }
    if (type==2) {
      drawDeliveryStation();
    }

    if (currentIngredient!=null) {
      currentIngredient.x=x;
      currentIngredient.y=y;
      currentIngredient.render();
    }
  }

  boolean isInteracting(Player aPlayer) {
    if (aPlayer.top <= bottom &&
      aPlayer.bottom >= top &&
      aPlayer.right >= left &&
      aPlayer.left <= right) {
      return true;
    } else {
      return false;
    }
  }

  void drawCuttingBoard() {
    rectMode(CENTER);
    noStroke();
    fill(0, 60);
    rect(x + 3, y + 4, 82, 48, 12);
    stroke(92, 58, 28);
    strokeWeight(2);
    fill(186, 140, 92);
    rect(x, y, 80, 44, 12);
    stroke(160, 118, 74);
    fill(205, 160, 110);
    rect(x - 4, y, 58, 30, 8);
    noStroke();
    fill(120, 85, 50);
    ellipse(x + 26, y, 8, 8);
    stroke(156, 112, 70);
    strokeWeight(1);
    line(x - 26, y - 8, x + 12, y - 8);
    line(x - 24, y, x + 10, y);
    line(x - 26, y + 8, x + 12, y + 8);
    stroke(130, 130, 140);
    strokeWeight(1);
    fill(220, 220, 230);
    quad(x - 8, y - 18, x + 16, y - 10, x + 10, y - 2, x - 12, y - 10);
    fill(55, 35, 20);
    stroke(35, 20, 10);
    rect(x - 18, y - 14, 16, 8, 4);
    strokeWeight(1);
  }
  void drawStove() {
    rectMode(CENTER);

    fill(90);
    stroke(0);
    rect(x, y, 40, 70, 8);

    fill(40);
    ellipse(x, y, 30, 30);

    fill(55);
    ellipse(x, y, 42, 42);

    noFill();
    stroke(120);
    ellipse(x, y, 42, 42);

    stroke(60);
    strokeWeight(6);
    line(x + 18, y - 2, x + 38, y - 8);
    strokeWeight(1);
  }

  void drawDeliveryStation() {
    rectMode(CENTER);
    stroke(0);
    fill(125, 88, 58);
    rect(x, y, 220, 70, 10);

    fill(215, 215, 215);
    rect(x, y - 18, 230, 18, 8);

    noFill();
    stroke(255);
    strokeWeight(2);
    ellipse(x - 30, y + 8, 32, 32);
    ellipse(x - 30, y + 8, 18, 18);
    ellipse(x + 30, y + 8, 32, 32);
    ellipse(x + 30, y + 8, 18, 18);

    fill(230, 210, 70);
    stroke(120, 100, 20);
    ellipse(x + 85, y - 10, 16, 16);
    fill(180, 40, 40);
    ellipse(x + 85, y - 18, 5, 5);

    fill(0);
    textAlign(CENTER);
    textSize(14);
    text("ORDER UP", x, y - 15);

    strokeWeight(1);
  }
}
