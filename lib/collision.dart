import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

class CirclesExample extends FlameGame with HasCollisionDetection, TapDetector {
  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    add(MyCircle(Vector2(10, 10), 100, Paint()..color = Colors.blue));
  }

  @override
  void onTapDown(TapDownInfo info) {
    add(MyCollidable(info.eventPosition.game));
    add(MyCircle(info.eventPosition.game, 200, Paint()..color = Colors.red));
  }
}

class MyCircle extends PositionComponent
    with HasGameRef<CirclesExample>, CollisionCallbacks {
  late Vector2 velocity;
  final color = Colors.blue;

  MyCircle(Vector2 pos, double radius, Paint paint)
      : _radius = radius,
        _paint = paint,
        super(
          position: pos,
          size: Vector2.all(200),
          anchor: Anchor.center,
        );

  final double _radius;
  final Paint _paint;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(_radius, _radius), _radius, _paint);
  }
}

class MyCollidable extends PositionComponent
    with HasGameRef<CirclesExample>, CollisionCallbacks {
  late Vector2 velocity;
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  late ShapeHitbox hitbox;

  MyCollidable(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(100),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    final center = gameRef.size / 2;
    velocity = (center - position)..scaleTo(150);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(velocity * dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionColor;
    if (other is ScreenHitbox) {
      removeFromParent();
      return;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
    }
  }
}
