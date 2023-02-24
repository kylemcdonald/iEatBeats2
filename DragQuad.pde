PApplet dragQuadApp = this;

public class DragQuad extends GUIElement {
  DragPoint[] p;
  DragQuad(int x, int y, int w, int h) {
    p = new DragPoint[4];
    p[0] = new DragPoint(x, y);
    p[1] = new DragPoint(x + w, y);
    p[2] = new DragPoint(x + w, y + h);
    p[3] = new DragPoint(x, y + h);
    dragQuadApp.registerDraw(this);
    setStroke(color(255, 0, 0));
    setFill(color(255, 0));
  }
  void setDraw(boolean draw) {
    super.setDraw(draw);
    for(int i = 0; i < 4; i++)
      p[i].setDraw(draw);
  }
  void setStroke(color stroke) {
    super.setStroke(stroke);
    for(int i = 0; i < 4; i++)
      p[i].stroke = stroke;
  }
  void setFill(color fill) {
    super.setFill(fill);
    for(int i = 0; i < 4; i++)
      p[i].fill = fill;
  }
  void drawElement() {
    beginShape();
    for(int i = 0; i < 4; i++)
      vertex(p[i].x, p[i].y);
    endShape(CLOSE);
  }
}
