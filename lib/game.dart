import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:particle/components/circle.dart';
import 'package:particle/components/info.dart';
import 'package:particle/components/score.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';
import 'package:particle/json.dart';
import 'package:particle/components/particle.dart';
// ignore: unused_import
import 'dart:developer' as log;

class MainGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Particle particle;
  late ScaleWrapper wrapper;
  late List<FullCircle> circles = [FullCircle()];
  final String level;

  MainGame(this.level);

  @override
  Future<void> onLoad() async {
    await buildGame();
    add(BackGround());
    add(ScaleWrapper(particle, circles));
    add(Score(particle));
    if (config.debug == true) add(Debug(particle));
  }

  Future<void> buildGame() async {
    final json = await readJson(level);
    particle = Particle.fromJson(json['Particle']);
    final allCircles = json['Circles'] as List;
    circles = allCircles.map((i) => FullCircle.fromJson(i)).toList();
  }

  @override
  void onTap() {
    super.onTap();
    if (particle.tapped == false) {
      particle.exitVel.x = particle.position.x - particle.prevPos.x;
      particle.exitVel.y = particle.position.y - particle.prevPos.y;
      particle.tapped = true;
    }
  }
}

class ScaleWrapper extends PositionComponent with HasGameRef<MainGame> {
  final Particle particle;
  final List<FullCircle> circles;

  ScaleWrapper(this.particle, this.circles);

  @override
  Future<void> onLoad() async {
    add(particle);
    for (FullCircle circle in circles) {
      add(circle);
    }
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
