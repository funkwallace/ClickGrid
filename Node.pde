class Node {
  float x, y;
  color col, BASE = color(100, 160, 235), HIGHLIGHT = color(255, 210, 60);
  boolean dragging;

  Node(float x_, float y_) {
    x = x_;
    y = y_;
    col = BASE;
    dragging = false;
  }

  void display() {
    noStroke();
    if (mouseOver()) {
      fill(HIGHLIGHT);
      text(x+","+y,x+10,y-15);
    }
      else fill(col);
    ellipse(x, y, 10, 10);
  }

  boolean mouseOver() {
    if (dist(mouseX, mouseY, this.x, this.y) < 5)
      return true;
    else return false;
  }
  
  void drag() {
    //constrained so nodes can't be dragged outside of window
    if (dragging) {
      x = constrain(mouseX,0,width);
      y = constrain(mouseY,0,height);
    }
  }
  
  void setLoc (float x_, float y_) {
    x = x_;
    y = y_;
  }
}
