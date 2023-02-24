float brightness(PImage img) {
  float sum = 0;
  int n = img.pixels.length;
  for(int i = 0; i < n; i++) {
    int cur = img.pixels[i];
    sum += 
      ((cur & 0x00ff0000) >> 16) + 
      ((cur & 0x0000ff00) >> 8) + 
      (cur & 0x000000ff);
  }
  return (sum / (n * 3));
}

int sqDiff(color a, color b) {
  return 
    abs(((a & 0xff0000) >> 16) - (b & 0xff0000) >> 16) +
    abs(((a & 0xff00) >> 8) - (b & 0xff00) >> 8) +
    abs((a & 0xff) - (b & 0xff));
}

color sred = color(255, 0 ,0);
color sgreen = color(0, 255, 0);
color sblue = color(0, 0, 255);
color[] scolors = {sred, sgreen, sblue};

int matchColor(color a) {
  int bestMatch = Integer.MAX_VALUE;
  int bestPosition = 0;
  for(int i = 0; i < scolors.length; i++) {
    int diff = sqDiff(scolors[i], a);
    if(diff < bestMatch) {
      bestMatch = diff;
      bestPosition = i;
    }
  }
  return bestPosition;
}
