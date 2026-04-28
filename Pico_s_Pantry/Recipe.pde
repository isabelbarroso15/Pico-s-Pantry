class Recipe {
  int startTime;
  int timeLimit;

  boolean needsBun;
  boolean needsCheese;
  boolean needsTomato;
  boolean needsLettuce;
  boolean needsMeat;

  Recipe() {
    startTime=millis();
    timeLimit=100000;

    needsBun=true;
    needsMeat=true;

    needsCheese=random(1)<0.5;
    needsTomato=random(1)<0.5;
    needsLettuce=random(1)<0.5;
  }
  int timeLeft() {
    return timeLimit-(millis()-startTime);
  }
  int secondsLeft() {
    return max(0, timeLeft()/1000);
  }

  void renderRecipe(int x) {
    int ticketW = 120;
    int ticketH = 170;
    int y = 20;
    rectMode(CORNER);
    noStroke();
    fill(0, 50);
    rect(x + 4, y + 4, ticketW, ticketH, 10);

    stroke(180, 160, 120);
    fill(245, 235, 210);
    rect(x, y, ticketW, ticketH, 10);

    fill(90, 60, 35);
    textAlign(CENTER, TOP);
    textSize(16);
    text("ORDER", x + ticketW/2, y + 10);

    stroke(190, 170, 130);
    line(x + 12, y + 34, x + ticketW - 12, y + 34);

    textAlign(LEFT, TOP);
    textSize(14);
    fill(60, 45, 30);

    int lineY = y + 48;

    if (needsBun) {
      text("Bun", x + 18, lineY);
      lineY += 22;
    }
    if (needsMeat) {
      text("Cooked Meat", x + 18, lineY);
      lineY += 22;
    }
    if (needsCheese) {
      text("Sliced Cheese", x + 18, lineY);
      lineY += 22;
    }
    if (needsTomato) {
      text("Sliced Tomato", x + 18, lineY);
      lineY += 22;
    }
    if (needsLettuce) {
      text("Sliced Lettuce", x + 18, lineY);
      lineY += 22;
    }

    int time = timeLeft();
    fill(90, 60, 35);
    textAlign(CENTER, TOP);
    textSize(12);
    text("Time: " + time/1000, x + ticketW/2, y + ticketH - 10);
  }
}
