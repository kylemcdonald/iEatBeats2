import JMyron.*;

PApplet screenInterfaceApp = this;

int camWidth = 320;
int camHeight = 240;

int cameraUpdate = 3;
int presenceCutoff = 256;

PFont trebuchet;

public class ScreenInterface {
  JMyron cam;
  PImage empty;
  PImage mapped;
  ScreenInterface() {
    screenInterfaceApp.registerDraw(this);
    cam = new JMyron();
    cam.start(camWidth, camHeight);
    cam.findGlobs(0);
    quadCalibrate = new DragQuad(0, 0, camWidth, camHeight);
    camScreenMapping = new int[height * width];
    elements = new Vector();
    empty = createImage(width, height, RGB);
    mapped = createImage(width, height, RGB);
    trebuchet = loadFont("TrebuchetMS-10.vlw");
    textFont(trebuchet, 10);
    textMode(SCREEN);
    textAlign(LEFT, TOP);
  }
  PImage camImage() {
    PImage camImage = createImage(camWidth, camHeight, RGB);
    int[] camPixels = cam.cameraImage();
    arraycopy(camPixels, camImage.pixels);
    return camImage;
  }
  void draw() {
    if(frameCount % cameraUpdate == 0)
      captureEvent();
    if(calibrate)
      image(camImage(), 0, 0);
  }
  Vector elements;
  void registerCaptureEvent(GUIElement e) {
    elements.add(e);
  }
  void captureEvent() {
    cam.update();
    int[] curImage = cam.cameraImage();
    refreshMapped();
    for(int i = 0; i < elements.size(); i++)
      ((GUIElement) elements.get(i)).captureEvent(this);
  }
  DragQuad quadCalibrate;
  int camScreenMapping[];
  void updateMapping() {
    DragQuad q = quadCalibrate;
    int maxPosition = (camWidth * camHeight) - 1;
    for(int y = 0; y < height; y++) {
      float yamt = (float) y / height;
      float leftx = lerp(q.p[0].x, q.p[3].x, yamt);
      float lefty = lerp(q.p[0].y, q.p[3].y, yamt);
      float rightx = lerp(q.p[1].x, q.p[2].x, yamt);
      float righty = lerp(q.p[1].y, q.p[2].y, yamt);
      for(int x = 0; x < width; x++) {
        float xamt = (float) x / width;
        float midx = lerp(leftx, rightx, xamt);
        float midy = lerp(lefty, righty, xamt);
        int cur = y * width + x;
        camScreenMapping[cur] = int(midx) + ((int) midy * camWidth);
        if(camScreenMapping[cur] > maxPosition)
          camScreenMapping[cur] = maxPosition;
      }
    }
    refreshMapped();
    empty.copy(mapped, 0, 0, width, height, 0, 0, width, height);
  }
  boolean calibrate = true;
  void setCalibrate(boolean calibrate) {
    this.calibrate = calibrate;
    quadCalibrate.setDraw(calibrate);
    if(!calibrate)
      updateMapping();
  }
  void refreshMapped() {
    int[] camImage = cam.cameraImage();
    if(camImage.length == camWidth * camHeight)
      for(int i = 0; i < camScreenMapping.length; i++)
        mapped.pixels[i] = camImage[camScreenMapping[i]];
  }
  int[] getSqDifference(GUIElement e) {
    int[] diff = new int[e.w * e.h];
    int maxh = min(e.h, height - e.y);
    int maxw = min(e.w, width - e.x);
    for(int i = 0; i < maxh; i++) {
      int y = (e.y + i) * width;
      for(int j = 0; j < maxw; j++) {
        int cur = y + e.x + j;
        diff[i * e.w + j] = sqDiff(empty.pixels[cur], mapped.pixels[cur]);
      }
    }
    return diff;
  }
  ColorField getDifferenceField(GUIElement e) {
    int[] diff = getSqDifference(e);
    ColorField cf = new ColorField();
    int maxh = min(e.h, height - e.y);
    int maxw = min(e.w, width - e.x);
    for(int i = 0; i < maxh; i++) {
      int y = i * e.w;
      int my =(e.y + i) * width + e.x;
      for(int j = 0; j < maxw; j++) {
        int cur = y + j;
        int mcur = my + j;
        if(diff[cur] > presenceCutoff) {
          cf.add(mapped.pixels[mcur]);
        }
      }
    }
    return cf;
  }
  ColorField[] getBorderDifferenceFields(GUIElement e, int innerBorder) {
    int[] diff = getSqDifference(e);
    ColorField icf = new ColorField();
    ColorField bcf = new ColorField();
    int maxh = min(e.h, height - e.y);
    int bottomh = maxh - innerBorder;
    int maxw = min(e.w, width - e.x);
    int rightw = maxw - innerBorder;
    for(int i = 0; i < maxh; i++) {
      int y = i * e.w;
      int my =(e.y + i) * width + e.x;
      for(int j = 0; j < maxw; j++) {
        int cur = y + j;
        int mcur = my + j;
        if(diff[cur] > presenceCutoff) {
          color mappedPixel = mapped.pixels[mcur];
          icf.add(mappedPixel, j, i);
          if(i < innerBorder || i > bottomh ||
            j < innerBorder || j > rightw)
            bcf.add(mappedPixel);
        }
      }
    }
    return new ColorField[]{icf, bcf};
  }
}
