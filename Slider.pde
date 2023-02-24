PApplet sliderApp = this;

class Slider extends GUIElement {
  float sliderAreaCutoff = .01;
  float borderAreaCutoff = .01;

  int boundary = 10;
  ColorField innerField, outerField;
  int position;
  boolean state, momentary;
  Slider(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    sliderApp.registerDraw(this);
    position = w / 2;
  }
  void drawElement() {
    noStroke();
    fill(stroke);
    rect(x, y, w, h);
    fill(fill);
    rect(constrain(x + position - h / 2, x, x + w - h / 2), y, h, h);
  }
  void captureEvent(ScreenInterface si) {
    ColorField[] cfs = si.getBorderDifferenceFields(this, boundary);
    innerField = cfs[0];
    outerField = cfs[1];
    fill = innerField.getColor();
    stroke = outerField.getColor();
    momentary = outerField.area > borderArea() * borderAreaCutoff;
    if(!momentary) {
      state = innerField.area > area() * sliderAreaCutoff; 
      position = innerField.getX();
    }
  }
  int area() {
    return w * h;
  }
  int borderArea() {
    return w * h - ((w - boundary) * (h - boundary));
  }
}
