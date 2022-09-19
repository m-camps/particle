import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:particle/circle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/particle.dart';
// ignore: unused_import
import 'dart:developer' as log;

import 'package:particle/util.dart';

class MainGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Particle particle = Particle(80);
  late final TextComponent score;
  @override
  Future<void> onLoad() async {
    add(BackGround());
    add(ScaleWrapper(particle));
    add(Score(particle));
    add(FpsTextComponent(windowSize: 120));
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

  @override
  void update(double dt) {
    super.update(dt);
    fpsCounter.update(dt);
  }
}

class ScaleWrapper extends PositionComponent with HasGameRef<MainGame> {
  final Particle particle;

  ScaleWrapper(this.particle);

  @override
  Future<void> onLoad() async {
    add(particle);
    add(FullCircle(400, [theme.green, theme.blue, theme.red]));
    // add(FullCircle.fromJson(await readJson('levels/level1.json')));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2;
    scale = Vector2(gameRef.size.x / 500, gameRef.size.x / 500);
  }
}

class BackGround extends PositionComponent with HasGameRef<MainGame> {
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = theme.bg;
    super.render(canvas);
    canvas.drawRect(
        Rect.fromCenter(
            center: const Offset(0, 0),
            width: gameRef.size.x,
            height: gameRef.size.y),
        paint);
  }
}

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

class FPS extends TextComponent with HasGameRef<MainGame> {
  @override
  void update(double dt) {
    super.update(dt);
    textRenderer =
        TextPaint(style: TextStyle(color: theme.otherBg, fontSize: 16));
    text = "fps: ${fpsCounter.lastFps}";
  }
}
