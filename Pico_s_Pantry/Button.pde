class Button {
  int x; //button x
  int y; //button y
  int s; //button size
  color c; //button color

  Button(int x1, int y1, int s1, color c1) {
    x=x1;
    y=y1;
    s=s1;
    c=c1;
  }

  void render() {
    //draws the button
    rectMode(CENTER);
    noStroke();
    fill(0, 50);
    rect(x + 4, y + 4, 220, 58, 16);

    stroke(255, 255, 255, 80);
    strokeWeight(2);
    fill(c);
    rect(x, y, 220, 58, 16);

    noStroke();
    fill(255, 255, 255, 35);
    rect(x, y - 10, 200, 18, 12);

    stroke(0, 40);
    strokeWeight(1);
    fill(red(c) + 10, green(c) + 10, blue(c) + 10, 40);
    rect(x, y, 206, 44, 12);
  }

  boolean isInButton() {
    //checks to see if mouse is over button and returns true or false
    rectMode(CENTER);
    int left=x-110;
    int right=x+110;
    int top=y-29;
    int bottom=y+29;
    if (mouseX>=left && mouseX<=right &&
      mouseY>=top && mouseY<=bottom) {
      return true;
    } else {
      return false;
    }
  }
}
