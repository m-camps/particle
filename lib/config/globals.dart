import 'package:flame/components.dart';

Global global = Global();

class Global {
  double score = 0;
  FpsComponent fps = FpsComponent();
  Map<String, double> highscores = {
    "Precision": 0,
  };
}
