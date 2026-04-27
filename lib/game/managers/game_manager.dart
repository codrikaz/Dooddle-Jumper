// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../hoplet_bird.dart';

// It won't be a detailed section of the codelab, as its not Flame specific
class GameManager extends Component with HasGameReference<HopletBird> {
  GameManager();

  static const List<int> _interstitialThresholds = [4, 3, 2];
  static const Duration _interstitialResetWindow = Duration(hours: 1, minutes: 30);

  Character character = Character.hoppy;
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;
  int _gameOversSinceInterstitial = 0;
  int _interstitialStage = 0;
  DateTime? _lastGameOverAt;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }

  void registerGameOver() {
    final now = DateTime.now();
    if (_lastGameOverAt != null &&
        now.difference(_lastGameOverAt!) >= _interstitialResetWindow) {
      _resetInterstitialCadence();
    }

    _lastGameOverAt = now;
    _gameOversSinceInterstitial++;
  }

  bool consumeInterstitialReplayEligibility() {
    final currentThreshold = _interstitialThresholds[_interstitialStage];
    if (_gameOversSinceInterstitial < currentThreshold) {
      return false;
    }

    _gameOversSinceInterstitial = 0;
    if (_interstitialStage < _interstitialThresholds.length - 1) {
      _interstitialStage++;
    }
    return true;
  }

  void _resetInterstitialCadence() {
    _gameOversSinceInterstitial = 0;
    _interstitialStage = 0;
  }

  void selectCharacter(Character selectedCharacter) {
    character = selectedCharacter;
  }
}

enum GameState { intro, playing, gameOver }
