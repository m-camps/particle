calcFpsModifier(double fps) {
  if (fps != 0) return (60 / fps);
  return (1);
}
