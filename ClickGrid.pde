float gridScale = 40, minGridScale = 5;
float mScale = 1/gridScale, zoomInc = 5;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Connector> cons = new ArrayList<Connector>();
ArrayList<Node> activeNodes = new ArrayList<Node>();
ArrayList<Connector> activeCons = new ArrayList<Connector>();
Node dragNode = null;
Connector addingCon = null;
float totLen;
boolean snapMode = true;
float snapX, snapY;

void setup() {
  size(600, 400);
  noCursor();
}

void draw() {
  background(255);
  drawGrid();

  //move dragNode; use snap if snapMode
  if (dragNode != null) {
    dragNode.drag();
    if (snapMode) {
      snapX = round(dragNode.x/gridScale)*gridScale;
      snapY = round(dragNode.y/gridScale)*gridScale;
      stroke(220, 20, 0, 80);
      noFill();
      rectMode(RADIUS);
      rect(snapX, snapY, 5, 5);
    }
  }

  //draw nodes
  for (int i=nodes.size()-1; i>=0; i--) {
    Node n = nodes.get(i);
    n.display();
  }
  //draw connectors
  totLen = 0;
  for (int i=cons.size()-1; i>=0; i--) {
    Connector c = cons.get(i);
    c.drag();
    c.display();
    totLen += c.len;
  }
  //show pointer
  strokeWeight(1);
  stroke(100);
  fill(100, 50);
  ellipse(mouseX, mouseY, 10, 10);
  //text
  fill(0);
  textSize(15);
  text("# Nodes: "+nodes.size(), 10, 15);
  text("# Cons:  "+cons.size(), 10, 35);
  text("length:  "+totLen, 10, 55);
  //test dispay
  text("active N: "+activeNodes.size(), 10, 75);
  text("active C: "+activeCons.size(), 10, 95);
}

void drawGrid() {
  strokeWeight(1);
  for (int i=0; i<=width; i+=gridScale) {
    stroke(200);
    line(i, 0, i, height);
  }
  for (int j=0; j<=height; j+=gridScale) {
    stroke(200);
    line(0, j, width, j);
  }
}

void mousePressed() {
  //if multiple nodes active, only first one in List ends up selected

  //If active node, do things; else add node at current mouse position
  if (!activeNodes.isEmpty()) {
    //RIGHT mouseclick, remove active con or node
    if (mouseButton == RIGHT) { 
      if (!activeCons.isEmpty()) removeCon(activeCons.get(0));
      else removeNodeCon(activeNodes.get(0));
    } else if (addingCon != null) {
      //LEFT or RIGHT click, complete connector
      //prevent connect node to itself or already connected node
      if (!isConnected(addingCon.pq[0], activeNodes.get(0))) {
        addingCon.dragging = false;
        addingCon.setEnd(activeNodes.get(0));
        addingCon = null;
      }
    } else if (keyPressed && keyCode == SHIFT) {
      //else LEFT click + SHIFT; add connector
      activeNodes.get(0).col = color(0, 230, 0);
      addingCon = new Connector(activeNodes.get(0));
      cons.add(addingCon);
    } else {
      //else LEFT click drag
      dragNode = activeNodes.get(0);
      dragNode.dragging = true;
    }
  }
  //No active node; either cancel/remove connector or add node
  else {
    //LEFT or RIGHT click first cancel adding con
    if (addingCon != null) {
      removeCon(addingCon);
      addingCon = null;
    } else if (mouseButton == RIGHT) { 
      //else RIGHT click, remove active con
      if (!activeCons.isEmpty()) removeCon(activeCons.get(0));
    } else nodes.add(new Node(mouseX, mouseY));
  }
}

void mouseReleased() {
  //on mouse release, stop dragging activeNode
  if (dragNode != null) {
    dragNode.dragging = false;
    if (snapMode) {
      dragNode.setLoc(snapX, snapY);
      dragNode.mUpdate();
    }
    dragNode = null;
  }
}

void removeNodeCon(Node n) {
  //typically pass in active Node
  //first remove all connected Connectors
  for (int i=cons.size()-1; i>=0; i--) {
    Connector c = cons.get(i);
    if (c.containsNode(n)) removeCon(c);
  }
  //if node active, will remove itself from activeNodes list
  n.setActive(false);
  nodes.remove(n);
}

void removeCon(Connector c) {
  //typically pass in active Connector
  //if con active, will remove itself from activeCons list
  c.setActive(false);
  cons.remove(c);
}

void keyPressed() {
  //Use keys to increment zoom scale
  //nested if prevents gridScale from reaching zero, or 1/0 for mScale later
  if (key == '=' || key == '+') rescale(gridScale + zoomInc);
  else if (key == '-' || key == '_') {
    if (gridScale > minGridScale) rescale(gridScale - zoomInc);
  } else if (key == 'p' || key == 'P') {
    //toggle snap to grid
    snapMode = !snapMode;
  }
}

void rescale (float newScale) {
  float sFactor = newScale / gridScale;
  gridScale = newScale;
  mScale = 1/gridScale;
  for (Node n : nodes) {
    n.setLoc(n.x * sFactor, n.y * sFactor);
    n.mUpdate();
  }
}

boolean isConnected (Node p, Node q) {
  for (Connector c:cons) {
    if (c.containsNode(p) && c.containsNode(q)) return true;
  }
  return false;
}
