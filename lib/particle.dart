import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/game.dart';
// ignore: unused_import
import 'dart:developer' as log;

class Particle extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  Particle(pos) : super(position: pos);
  double vel = 0;
  double angleVel = 1;
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(const Offset(100, 0), 10,
        defaultPaint(theme.brown, PaintingStyle.fill));
  }

  @override
  void update(double dt) {
    if (vel == 0) angle += angleVel * -0.01745329252;
    position.x = position.x + vel;
    position.y = position.y + vel;
  }
}
