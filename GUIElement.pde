abstract public class GUIElement {
  int x, y, w, h; // bounding box
  boolean draw = true;
  color stroke = 0x000000;
  color fill = 0xffffff;
  void draw() {
    strokeWeight(1);
    stroke(stroke);
    fill(fill);
    if(draw)
      drawElement();
  }
  void setDraw(boolean draw) {
    this.draw = draw;
  }
  void setStroke(color stroke) {
    this.stroke = stroke;
  }
  void setFill(color fill) {
    this.fill = fill;
  }
  abstract void drawElement();
  void captureEvent(ScreenInterface si) {
  }
  void smallerRect(int x, int y, int w, int h, int b) {
    int d = b * 2;
    rect(x + b, y + b, w - d, h - d);
  }
}
