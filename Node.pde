class Node {
  float x, y, xm, ym;
  color col, BASE = color(100, 160, 235), HIGHLIGHT = color(255, 210, 60);
  boolean dragging;
  boolean active;

  Node(float x_, float y_) {
    x = x_;
    y = y_;
    mUpdate(); //update x,y to xm,ym (aka model coords)
    col = BASE;
    dragging = false;
    active = false;
  }

  void display() {
    mouseOver();
    noStroke();
    if (active) {
      fill(HIGHLIGHT);
      text(xm+","+ym, x+10, y-15);
    } else {
      fill(col);
    }
    ellipse(x, y, 10, 10);
  }

  void mouseOver() {
    if (dist(mouseX, mouseY, this.x, this.y) < 5)
      setActive(true);
    else setActive(false);
  }

  void setActive(boolean s) {
    //toggle activeNode if active state is changing
    //adds or removes itself from activeNodes list only when changing
    if (s != active) {
      if (s == true) activeNodes.add(this);
      else activeNodes.remove(this);
      active = s;
    }
  }

  void drag() {
    //constrained so nodes can't be dragged outside of window
    if (dragging) {
      x = constrain(mouseX, 0, width);
      y = constrain(mouseY, 0, height);
      mUpdate();
    }
  }

  void setLoc (float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void mUpdate () {
    xm = map(x,0,width,0,width*mScale);
    ym = map(y,0,height,0,height*mScale);
  }
}
