import 'package:flutter/material.dart';

final config = Config();

class Config {
  final bool showHitbox = false;
  final double hitboxRes = 10;
  final Paint hitboxPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;
  final double score = 0;
}
