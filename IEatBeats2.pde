import processing.opengl.*;

ScreenInterface si;

int rows = 5;
int steps = 8;
int n = rows * steps;

void setup() {
  size(screen.width, screen.height, OPENGL);
  
  Vector btns = new Vector();
  float resizeSequencer = 1;
  for(int x = 0; x < steps; x++)
    for(int y = 0; y < rows; y++)
      btns.add(new MIDIButton(
        (int) (resizeSequencer * x * width / steps), 
        (int) (resizeSequencer * y * height / rows), 
        (int) (resizeSequencer * width / steps),
        (int) (resizeSequencer * height / rows), x, y));
  si = new ScreenInterface();
  for(int i = 0; i < btns.size(); i++)
    si.registerCaptureEvent((MIDIButton) btns.get(i));
    
  //Slider tempo = new Slider(5, height - 105, (int) (width * resizeSequencer), 100);
  //si.registerCaptureEvent(tempo);
    
  MIDISequencer seq = new MIDISequencer(btns, steps);
  seq.start();
  //seq.setTempoController(tempo);
}

void draw() {
  background(0);
  //if(frameCount % 30 == 0) println(frameRate);  
  //if(si.mapped != null) image(si.mapped, 0, 0);
}

boolean calibrate = true;
void keyPressed() {
  if(key == 's')
    si.cam.settings();
  if(key == 'c') {
    calibrate = !calibrate;
    si.setCalibrate(calibrate);
  }
}
