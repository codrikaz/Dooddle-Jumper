// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './world.dart';
import 'managers/managers.dart';
import 'sprites/sprites.dart';

enum Character { dash, sparky }

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final World _world = World();
  LevelManager levelManager = LevelManager();
  GameManager gameManager = GameManager();
  int screenBufferSpace = 300;
  ObjectManager objectManager = ObjectManager();

  late Player player;

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;

    if (isKeyDown &&
        (keysPressed.contains(LogicalKeyboardKey.escape) ||
            keysPressed.contains(LogicalKeyboardKey.goBack))) {
      if (gameManager.isPlaying) {
        pauseGame();
        return KeyEventResult.handled;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void pauseGame() {
    if (!overlays.isActive('backMenuOverlay')) {
      togglePauseState();
      overlays.add('backMenuOverlay');
    }
  }

  @override
  Future<void> onLoad() async {
    await camera.backdrop.add(_world);

    await add(gameManager);

    overlays.add('gameOverlay');

    await add(levelManager);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isGameOver) {
      return;
    }

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isPlaying) {
      checkLevelUp();

      final visibleWorldRect = camera.visibleWorldRect;
      final halfwayPoint = visibleWorldRect.top + (visibleWorldRect.height * 0.4);
      final loseThreshold = visibleWorldRect.bottom + (player.size.y / 2);

      if (!player.isMovingDown && player.position.y <= halfwayPoint) {
        camera.follow(player);
      } else if (player.isMovingDown) {
        camera.stop();
      }

      if (player.position.y > loseThreshold) {
        onLose();
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  Future<void> initializeGameStart() async {
    gameManager.reset();

    for (final existingPlayer in world.children.whereType<Player>().toList()) {
      existingPlayer.removeFromParent();
    }

    if (objectManager.parent != null) {
      objectManager.removeFromParent();
    }

    levelManager.reset();

    await setCharacter();
    player.reset();

    objectManager = ObjectManager(
        minVerticalDistanceToNextPlatform: levelManager.minDistance,
        maxVerticalDistanceToNextPlatform: levelManager.maxDistance);

    await world.add(objectManager);

    objectManager.configure(levelManager.level, levelManager.difficulty);

    player.resetPosition();

    final startingPlatform = objectManager.startingPlatform;
    if (startingPlatform != null) {
      player.position = Vector2(
        startingPlatform.center.x,
        startingPlatform.position.y - (player.size.y / 2),
      );
    }

    camera.viewfinder.position = player.position.clone();
    camera.stop();
    player.jump();
  }

  Future<void> setCharacter() async {
    player = Player(
      character: gameManager.character,
      jumpSpeed: levelManager.startingJumpSpeed,
    );
    await world.add(player);
  }

  Future<void> startGame() async {
    await initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  Future<void> resetGame() async {
    await startGame();
    overlays.remove('gameOverOverlay');
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    camera.stop();
    player.removeFromParent();
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void checkLevelUp() {
    if (levelManager.shouldLevelUp(gameManager.score.value)) {
      levelManager.increaseLevel();

      objectManager.configure(levelManager.level, levelManager.difficulty);

      player.setJumpSpeed(levelManager.jumpSpeed);
    }
  }
}
