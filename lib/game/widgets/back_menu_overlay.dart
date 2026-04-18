// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ads/banner_ad_panel.dart';
import '../hoplet_bird.dart';
import '../managers/game_manager.dart';
import 'widgets.dart';

class BackMenuOverlay extends StatelessWidget {
  const BackMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final hopletBird = game as HopletBird;
    final character = hopletBird.gameManager.character;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Paused',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const WhiteSpace(height: 30),
                  Image.asset(
                    'assets/images/game/${character.name}_center.png',
                    height: 150,
                    width: 150,
                  ),
                  Text(
                    'Playing as ${character.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const WhiteSpace(height: 50),
                  ElevatedButton(
                    onPressed: () {
                              hopletBird.overlays.remove('backMenuOverlay');
                              hopletBird.togglePauseState();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(const Size(200, 75)),
                      textStyle: WidgetStateProperty.all(
                        Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    child: const Text('Resume'),
                  ),
                  const WhiteSpace(height: 20),
                  ElevatedButton(
                    onPressed: () {
                          hopletBird.togglePauseState();
                          hopletBird.overlays.remove('backMenuOverlay');
                          hopletBird.resetGame();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(const Size(200, 75)),
                      textStyle: WidgetStateProperty.all(
                        Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    child: const Text('Restart'),
                  ),
                  const WhiteSpace(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.redAccent,
                      ),
                      minimumSize: WidgetStateProperty.all(const Size(200, 75)),
                      textStyle: WidgetStateProperty.all(
                        Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    child: const Text('Exit Game'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: const BannerAdPanel()),
        ],
      ),
    );
  }
}
