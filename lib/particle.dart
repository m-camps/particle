import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:particle/circle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';
import 'package:particle/config/constants.dart';
import 'package:particle/game.dart';
import 'dart:developer' as console;

class Particle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  // Variables
  late Vector2 exitVel;
  late Vector2 prevPos;
  late double vel = 0;
  late double radian;
  late Color selColor;
  bool tapped = false;
  double score = 0;

  // Game Variables
  double pathRadius = 100;
  double particleSize = 10;
  double speedStart = 100;
  double speedMultiplier = 2;
  double direction = -1;
  List<Color> color = [theme.blue];

  // Hitbox
  late ShapeHitbox hitbox;

  Particle.fromJson(Map<String, dynamic> json)
      : pathRadius = json['pathRadius'],
        particleSize = json['particleSize'],
        speedStart = json['speedStart'],
        speedMultiplier = json['speedMultiplier'],
        direction = json['direction'],
        color = theme.parseColors(json['color']);

  @override
  Future<void> onLoad() async {
    resetGame();
    hitbox = CircleHitbox(radius: particleSize, anchor: Anchor.center)
      ..paint = config.hitboxPaint
      ..renderShape = config.showHitbox;
    add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      const Offset(0, 0),
      particleSize,
      defaultPaint(
        selColor,
        PaintingStyle.fill,
      ),
    );
  }

  void resetParticle() {
    exitVel = Vector2(0, 0);
    prevPos = Vector2(0, 0);
    tapped = false;
    vel += speedMultiplier;
    selColor = color.elementAt(Random().nextInt(color.length));
  }

  void resetGame() {
    resetParticle();
    radian = 0;
    vel = speedStart;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    resetGame();
  }

  @override
  void update(double dt) {
    final stepSpeed = dt * vel;
    if (tapped == false) {
      radian += stepSpeed * direction * degToRad;
      prevPos = Vector2(position.x, position.y);
      position = Vector2(pathRadius * cos(radian), pathRadius * sin(radian));
    } else {
      position = Vector2(position.x + exitVel.x, position.y + exitVel.y);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CirclePart) {
      if (other.color == selColor) {
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
