import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:particle/components/particle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/game.dart';

class Score extends TextComponent with HasGameRef<MainGame> {
  final Particle particle;
  Score(this.particle);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position.x = size.x / 2;
    position.y = size.y * 0.1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    textRenderer =
        TextPaint(style: TextStyle(color: theme.otherBg, fontSize: 30));
    text = particle.score.toString();
  }
}
