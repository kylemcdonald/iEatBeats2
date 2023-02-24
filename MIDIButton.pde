class MIDIButton extends Button {
  int padding = 5;
  
  int step, note;
  MIDIButton(int x, int y, int w, int h, int step, int note) {
    super(x, y, w, h);
    this.step = step;
    this.note = note;
  }
  int triggerDuration = 300;
  int lastTrigger;
  void trigger(MIDISequencer seq) {
    if(state) {
      lastTrigger = millis();
      seq.bangNote(note + 5 * matchColor(fill));
    }
  }
  void drawElement() {
    int diff = millis() - lastTrigger;
    noStroke();
    if(diff < triggerDuration)
      fill(map(diff, 0, triggerDuration, 255, 0));
    else
      fill(stroke);
    smallerRect(x, y, w, h, padding);
    fill(fill);
    smallerRect(x, y, w, h, boundary + padding);
    /*
    fill(255);
    if(innerField != null) {
      color c = innerField.getColor();
      text(red(c) + " " + green(c) + " " + blue(c), x + 64, y + 64);
      text(innerField.area + " / " + area(), x + 64, y + 44);
      text(outerField.area + " / " + borderArea(), x + 64, y + 64);
      text(state + " " + momentary, x + 64, y + 84);
    }*/
    
  }
}
