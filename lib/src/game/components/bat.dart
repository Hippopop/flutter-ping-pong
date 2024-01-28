import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BatMovement {
  up,
  down,
  none,
}

class BatComponent extends RectangleComponent with CollisionCallbacks {
  BatComponent({
    super.size,
    super.position,
  }) : super(
          anchor: Anchor.center,
          /* paint: Paint()
            ..strokeCap = StrokeCap.round
            ..color = Colors.green
            ..strokeJoin = StrokeJoin.round
            ..darken(0.5), 
          */
        );

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  static const double batMovementAccelerator = 150;
  double currentAcceleration = 150;
  BatMovement currentMovement = BatMovement.none;

  void updateCurrentMovement(BatMovement newMovement) {
    if (newMovement == BatMovement.none) {
      currentAcceleration = BatComponent.batMovementAccelerator;
    }
    currentMovement = newMovement;
  }

  void updatePosition(double timeDifference) {
    final directionDecider = (currentMovement == BatMovement.up ? (-1) : (1));
    final speed = timeDifference * currentAcceleration;

    final movement = speed * directionDecider;
    position = Vector2(position.x, position.y + movement);
    currentAcceleration += (timeDifference * 1000);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  }
}
