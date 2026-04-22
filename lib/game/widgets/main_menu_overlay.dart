// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../ads/banner_ad_panel.dart';
import '../hoplet_bird.dart';

// Overlay that appears for the main menu
class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.hoppy;

  @override
  Widget build(BuildContext context) {
    HopletBird game = widget.game as HopletBird;

    return LayoutBuilder(builder: (context, constraints) {
      final characterWidth = constraints.maxWidth / 5;

      final TextStyle titleStyle = (constraints.maxWidth > 830)
          ? Theme.of(context).textTheme.displayLarge!
          : Theme.of(context).textTheme.displaySmall!;

      // 760 is the smallest height the browser can have until the
      // layout is too large to fit.
      final bool screenHeightIsSmall = constraints.maxHeight < 760;

      return Material(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: const BannerAdPanel()),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 70),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/game/hoplet_bird.png',
                        height: characterWidth * 1.90,
                        fit: BoxFit.contain,
                      ),
                      const WhiteSpace(height: 0),
                      Text(
                        'Hoplet Bird',
                        style: titleStyle.copyWith(
                          height: .8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const WhiteSpace(height: 70,),
                      Align(
                        alignment: Alignment.center,
                        child: Text('Select your character:',
                            style: Theme.of(context).textTheme.headlineSmall!
                        ),
                      ),
                      if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CharacterButton(
                            character: Character.hoppy,
                            selected: character == Character.hoppy,
                            onSelectChar: () {
                              setState(() {
                                character = Character.hoppy;
                              });
                            },
                            characterWidth: characterWidth,
                          ),
                          CharacterButton(
                            character: Character.peppy,
                            selected: character == Character.peppy,
                            onSelectChar: () {
                              setState(() {
                                character = Character.peppy;
                              });
                            },
                            characterWidth: characterWidth,
                          ),
                        ],
                      ),
                      if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Difficulty:',
                              style: Theme.of(context).textTheme.bodyLarge!),
                          LevelPicker(
                            level: game.levelManager.selectedLevel.toDouble(),
                            label: game.levelManager.selectedLevel.toString(),
                            onChanged: ((value) {
                              setState(() {
                                game.levelManager.selectLevel(value.toInt());
                              });
                            }),
                          ),
                        ],
                      ),
                      if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            game.gameManager.selectCharacter(character);
                            game.startGame();
                          },
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(
                              const Size(100, 50),
                            ),
                            textStyle: WidgetStateProperty.all(
                                Theme.of(context).textTheme.titleLarge),
                          ),
                          child: const Text('Start'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class LevelPicker extends StatelessWidget {
  const LevelPicker({
    super.key,
    required this.level,
    required this.label,
    required this.onChanged,
  });

  final double level;
  final String label;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Slider(
      value: level,
      max: 5,
      min: 1,
      divisions: 4,
      label: label,
      onChanged: onChanged,
    ));
  }
}

class CharacterButton extends StatelessWidget {
  const CharacterButton(
      {super.key,
      required this.character,
      this.selected = false,
      required this.onSelectChar,
      required this.characterWidth});

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: (selected)
          ? ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(31, 64, 195, 255)))
          : null,
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/game/${character.name}_center.png',
              height: characterWidth,
              width: characterWidth,
            ),
            const WhiteSpace(height: 12),
            Text(
              character.displayName,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
