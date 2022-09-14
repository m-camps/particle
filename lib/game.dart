import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:particle/circle.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/particle.dart';
import 'dart:developer' as log;

class MainGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Particle particle;
  @override
  Future<void> onLoad() async {
    final center = Vector2(size.x / 2, size.y / 2);
    particle = Particle(center);
    add(BackGround(Vector2(size.x / 2, size.y / 2)));
    add(ScreenHitbox());
    add(FullCircle(Vector2(size.x / 2, size.y / 2), 400, 3));
    add(particle);
  }

  @override
  void onTap() {
    super.onTap();
    particle.vel = particle.angleVel;
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
