class Connector {
  color col, BASE = color(0, 100), HIGHLIGHT = color(255, 210, 60);
  //line from endpoints p to q; stored as Node array 0 to 1
  Node[] pq = new Node[2];
  Node tempNode;
  boolean dragging;
  float len;
  PVector midpoint;
  boolean active;

  //Connector (float x1, float y1, float x2, float y2) {
  //  //Adds non-dragging line between two specified points
  //  pq[0] = new PVector(x1, y1);
  //  pq[1] = new PVector(x2, y2);
  //  len = PVector.dist(pq[0], pq[1]);
  //  dragging = false;
  //}

  Connector (Node n) {
    //Adds dragging line between point and mouse
    pq[0] = n;
    tempNode = new Node(n.x, n.y);
    pq[1] = tempNode;
    dragging = true;
    col = BASE;
    active = true;
  }

  void display() {
    updateLenMid();
    mouseOver();
    strokeWeight(2);
    if (active) stroke(HIGHLIGHT);
    else stroke(col);
    line (pq[0].x, pq[0].y, pq[1].x, pq[1].y);
  }

  void mouseOver() {
    if (dist(mouseX, mouseY, midpoint.x, midpoint.y) < 5)
      setActive(true);
    else setActive(false);
  }

  void setActive(boolean s) {
    //toggle activeCon if active state is changing
    //adds or removes itself from activeCons list only when changing
    if (s != active) {
      if (s == true) activeCons.add(this);
      else activeCons.remove(this);
      active = s;
    }
  }

  void drag() {
    if (dragging) {
      tempNode.setLoc(mouseX, mouseY);
    }
  }

  void setEnd (Node n) {
    pq[1] = n;
    tempNode = null; //TODO:needed?
  }

  void updateLenMid() {
    len = dist(pq[0].x, pq[0].y, pq[1].x, pq[1].y);
    float midx = (pq[0].x + pq[1].x)/2;
    float midy = (pq[0].y + pq[1].y)/2;
    midpoint = new PVector(midx, midy);
  }

  boolean containsNode (Node n) {
    return (pq[0]==n || pq[1]==n);
  }
}
