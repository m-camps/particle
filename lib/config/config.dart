import 'package:flutter/material.dart';

final config = Config();

class Config {
  final bool showHitbox = true;
  final double hitboxRes = 4;
  final Paint hitboxPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;
  final double score = 0;
  var resTable = <double, double>{
    180: 12,
    120: 10,
    90: 8,
    72: 6,
    60: 5,
    51: 4,
    45: 4,
    40: 4,
    36: 2,
  };
}
