import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_ping_pong/src/game/components/ball.dart';
import 'package:flame_ping_pong/src/game/components/bat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: PingPongGame(),
    );
  }
}

class PingPongGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  late final BallComponent ball;
  late final BatComponent leftBat;
  late final BatComponent rightBat;

  @override
  FutureOr<void> onLoad() async {
    /* Static Constants */
    const spaceFromBorder = 10;
    /* Static Constants */

    const batWidth = 25.0;
    final batHeight = size.y * 0.3;
    final batSize = Vector2(batWidth, batHeight);
    leftBat = BatComponent(
      size: batSize,
      position: Vector2(
        ((batWidth / 2) + spaceFromBorder),
        size.y * 0.5,
      ),
    );
    add(leftBat);
    rightBat = BatComponent(
      size: batSize,
      position: Vector2(
        (size.x - (batWidth / 2 + spaceFromBorder)),
        size.y * 0.5,
      ),
    );
    add(rightBat);
    ball = BallComponent(
      radius: 15,
      position: Vector2(size.x / 2, size.y / 2),
    );
    ball.initializeStartValues();
    add(ball);
    return super.onLoad();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    final wActive = event.logicalKey == LogicalKeyboardKey.keyW;
    final sActive = event.logicalKey == LogicalKeyboardKey.keyS;
    final upActive = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final downActive = event.logicalKey == LogicalKeyboardKey.arrowDown;
    if (wActive) {
      leftBat.updateCurrentMovement(
        isKeyDown ? BatMovement.up : BatMovement.none,
      );
      return KeyEventResult.handled;
    }
    if (sActive) {
      leftBat.updateCurrentMovement(
        isKeyDown ? BatMovement.down : BatMovement.none,
      );
      return KeyEventResult.handled;
    }
    if (upActive) {
      rightBat.updateCurrentMovement(
        isKeyDown ? BatMovement.up : BatMovement.none,
      );
      return KeyEventResult.handled;
    }
    if (downActive) {
      rightBat.updateCurrentMovement(
        isKeyDown ? BatMovement.down : BatMovement.none,
      );
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void update(double dt) {
    if (leftBat.currentMovement != BatMovement.none) {
      leftBat.updatePosition(dt);
    }
    if (rightBat.currentMovement != BatMovement.none) {
      rightBat.updatePosition(dt);
    }
    ball.moveBall(dt);
    super.update(dt);
  }
}
