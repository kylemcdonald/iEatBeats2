PApplet buttonApp = this;

class Button extends GUIElement {
  float buttonAreaCutoff = .01;
  float borderAreaCutoff = .01;

  int boundary = 10;
  ColorField innerField, outerField;
  boolean state, momentary;
  Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    buttonApp.registerDraw(this);
  }
  void drawElement() {
    noStroke();
    fill(stroke);
    rect(x, y, w, h);
    fill(fill);
    rect(x + boundary, y + boundary, w - boundary * 2, h - boundary * 2);
  }
  void captureEvent(ScreenInterface si) {
    ColorField[] cfs = si.getBorderDifferenceFields(this, boundary);
    innerField = cfs[0];
    outerField = cfs[1];
    stroke = outerField.getColor();
    momentary = outerField.area > borderArea() * borderAreaCutoff;
    if(!momentary) {
      state = innerField.area > area() * buttonAreaCutoff; 
      fill = innerField.getColor();
    }
  }
  int area() {
    return w * h;
  }
  int borderArea() {
    return w * h - ((w - boundary) * (h - boundary));
  }
}
