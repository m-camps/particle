import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:particle/components/particle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/globals.dart';
import 'package:particle/game.dart';

class Debug extends TextComponent with HasGameRef<MainGame> {
  final Particle particle;
  String str = "";
  Debug(this.particle);

  @override
  Future<void> onLoad() async {
    add(global.fps);
    textRenderer =
        TextPaint(style: TextStyle(color: theme.otherBg, fontSize: 10));
  }

  @override
  void update(double dt) {
    str = "Particle\n"
        "FPS: ${global.fps.fps.floor()}\n"
        "Direction: ${particle.direction}\n"
        "SpeedMult: ${particle.speedMultiplier}\n"
        "Velocity: ${particle.vel}\n\n"
        "Circle\n"
        "TBA\n";
    text = str;
  }
}
