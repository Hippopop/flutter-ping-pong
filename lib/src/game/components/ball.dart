import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_ping_pong/src/game/components/bat.dart';
import 'package:flame_ping_pong/src/game/game.dart';

class BallComponent extends CircleComponent
    with CollisionCallbacks, HasGameReference<PingPongGame> {
  BallComponent({
    super.radius,
    super.position,
  }) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() {
    add(CircleHitbox());
    return super.onLoad();
  }

  late Vector2 nextPosition;
  late double currentSpeed;
  static const double baseSpeed = 250;

  void initializeStartValues() {
    currentSpeed = baseSpeed;
    final random = math.Random();
    nextPosition = Vector2(
      random.nextDouble(),
      random.nextDouble(),
    );
  }

  void moveBall(double timeDifference) {
    final newPosition = position += Vector2(
      nextPosition.x * timeDifference * currentSpeed,
      nextPosition.y * timeDifference * currentSpeed,
    );

    final maxEdgeDistance = radius;
    final maxCrossX = game.size.x - radius;
    final maxCrossY = game.size.y - radius;
    position = Vector2(
      newPosition.x.clamp(maxEdgeDistance, maxCrossX),
      newPosition.y.clamp(maxEdgeDistance, maxCrossY),
    );

    if (position.x == maxEdgeDistance || position.x == maxCrossX) {
      // TODO: Here should be scoring placed!
      nextPosition = Vector2(-nextPosition.x, nextPosition.y);
    }
    if (position.y == maxEdgeDistance || position.y == maxCrossY) {
      nextPosition = Vector2(nextPosition.x, -nextPosition.y);
    }
  }

  _turnX() => nextPosition = Vector2(-nextPosition.x, nextPosition.y);
  _increaseSpeed() => currentSpeed = currentSpeed * 1.05;

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is BatComponent) {
      _turnX();
      _increaseSpeed();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
