import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../ads/game_over_native_ad_panel.dart';
import '../../ads/interstitial_ad_flow.dart';
import '../../audio/game_audio_controller.dart';
import '../hoplet_bird.dart';

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
    final hopletBird = widget.game as HopletBird;
    final character = hopletBird.gameManager.character;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A000F),
                  Color(0xFF180020),
                  Color(0xFF08000F),
                ],
              ),
            ),
          ),
          const _StarField(),
          Positioned.fill(
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF3D57).withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GameOverNativeAdPanel(),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactWidth = constraints.maxWidth < 380;
                final compactHeight = constraints.maxHeight < 700;
                final sidePadding = compactWidth ? 20.0 : 40.0;
                final avatarSize = compactHeight ? 72.0 : 90.0;
                final titleSize = compactWidth ? 34.0 : 48.0;
                final scoreSize = compactWidth ? 48.0 : 64.0;
                final buttonHeight = compactHeight ? 58.0 : 64.0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 80, bottom: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sidePadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF3D57).withValues(alpha: 0.10),
                              border: Border.all(
                                color: const Color(0xFFFF3D57).withValues(alpha: 0.45),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF3D57).withValues(alpha: 0.20),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(compactHeight ? 10 : 12),
                              child: Image.asset(
                                'assets/images/game/${character.name}_center.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: compactHeight ? 14 : 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'GAME OVER',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFFF3D57),
                                fontSize: titleSize,
                                fontWeight: FontWeight.w900,
                                letterSpacing: compactWidth ? 3 : 5,
                                shadows: const [
                                  Shadow(color: Color(0xFFFF3D57), blurRadius: 20),
                                  Shadow(color: Color(0xFFFF3D57), blurRadius: 44),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 2,
                            width: compactWidth ? 140 : 180,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFFFF3D57),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: compactHeight ? 20 : 28),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: compactWidth ? 18 : 32,
                              vertical: compactWidth ? 16 : 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFFFFB300).withValues(alpha: 0.50),
                                width: 1.5,
                              ),
                              color: const Color(0xFFFFB300).withValues(alpha: 0.06),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFB300).withValues(alpha: 0.10),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    Icon(
                                      Icons.emoji_events_rounded,
                                      color: const Color(0xFFFFB300).withValues(alpha: 0.80),
                                      size: 18,
                                    ),
                                    Text(
                                      'YOUR SCORE',
                                      style: TextStyle(
                                        color: const Color(0xFFFFB300)
                                            .withValues(alpha: 0.75),
                                        fontSize: compactWidth ? 11 : 13,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: compactWidth ? 2 : 4,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ValueListenableBuilder<int>(
                                  valueListenable: hopletBird.gameManager.score,
                                  builder: (context, value, _) => FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '$value',
                                      style: TextStyle(
                                        color: const Color(0xFFFFD54F),
                                        fontSize: scoreSize,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                        height: 1.0,
                                        shadows: const [
                                          Shadow(
                                            color: Color(0xFFFFB300),
                                            blurRadius: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: compactHeight ? 20 : 28),
                          GestureDetector(
                            onTap: _isShowingAd
                                ? null
                                : () async {
                                    await GameAudioController.playButtonTap();
                                    final shouldShowInterstitial = hopletBird
                                        .gameManager
                                        .consumeInterstitialReplayEligibility();

                                    if (!shouldShowInterstitial) {
                                      await hopletBird.resetGame();
                                      return;
                                    }

                                    setState(() => _isShowingAd = true);

                                    await InterstitialAdFlow.showThen(() async {
                                      await hopletBird.resetGame();
                                    });

                                    if (mounted) {
                                      setState(() => _isShowingAd = false);
                                    }
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: _isShowingAd
                                    ? const LinearGradient(
                                        colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
                                      )
                                    : const LinearGradient(
                                        colors: [Color(0xFF00897B), Color(0xFF1DE9B6)],
                                      ),
                                boxShadow: _isShowingAd
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: const Color(0xFF1DE9B6)
                                              .withValues(alpha: 0.45),
                                          blurRadius: 26,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isShowingAd
                                        ? Icons.hourglass_top_rounded
                                        : Icons.play_arrow_rounded,
                                    color: _isShowingAd
                                        ? Colors.white.withValues(alpha: 0.40)
                                        : Colors.white,
                                    size: compactWidth ? 26 : 30,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _isShowingAd ? 'LOADING...' : 'PLAY AGAIN',
                                        style: TextStyle(
                                          color: _isShowingAd
                                              ? Colors.white.withValues(alpha: 0.40)
                                              : Colors.white,
                                          fontSize: compactWidth ? 18 : 22,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: compactWidth ? 2 : 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: CustomPaint(painter: _StarPainter()));
  }
}

class _StarPainter extends CustomPainter {
  static const _stars = [
    (0.08, 0.07, 1.8),
    (0.91, 0.04, 1.4),
    (0.47, 0.10, 2.2),
    (0.73, 0.17, 1.2),
    (0.22, 0.26, 1.8),
    (0.95, 0.38, 1.0),
    (0.04, 0.52, 1.6),
    (0.58, 0.60, 1.4),
    (0.84, 0.68, 2.0),
    (0.33, 0.76, 1.0),
    (0.67, 0.85, 1.8),
    (0.14, 0.91, 1.4),
    (0.51, 0.42, 1.2),
    (0.78, 0.30, 1.6),
    (0.39, 0.55, 1.0),
    (0.18, 0.73, 2.0),
    (0.62, 0.20, 1.4),
    (0.86, 0.88, 1.2),
    (0.25, 0.60, 1.0),
    (0.70, 0.48, 1.4),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.50);
    for (final (x, y, r) in _stars) {
      canvas.drawCircle(Offset(size.width * x, size.height * y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
