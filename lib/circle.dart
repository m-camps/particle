import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';
import 'package:particle/game.dart';

// ignore: unused_import
import 'dart:developer' as log;

class FullCircle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  final double radius;
  final double segments;
  late List<Color> colors;

  @override
  FullCircle(this.radius, this.segments);

  @override
  Future<void> onLoad() async {
    position = gameRef.size / 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    removeAll(children);
    createCircle();
    angle += 1.5 * 0.01745329252;
  }

  createCircle() {
    colors = [
      theme.blue,
      theme.red,
      theme.green,
      theme.yellow,
      theme.purple,
      theme.brown,
    ];
    final step = 360 / segments;
    final Vector2 centerPos = Vector2(size.x / 2, size.y / 2);
    int colorIndex = 0;
    for (double i = 0; i < 360; i += step) {
      add(CirclePart(
          centerPos, i, step, radius, colors.elementAt(colorIndex), 40));
      colorIndex++;
    }
  }
}

class CirclePart extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final Color color;
  final double stroke;
  late ShapeHitbox hitbox;

  CirclePart(Vector2 pos, this.startAngle, this.sweepAngle, this.radius,
      this.color, this.stroke)
      : super(position: pos);

  @override
  Future<void> onLoad() async {
    hitbox = PolygonHitbox(makeHitbox())
      ..paint = config.hitboxPaint
      ..renderShape = config.showHitbox;
    add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawArc(
      Rect.fromCenter(
          center: const Offset(0, 0), width: radius, height: radius),
      startAngle * 0.01745329252,
      sweepAngle * 0.01745329252,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
  }

  List<Vector2> makeHitbox() {
    List<Vector2> inner = [];
    List<Vector2> outer = [];

    for (double i = startAngle;
        i <= sweepAngle + startAngle;
        i += config.hitboxRes) {
      inner.add(Vector2((radius / 2 - (stroke / 2)) * cos(i * 0.01745329252),
          (radius / 2 - (stroke / 2)) * sin(i * 0.01745329252)));
      outer.add(Vector2((radius / 2 + (stroke / 2)) * cos(i * 0.01745329252),
          (radius / 2 + (stroke / 2)) * sin(i * 0.01745329252)));
    }
    outer = List.from(outer.reversed);
    return inner + outer;
  }
}
