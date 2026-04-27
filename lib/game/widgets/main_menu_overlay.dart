import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../ads/banner_ad_panel.dart';
import '../../audio/game_audio_controller.dart';
import '../../platform/rate_app_service.dart';
import '../hoplet_bird.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  int _charIndex = 0;

  Character get _character => Character.values[_charIndex];

  void _prevChar() => setState(() {
        _charIndex =
            (_charIndex - 1 + Character.values.length) % Character.values.length;
      });

  void _nextChar() => setState(() {
        _charIndex = (_charIndex + 1) % Character.values.length;
      });

  @override
  Widget build(BuildContext context) {
    final game = widget.game as HopletBird;
    final accent =
        _charIndex == 0 ? const Color(0xFF4FC3F7) : const Color(0xFFFFB300);

    return Material(
      color: const Color(0xFF08091A),
      child: Stack(
        children: [
          const _Backdrop(),
          Column(
            children: [
              const BannerAdPanel(),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compactWidth = constraints.maxWidth < 380;
                      final compactHeight = constraints.maxHeight < 700;
                      final horizontalPadding = compactWidth ? 16.0 : 28.0;
                      final titleSize = compactWidth ? 28.0 : 36.0;
                      final playHeight = compactHeight ? 58.0 : 66.0;
                      final imageSize = compactHeight ? 150.0 : 180.0;

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 10),
                                Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _AudioToggle(
                                          notifier: GameAudioController.soundEnabled,
                                          iconOn: Icons.volume_up_rounded,
                                          iconOff: Icons.volume_off_rounded,
                                          label: 'SOUND',
                                          compact: compactWidth,
                                          onTap: () async {
                                            await GameAudioController.playButtonTap();
                                            GameAudioController.toggleSound();
                                          },
                                        ),
                                        SizedBox(width: compactWidth ? 6 : 10),
                                        _AudioToggle(
                                          notifier: GameAudioController.musicEnabled,
                                          iconOn: Icons.music_note_rounded,
                                          iconOff: Icons.music_off_rounded,
                                          label: 'MUSIC',
                                          compact: compactWidth,
                                          onTap: () async {
                                            await GameAudioController.playButtonTap();
                                            await GameAudioController.toggleMusic();
                                          },
                                        ),
                                        SizedBox(width: compactWidth ? 6 : 10),
                                        _AudioToggle(
                                          notifier: GameAudioController.hapticEnabled,
                                          iconOn: Icons.vibration_rounded,
                                          iconOff: Icons.phonelink_erase_rounded,
                                          label: 'HAPTIC',
                                          compact: compactWidth,
                                          onTap: () async {
                                            await GameAudioController.playButtonTap();
                                            GameAudioController.toggleHaptic();
                                          },
                                        ),
                                        SizedBox(width: compactWidth ? 6 : 10),
                                        _CircleIconBtn(
                                          icon: Icons.star_rate_rounded,
                                          color: const Color(0xFFFFB300),
                                          compact: compactWidth,
                                          onTap: () async {
                                            await GameAudioController.playButtonTap();
                                            await RateAppService.openStoreListing();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: compactHeight ? 10 : 14),
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accent.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(999),
                                          border: Border.all(
                                            color: accent.withValues(alpha: 0.30),
                                          ),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'SKY HOP ADVENTURE',
                                            style: TextStyle(
                                              color: accent,
                                              fontSize: compactWidth ? 10 : 11,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: compactWidth ? 1.2 : 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'HOPLET BIRD',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: titleSize,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: compactWidth ? 2 : 4,
                                            shadows: [
                                              Shadow(color: accent, blurRadius: 20),
                                              Shadow(color: accent, blurRadius: 40),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: compactHeight ? 6 : 10),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            _NavArrow(
                                              icon: Icons.chevron_left_rounded,
                                              onTap: _prevChar,
                                            ),
                                            Expanded(
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 240),
                                                transitionBuilder: (child, anim) =>
                                                    FadeTransition(
                                                  opacity: anim,
                                                  child: ScaleTransition(
                                                    scale: Tween(begin: 0.85, end: 1.0)
                                                        .animate(anim),
                                                    child: child,
                                                  ),
                                                ),
                                                child: _CharacterDisplay(
                                                  key: ValueKey(_charIndex),
                                                  character: _character,
                                                  accent: accent,
                                                  size: imageSize,
                                                ),
                                              ),
                                            ),
                                            _NavArrow(
                                              icon: Icons.chevron_right_rounded,
                                              onTap: _nextChar,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          _character.displayName.toUpperCase(),
                                          style: TextStyle(
                                            color: accent,
                                            fontSize: compactWidth ? 18 : 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: compactWidth ? 2 : 4,
                                            shadows: [
                                              Shadow(color: accent, blurRadius: 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 4,
                                        children: Character.values.asMap().entries.map((e) {
                                          final isActive = e.key == _charIndex;
                                          return AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            margin: const EdgeInsets.symmetric(horizontal: 2),
                                            width: isActive ? 22 : 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: isActive
                                                  ? accent
                                                  : Colors.white.withValues(alpha: 0.25),
                                              boxShadow: isActive
                                                  ? [
                                                      BoxShadow(
                                                        color: accent.withValues(alpha: 0.50),
                                                        blurRadius: 8,
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: compactHeight ? 10 : 14),
                                _DifficultyRow(
                                  game: game,
                                  onChanged: () => setState(() {}),
                                ),
                                SizedBox(height: compactHeight ? 10 : 14),
                                GestureDetector(
                                  onTap: () async {
                                    await GameAudioController.playButtonTap();
                                    game.gameManager.selectCharacter(_character);
                                    await game.startGame();
                                  },
                                  child: Container(
                                    height: playHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF00897B), Color(0xFF1DE9B6)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF1DE9B6)
                                              .withValues(alpha: 0.50),
                                          blurRadius: 26,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: compactWidth ? 28 : 32,
                                        ),
                                        const SizedBox(width: 8),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'PLAY',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: compactWidth ? 22 : 26,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: compactWidth ? 3 : 5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CharacterDisplay extends StatelessWidget {
  const _CharacterDisplay({
    super.key,
    required this.character,
    required this.accent,
    required this.size,
  });

  final Character character;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                accent.withValues(alpha: 0.22),
                accent.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: EdgeInsets.all(size * 0.12),
            child: Image.asset(
              'assets/images/game/${character.name}_center.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GameAudioController.playButtonTap();
        onTap();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.70),
          size: 28,
        ),
      ),
    );
  }
}

class _AudioToggle extends StatelessWidget {
  const _AudioToggle({
    required this.notifier,
    required this.iconOn,
    required this.iconOff,
    required this.label,
    required this.compact,
    required this.onTap,
  });

  final ValueNotifier<bool> notifier;
  final IconData iconOn;
  final IconData iconOff;
  final String label;
  final bool compact;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, isOn, __) {
        const activeColor = Color(0xFF4FC3F7);
        final inactiveColor = Colors.white.withValues(alpha: 0.28);
        final color = isOn ? activeColor : inactiveColor;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: BoxConstraints(minWidth: compact ? 72 : 88),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 8 : 12,
              vertical: compact ? 7 : 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: isOn
                  ? activeColor.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: isOn
                    ? activeColor.withValues(alpha: 0.65)
                    : Colors.white.withValues(alpha: 0.14),
                width: 1.5,
              ),
              boxShadow: isOn
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.28),
                        blurRadius: 14,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isOn ? iconOn : iconOff, color: color, size: compact ? 15 : 17),
                SizedBox(width: compact ? 4 : 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: compact ? 8 : 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: compact ? 0.6 : 1,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: compact ? 1 : 2),
                    Text(
                      isOn ? 'ON' : 'OFF',
                      style: TextStyle(
                        color: color,
                        fontSize: compact ? 10 : 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: compact ? 0.6 : 1,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({
    required this.icon,
    required this.color,
    required this.compact,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool compact;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: compact ? 40 : 46,
        height: compact ? 40 : 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.12),
          border: Border.all(
            color: color.withValues(alpha: 0.55),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: compact ? 18 : 22),
      ),
    );
  }
}

class _DifficultyRow extends StatelessWidget {
  const _DifficultyRow({required this.game, required this.onChanged});

  final HopletBird game;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final current = game.levelManager.selectedLevel;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        Text(
          'LEVEL',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.40),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        ...List.generate(5, (i) {
          final level = i + 1;
          final selected = current == level;
          final color = _levelColor(level);
          return GestureDetector(
            onTap: () {
              GameAudioController.playButtonTap();
              game.levelManager.selectLevel(level);
              onChanged();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? color.withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.06),
                border: Border.all(
                  color: selected ? color : Colors.white.withValues(alpha: 0.14),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.50),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: TextStyle(
                    color: selected
                        ? color
                        : Colors.white.withValues(alpha: 0.40),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _levelColor(int level) => switch (level) {
        1 => const Color(0xFF1DE9B6),
        2 => const Color(0xFF4FC3F7),
        3 => const Color(0xFFFFB300),
        4 => const Color(0xFFFF7043),
        _ => const Color(0xFFFF3D57),
      };
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF08091A), Color(0xFF100A2A), Color(0xFF08091A)],
              ),
            ),
          ),
          SizedBox.expand(child: CustomPaint(painter: _StarPainter())),
          Positioned(
            top: -60,
            left: -30,
            child: _GlowOrb(
              size: 260,
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            right: -50,
            top: 180,
            child: _GlowOrb(
              size: 200,
              color: const Color(0xFFFFB300).withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            left: 40,
            bottom: -40,
            child: _GlowOrb(
              size: 220,
              color: const Color(0xFF1DE9B6).withValues(alpha: 0.06),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.0)]),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  static const _stars = [
    (0.05, 0.04, 1.6),
    (0.88, 0.03, 1.2),
    (0.42, 0.08, 2.0),
    (0.70, 0.14, 1.4),
    (0.18, 0.22, 1.8),
    (0.95, 0.30, 1.0),
    (0.03, 0.48, 1.6),
    (0.55, 0.55, 1.2),
    (0.82, 0.64, 2.0),
    (0.30, 0.72, 1.0),
    (0.65, 0.82, 1.8),
    (0.12, 0.90, 1.4),
    (0.50, 0.38, 1.0),
    (0.76, 0.26, 1.4),
    (0.37, 0.50, 1.6),
    (0.92, 0.70, 1.2),
    (0.22, 0.82, 2.0),
    (0.60, 0.95, 1.4),
    (0.80, 0.92, 1.0),
    (0.45, 0.68, 1.6),
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
