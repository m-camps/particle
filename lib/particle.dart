import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:particle/circle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';
import 'package:particle/config/globals.dart';
import 'package:particle/game.dart';
// ignore: unused_import
import 'dart:developer' as console;

class Particle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  late Vector2 vel;
  late Vector2 prevPos;
  late double angleVel = 0;

  double radius;
  double radian = 0;
  late Color color;
  bool tapped = false;
  late ShapeHitbox hitbox;
  double score = 0;

  Particle(this.radius);
  @override
  Future<void> onLoad() async {
    resetParticle();
    hitbox = CircleHitbox(radius: 10, anchor: Anchor.center)
      ..paint = config.hitboxPaint
      ..renderShape = config.showHitbox;
    add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    color = theme.blue;
    canvas.drawCircle(
      const Offset(0, 0),
      10,
      defaultPaint(
        color,
        PaintingStyle.fill,
      ),
    );
  }

  void resetParticle() {
    vel = Vector2(0, 0);
    prevPos = Vector2(0, 0);
    angleVel += 2;
    tapped = false;
  }

  void resetGame() {
    resetParticle();
    angleVel = 150; /* degree/tick */
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    resetGame();
  }

  @override
  void update(double dt) {
    final stepSpeed = dt * angleVel;
    if (tapped == false) {
      radian += stepSpeed * -0.01745329252;
      prevPos = Vector2(position.x, position.y);
      position = Vector2(radius * cos(radian), radius * sin(radian));
    } else {
      position = Vector2(position.x + vel.x, position.y + vel.y);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CirclePart) {
      if (other.color == color) {
        console.log("Score");
        resetParticle();
        score += 1;
      } else if (other.color == theme.empty) {
      } else {
        console.log("Reset");
        resetGame();
        score = 0;
      }
    }
  }
}
