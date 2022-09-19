import 'package:flame/components.dart';

Global global = Global();

class Global {
  double score = 0;
  FpsTextComponent fps = FpsTextComponent(windowSize: 1);
}
