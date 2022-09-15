import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:particle/circle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/globals.dart';
import 'package:particle/particle.dart';
// ignore: unused_import
import 'dart:developer' as log;

class MainGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Particle particle;
  late final TextComponent score;
  @override
  Future<void> onLoad() async {
    particle = Particle(size.x * 0.18);
    add(BackGround());
    add(particle);
    add(FullCircle(size.x * 0.75, 3));
    add(Score(particle));
  }

  @override
  void onTap() {
    super.onTap();
    if (particle.tapped == false) {
      particle.vel.x = particle.position.x - particle.prevPos.x;
      particle.vel.y = particle.position.y - particle.prevPos.y;
      particle.tapped = true;
    }
  }
}

class BackGround extends PositionComponent with HasGameRef<MainGame> {
  @override
  Future<void> onLoad() async {
    position = gameRef.size / 2;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = theme.bg;
    super.render(canvas);
    canvas.drawRect(
        Rect.fromCenter(
            center: const Offset(0, 0),
            width: position.x * 2,
            height: position.y * 2),
        paint);
  }
}

class Score extends TextComponent with HasGameRef<MainGame> {
  Particle particle;
  Score(this.particle);

  @override
  Future<void>? onLoad() async {
    x = gameRef.size.x / 2;
    y = gameRef.size.y * 0.10;
  }

  @override
  void update(double dt) {
    super.update(dt);
    textRenderer =
        TextPaint(style: TextStyle(color: theme.otherBg, fontSize: 30));
    text = particle.score.toString();
  }
}
