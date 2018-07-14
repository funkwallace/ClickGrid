int gridScale = 40;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Connector> cons = new ArrayList<Connector>();
Node activeNode = null;
Node dragNode = null;
Connector activeCon = null;
float totLen;

void setup() {
  size(600, 400);
  noCursor();
}

void draw() {
  background(255);
  drawGrid();

  //draw nodes
  for (int i=nodes.size()-1; i>=0; i--) {
    Node n = nodes.get(i);
    n.drag();
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
  text("length:  "+totLen/gridScale, 10, 55);
  //test dispay
  if (activeNode==null) text("null", 10, 75);
  else text(activeNode.x, 10, 75);
  if (activeCon==null) text("null", 10, 95);
  else text(activeCon.midpoint.x, 10, 95);
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
  //activeNode set to null when mouse released, so always need to check
  //if multiple nodes could be active, only latest one in List ends up selected
  //for (Node n : nodes) {
  //  if (n.mouseOver()) activeNode = n;
  //}
  //if not dragging new con, activeCon is mouseover midpoint
  //if (activeCon == null) {
  //  for (Connector c : cons) {
  //    if (c.mouseOver()) activeCon = c;
  //  }
  //}
  //if active node, do things; else add node at current mouse position
  if (activeNode != null) {
    //if RIGHT mouseclick

    if (mouseButton == RIGHT && activeCon == null) {
      removeNodeCon(activeNode);
    } else if (activeCon != null) {
      //LEFT or RIGHT click, complete connector
      activeCon.dragging = false;
      activeCon.setEnd(activeNode);
      activeCon = null;
    } else if (keyPressed && keyCode == SHIFT) {
      //else LEFT click + SHIFT; add connector
      activeNode.col = color(0, 230, 0);
      activeCon = new Connector(activeNode);
      cons.add(activeCon);
    } else {
      //else LEFT click drag
      dragNode = activeNode;
      dragNode.dragging = true;
    }
  } 
  //No active node; either cancel connector or add node
  else {
    if (activeCon != null) {
      cons.remove(activeCon);
      activeCon = null;
    } else {
      nodes.add(new Node(mouseX, mouseY));
    }
  }
}

void mouseReleased() {
  //on mouse release, stop dragging activeNode
  if (dragNode != null) {
    dragNode.dragging = false;
    dragNode = null;
  }
}

void removeNodeCon(Node n) {
  //typically pass in activeNode
  //first remove all connected Connectors
  for (int i=cons.size()-1; i>=0; i--) {
    Connector c = cons.get(i);
    if (c.containsNode(n)) {
      cons.remove(c);
    }
  }
  n.setActive(false);
  nodes.remove(n);
  //TODO:ensure activeNode reset to null- necesary?
  //activeNode = null;
}
