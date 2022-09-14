import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'dart:math';
// ignore: unused_import
import 'dart:developer' as log;
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';

class CirclesExample extends FlameGame with HasCollisionDetection, TapDetector {
  @override
  Future<void> onLoad() async {
    add(BackGround(Vector2(size.x / 2, size.y / 2)));
    add(ScreenHitbox());
    add(FullCircle(Vector2(size.x / 2, size.y / 2), 400, 6));
  }
}

class BackGround extends PositionComponent {
  BackGround(pos)
      : super(
          position: pos,
        );
  @override
  void render(Canvas canvas) {
    var paint = Paint()..color = theme.bg;
    super.render(canvas);
    canvas.drawRect(
        Rect.fromCenter(
            center: const Offset(0, 0),
            width: position.x * 2,
            height: position.y * 2),
        paint);
  }
}

class FullCircle extends PositionComponent
    with HasGameRef<CirclesExample>, CollisionCallbacks {
  final double radius;
  final double segments;
  late List<Color> colors;

  @override
  FullCircle(pos, this.radius, this.segments) : super(position: pos);

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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    removeAll(children);
    createCircle();
    //Rotation
    angle += 1.5 * 0.01745329252;
  }
}

class CirclePart extends PositionComponent
    with HasGameRef<CirclesExample>, CollisionCallbacks {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final Color color;
  final double stroke;
  late ShapeHitbox hitbox;
  final hitboxPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

  CirclePart(Vector2 pos, this.startAngle, this.sweepAngle, this.radius,
      this.color, this.stroke)
      : super(position: pos);

  @override
  Future<void> onLoad() async {
    hitbox = PolygonHitbox(makeHitbox())
      ..paint = hitboxPaint
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
