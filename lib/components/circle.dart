import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/config.dart';
import 'package:particle/config/constants.dart';
import 'package:particle/game.dart';
// ignore: unused_import
import 'dart:developer' as log;

class FullCircle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  late double vel = 0;
  // Game Variables
  double circleRadius = 400;
  double speedStart = 100;
  double speedMult = 10;
  double strokeWidth = 10;
  double direction = 1;
  List<Color> colors = [theme.blue, theme.red];

  FullCircle();

  @override
  Future<void> onLoad() async {
    createCircle();
  }

  FullCircle.fromJson(Map<String, dynamic> json)
      : circleRadius = json['circleRadius'],
        strokeWidth = json['strokeWidth'],
        direction = json['direction'],
        speedStart = json['speedStart'],
        speedMult = json['speedMultiplier'],
        colors = theme.parseColors(json['colors']);

  @override
  void update(dt) {
    final step = speedStart * dt;
    angle += step * degToRad * direction;
  }

  createCircle() {
    final segments = colors.length;
    final step = 360 / segments;
    final Vector2 centerPos = Vector2(size.x / 2, size.y / 2);
    int colorIndex = 0;

    for (double i = 0; i < 360; i += step, colorIndex++) {
      add(CirclePart(centerPos, i, step, circleRadius,
          colors.elementAt(colorIndex), strokeWidth));
    }
  }
}

class CirclePart extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final Color color;
  final double strokeWidth;
  late ShapeHitbox hitbox;

  CirclePart(
    Vector2 pos,
    this.startAngle,
    this.sweepAngle,
    this.radius,
    this.color,
    this.strokeWidth,
  ) : super(position: pos);

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
      startAngle * degToRad,
      sweepAngle * degToRad,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  List<Vector2> makeHitbox() {
    List<Vector2> inner = [];
    List<Vector2> outer = [];
    double res = 0;

    if (sweepAngle > 60) {
      res = sweepAngle / resTable[sweepAngle.round()]!;
    } else {
      res = sweepAngle / 2;
    }
    for (double i = startAngle; i <= sweepAngle + 1 + startAngle; i += res) {
      inner.add(Vector2((radius / 2 - (strokeWidth / 2)) * cos(i * degToRad),
          (radius / 2 - (strokeWidth / 2)) * sin(i * degToRad)));
      outer.add(Vector2((radius / 2 + (strokeWidth / 2)) * cos(i * degToRad),
          (radius / 2 + (strokeWidth / 2)) * sin(i * degToRad)));
    }
    outer = List.from(outer.reversed);
    return inner + outer;
  }
}
