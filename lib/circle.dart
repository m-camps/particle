import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:particle/config/config.dart';
import 'package:particle/config/globals.dart';
import 'package:particle/game.dart';

// ignore: unused_import
import 'dart:developer' as log;

import 'package:particle/util.dart';

class FullCircle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  final double radius;
  final List<dynamic> colors;
  double fps = 0;
  double totalFps = 0;

  @override
  FullCircle(this.radius, this.colors);

  @override
  Future<void> onLoad() async {
    createCircle();
  }

  FullCircle.fromJson(Map<String, dynamic> json)
      : radius = json['radius'],
        colors = json['colors'];

  Map<String, dynamic> toJson() => {
        'radius': radius,
        'colors': colors,
      };

  @override
  void update(dt) {
    final angleMod = calcFpsModifier(global.fps.fpsComponent.fps) * 1.5;
    // log.log(angleMod.toString());
    angle += angleMod * 0.01745329252;
  }

  createCircle() {
    final segments = colors.length;
    final step = 360 / segments;
    final Vector2 centerPos = Vector2(size.x / 2, size.y / 2);
    var colorIndex = 0;

    // for (double i = 0; i < 360; i += step) {
    //   add(CirclePart(centerPos, i, step, radius,
    //       Color(int.parse(colors.elementAt(colorIndex))), 40));
    //   colorIndex++;
    // }
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
    double res = 0;

    if (sweepAngle > 36) {
      res = sweepAngle / config.resTable[sweepAngle.round()]!;
    } else {
      res = sweepAngle / 2;
    }
    for (double i = startAngle; i <= sweepAngle + 1 + startAngle; i += res) {
      inner.add(Vector2((radius / 2 - (stroke / 2)) * cos(i * 0.01745329252),
          (radius / 2 - (stroke / 2)) * sin(i * 0.01745329252)));
      outer.add(Vector2((radius / 2 + (stroke / 2)) * cos(i * 0.01745329252),
          (radius / 2 + (stroke / 2)) * sin(i * 0.01745329252)));
    }
    outer = List.from(outer.reversed);
    return inner + outer;
  }
}
