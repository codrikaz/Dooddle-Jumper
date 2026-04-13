// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../ads/interstitial_ad_flow.dart';
import '../doodle_dash.dart';
import 'widgets.dart';

// Overlay that pops up when the game ends
class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  bool _isShowingAd = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const WhiteSpace(height: 50),
              ScoreDisplay(
                game: widget.game,
                isLight: true,
              ),
              const WhiteSpace(height: 50),
              ElevatedButton(
                onPressed: _isShowingAd
                    ? null
                    : () async {
                        setState(() {
                          _isShowingAd = true;
                        });

                        await InterstitialAdFlow.showThen(() async {
                          await (widget.game as DoodleDash).resetGame();
                        });

                        if (mounted) {
                          setState(() {
                            _isShowingAd = false;
                          });
                        }
                      },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    const Size(200, 75),
                  ),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: Text(_isShowingAd ? 'Loading Ad...' : 'Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
