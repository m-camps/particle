import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:particle/circle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';
import 'package:particle/game.dart';
// ignore: unused_import
import 'dart:developer' as console;

class Particle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  late Vector2 vel;
  late Vector2 prevPos;
  late double angleVel;

  late Vector2 middle;
  double radius = 120;
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
    angleVel = 3; /* degree/tick */
    middle = gameRef.size / 2;
    tapped = false;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    resetParticle();
  }

  @override
  void update(double dt) {
    if (tapped == false) {
      radian += angleVel * -0.01745329252;
      prevPos = Vector2(position.x, position.y);
      position = Vector2(
          radius * cos(radian) + middle.x, radius * sin(radian) + middle.y);
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
      } else {
        console.log("Reset");
        resetParticle();
        score = 0;
      }
    }
  }
}
