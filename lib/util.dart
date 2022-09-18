final FpsCounter fpsCounter = FpsCounter();

class FpsCounter {
  double frames = 0;
  double fps = 0;
  double lastFps = 0;

  update(dt) {
    frames += dt;
    fps += 1;
    if (frames > 1) {
      frames = 0;
      lastFps = fps;
      fps = 0;
    }
  }
}
