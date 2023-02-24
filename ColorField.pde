class ColorField {
  int r, g, b, x, y;
  int area;
  ColorField() {
  }
  ColorField(int area) {
    this.area = area;
  }
  ColorField(int r, int g, int b, int area) {
    this(area);
    this.r = r;
    this.g = g;
    this.b = b;
  }
  void add(color c) {
    r += (c & 0xff0000) >> 16;
    g += (c & 0xff00) >> 8;
    b += (c & 0xff);
    area++;
  }
  void add(color c, int x, int y) {
    add(c);
    this.x += x;
    this.y += y;
  }
  color getColor() {
    if(area == 0)  
      return color(0);
    return color(r / area, g / area, b / area);
  }
  int getX() {
    if(area == 0)
      return 0;
    return x / area;
  }
  int getY() {
    if(area == 0)
      return 0;
    return y / area;
  }
}
