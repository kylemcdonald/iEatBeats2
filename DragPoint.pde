PApplet dragPointApp = this;

public class DragPoint extends GUIElement {
  float side = 32;
  DragPoint(int x, int y) {
    this.x = x;
    this.y = y;
    dragPointApp.registerDraw(this);
    dragPointApp.registerMouseEvent(this);
  }
  void drawElement() {
    ellipseMode(CENTER);
    ellipse(x, y, side / 2, side / 2);
  }
  
  boolean dragging = false;
  int offx, offy;
  void mouseEvent(MouseEvent event) {
    int mx = event.getX();
    int my = event.getY();
    switch(event.getID()) {
      case MouseEvent.MOUSE_PRESSED:
        dragging = dist(mx, my, x, y) < side;
        offx = x - mx;
        offy = y - my;
        break;
      case MouseEvent.MOUSE_RELEASED:
        dragging = false;
        break;
      case MouseEvent.MOUSE_DRAGGED:
        if(dragging) {
          x = mx + offx;
          y = my + offy;
        }
        break;
    }
  }
}
