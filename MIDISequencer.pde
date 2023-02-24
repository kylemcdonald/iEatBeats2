import themidibus.*;

PApplet midiSequencerApplet = this;

class MIDISequencer extends Thread {
  int minTempo = 50;
  int maxTempo = 400;
  int curTempo = 200;
  int step, steps;
  Vector buttons;
  MidiBus midiBus;
  MIDISequencer(Vector buttons, int steps) {
    this.buttons = buttons;
    this.steps = steps;
    MidiBus.list();
    midiBus = new MidiBus(midiSequencerApplet, -1, 10); // open MidiYoke 1
  }
  Slider tempo;
  void setTempoController(Slider tempo) {
    this.tempo = tempo;
  } 
  public void run() {
    while(true) {
      for(int i = 0; i < buttons.size(); i++) {
        MIDIButton cur = (MIDIButton) buttons.get(i);
        if(cur.step == step)
          cur.trigger(this);
      }
      step = (step + 1) % steps;
      //int curTempo = (int) map(tempo.position, 0, tempo.w, minTempo, maxTempo);
      try {
        Thread.sleep(curTempo);
      } catch (InterruptedException e) {
      }
    }
  }
  void bangNote(int pitch) {
    new MIDIBang(midiBus, 0, pitch, 128, curTempo);
  }
}

class MIDIBang extends Thread {
  MidiBus bus;
  int channel, pitch, velocity, len;
  MIDIBang(MidiBus bus, int channel, int pitch, int velocity, int len) {
    this.bus = bus;
    this.channel = channel;
    this.pitch = pitch;
    this.velocity = velocity;
    this.len = len;
    this.start();
  }
  public void run() {
    bus.sendNoteOn(channel, pitch, velocity);
    try {
      sleep(len);
    } catch (Exception e) {}
    bus.sendNoteOff(channel, pitch, velocity);
  }
}
