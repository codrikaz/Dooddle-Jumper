// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ads/ad_service.dart';
import 'game/hoplet_bird.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hoplet Bird',
      themeMode: ThemeMode.dark,

      theme: ThemeData(
        colorScheme: lightColorScheme,
        fontFamily: 'gomarice_no_continue',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        fontFamily: 'gomarice_no_continue',
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hoplet Bird'),
    );
  }
}

final HopletBird game = HopletBird();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        if (game.gameManager.isPlaying && !game.overlays.isActive('backMenuOverlay')) {
          game.pauseGame();
          return;
        }

        if (game.overlays.isActive('backMenuOverlay')) {
          game.overlays.remove('backMenuOverlay');
          game.togglePauseState();
          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              constraints: const BoxConstraints(
                maxWidth: 800,
                minWidth: 550,
              ),
              child: GameWidget(
                game: game,
                overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
                  'gameOverlay': (context, game) => GameOverlay(game),
                  'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
                  'gameOverOverlay': (context, game) => GameOverOverlay(game),
                  'backMenuOverlay': (context, game) => BackMenuOverlay(game),
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
