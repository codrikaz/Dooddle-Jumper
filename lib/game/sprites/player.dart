// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../doodle_dash.dart';
import 'sprites.dart';

enum PlayerState {
  left,
  right,
  center,
  rocket,
  nooglerCenter,
  nooglerLeft,
  nooglerRight
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameReference<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Player({
    super.position,
    required this.character,
    this.jumpSpeed = 600,
  }) : super(
          size: Vector2(79, 109),
          anchor: Anchor.center,
          priority: 1,
        );

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 _velocity = Vector2.zero();
  int _powerUpToken = 0;
  bool get isMovingDown => _velocity.y > 0;
  Character character;
  double jumpSpeed;
  final double _gravity = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (game.gameManager.isIntro || game.gameManager.isGameOver) return;

    _velocity.x = _hAxisInput * jumpSpeed;

    final double dashHorizontalCenter = size.x / 2;

    // Removed wrap-around logic to prevent infinite game. 
    // Character will now fall if moving off-screen horizontally.

    _velocity.y += _gravity;

    position += _velocity * dt;

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    // During development, its useful to "cheat"
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      // jump();
    }

    return true;
  }

  void moveLeft() {
    _hAxisInput = 0;

    if (isWearingHat) {
      current = PlayerState.nooglerLeft;
    } else if (!hasPowerup) {
      current = PlayerState.left;
    }

    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0; // by default not going left or right

    if (isWearingHat) {
      current = PlayerState.nooglerRight;
    } else if (!hasPowerup) {
      current = PlayerState.right;
    }
    _hAxisInput += movingRightInput;
  }

  void resetDirection() {
    _hAxisInput = 0;
  }

  bool get hasPowerup =>
      current == PlayerState.rocket ||
      current == PlayerState.nooglerLeft ||
      current == PlayerState.nooglerRight ||
      current == PlayerState.nooglerCenter;

  bool get isInvincible => current == PlayerState.rocket;

  bool get isWearingHat =>
      current == PlayerState.nooglerLeft ||
      current == PlayerState.nooglerRight ||
      current == PlayerState.nooglerCenter;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyPlatform && !isInvincible) {
      game.onLose();
      return;
    }

    bool isCollidingVertically =
        (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;

    if (isMovingDown && isCollidingVertically) {
      current = isWearingHat ? PlayerState.nooglerCenter : PlayerState.center;
      if (other is NormalPlatform) {
        jump();
        return;
      } else if (other is SpringBoard) {
        jump(specialJumpSpeed: jumpSpeed * 2);
        return;
      } else if (other is BrokenPlatform &&
          other.current == BrokenPlatformState.cracked) {
        other.breakPlatform();
        return;
      }
    }

    if (!hasPowerup && other is Rocket) {
      current = PlayerState.rocket;
      other.removeFromParent();
      jump(specialJumpSpeed: jumpSpeed * other.jumpSpeedMultiplier);
      return;
    } else if (!hasPowerup && other is NooglerHat) {
      if (current == PlayerState.center) current = PlayerState.nooglerCenter;
      if (current == PlayerState.left) current = PlayerState.nooglerLeft;
      if (current == PlayerState.right) current = PlayerState.nooglerRight;
      other.removeFromParent();
      _removePowerupAfterTime(other.activeLengthInMS);
      jump(specialJumpSpeed: jumpSpeed * other.jumpSpeedMultiplier);
      return;
    }
  }

  void jump({double? specialJumpSpeed}) {
    _velocity.y = specialJumpSpeed != null ? -specialJumpSpeed : -jumpSpeed;
  }

  void _removePowerupAfterTime(int ms) {
    final token = ++_powerUpToken;
    Future.delayed(Duration(milliseconds: ms), () {
      if (!isMounted || token != _powerUpToken) {
        return;
      }
      current = PlayerState.center;
    });
  }

  void setJumpSpeed(double newJumpSpeed) {
    jumpSpeed = newJumpSpeed;
  }

  void reset() {
    _powerUpToken++;
    resetDirection();
    _velocity = Vector2.zero();
    if (sprites != null) {
      current = PlayerState.center;
    }
  }

  void resetPosition() {
    position = Vector2(
      game.size.x / 2,
      game.size.y * 0.75,
    );
  }

  Future<void> _loadCharacterSprites() async {
    // Load & configure sprite assets
    final left = await game.loadSprite('game/${character.name}_left.png');
    final right = await game.loadSprite('game/${character.name}_right.png');
    final center =
        await game.loadSprite('game/${character.name}_center.png');
    final rocket = await game.loadSprite('game/rocket_4.png');
    final nooglerCenter =
        await game.loadSprite('game/${character.name}_hat_center.png');
    final nooglerLeft =
        await game.loadSprite('game/${character.name}_hat_left.png');
    final nooglerRight =
        await game.loadSprite('game/${character.name}_hat_right.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
      PlayerState.rocket: rocket,
      PlayerState.nooglerCenter: nooglerCenter,
      PlayerState.nooglerLeft: nooglerLeft,
      PlayerState.nooglerRight: nooglerRight,
    };
  }
}
