import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'dart:math';
import 'dart:developer' as developer;

class CirclesExample extends FlameGame with HasCollisionDetection, TapDetector {
  @override
  Color backgroundColor() => Color.fromARGB(255, 64, 63, 72);

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    add(MyCircle(Vector2(size.x / 2, size.y / 2)));
  }
}

class MyCircle extends PositionComponent
    with HasGameRef<CirclesExample>, CollisionCallbacks {
  @override
  MyCircle(pos) : super(position: pos);
  Future<void> onLoad() async {
    add(CircleArc(Vector2(size.x / 2, size.y / 2), 90, 90, 200, Colors.red));
    add(CircleArc(Vector2(size.x / 2, size.y / 2), 180, 90, 200, Colors.green));
    add(CircleArc(Vector2(size.x / 2, size.y / 2), 270, 90, 200, Colors.blue));
    add(CircleArc(Vector2(size.x / 2, size.y / 2), 0, 90, 200, Colors.yellow));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    angle += 2 * 0.01745329252;
  }
}

class CircleArc extends PositionComponent
    with HasGameRef<CirclesExample>, CollisionCallbacks {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final Color color;
  late ShapeHitbox hitbox;

  CircleArc(
      Vector2 pos, this.startAngle, this.sweepAngle, this.radius, this.color)
      : super(position: pos);

  @override
  Future<void> onLoad() async {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;
    hitbox = PolygonHitbox(calcVertices())
      ..paint = paint
      ..renderShape = false;
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
        ..strokeWidth = 20,
    );
  }

  List<Vector2> calcVertices() {
    List<Vector2> inner = [];
    List<Vector2> outer = [];

    for (double i = startAngle; i <= sweepAngle + startAngle; i += 10) {
      inner.add(Vector2((radius / 2 - 10) * cos(i * 0.01745329252),
          (radius / 2 - 10) * sin(i * 0.01745329252)));
    }
    for (double i = startAngle; i <= sweepAngle + startAngle; i += 10) {
      outer.add(Vector2((radius / 2 + 10) * cos(i * 0.01745329252),
          (radius / 2 + 10) * sin(i * 0.01745329252)));
    }
    outer = List.from(outer.reversed);
    return inner + outer;
  }
}
