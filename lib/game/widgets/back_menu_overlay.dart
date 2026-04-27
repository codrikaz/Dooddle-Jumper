import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ads/banner_ad_panel.dart';
import '../../audio/game_audio_controller.dart';
import '../hoplet_bird.dart';

class BackMenuOverlay extends StatelessWidget {
  const BackMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final hopletBird = game as HopletBird;
    final character = hopletBird.gameManager.character;

    return Material(
      color: Colors.black.withValues(alpha: 0.78),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF09111D),
                    Color(0xFF101D30),
                    Color(0xFF070C14),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 100,
                    right: -30,
                    child: _GlowOrb(
                      size: 180,
                      color: const Color(0xFF54D6FF).withValues(alpha: 0.10),
                    ),
                  ),
                  Positioned(
                    left: -40,
                    bottom: 80,
                    child: _GlowOrb(
                      size: 160,
                      color: const Color(0xFF00D7A7).withValues(alpha: 0.09),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: BannerAdPanel(),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactWidth = constraints.maxWidth < 380;
                final compactHeight = constraints.maxHeight < 760;
                final sidePadding = compactWidth ? 14.0 : 20.0;
                final cardPadding = compactWidth ? 16.0 : 20.0;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(14, 72, 14, 18),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Container(
                        padding: EdgeInsets.all(cardPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFF0B1624).withValues(alpha: 0.92),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.28),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF54D6FF)
                                                .withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            'GAME PAUSED',
                                            style: TextStyle(
                                              color: const Color(0xFF83E3FF),
                                              fontSize: compactWidth ? 10 : 11,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.6,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Ready when you are',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: compactWidth ? 24 : 28,
                                            fontWeight: FontWeight.w900,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Tune settings or jump right back into the run.',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.60),
                                            fontSize: compactWidth ? 12 : 13,
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: compactWidth ? 74 : 86,
                                    height: compactWidth ? 74 : 86,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF19314A),
                                          Color(0xFF0E1E31),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.08),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/images/game/${character.name}_center.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: sidePadding,
                                  vertical: compactHeight ? 12 : 14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Colors.white.withValues(alpha: 0.04),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.07),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color(0xFF00D7A7)
                                            .withValues(alpha: 0.14),
                                      ),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: Color(0xFF7FF6D7),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Current Character',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.45),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            character.displayName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: compactWidth ? 14 : 15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFC65C)
                                            .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'Paused',
                                        style: TextStyle(
                                          color: Color(0xFFFFD88E),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'SETTINGS',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.48),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _SettingTile(
                                      notifier: GameAudioController.soundEnabled,
                                      label: 'Sound',
                                      activeText: 'On',
                                      inactiveText: 'Off',
                                      iconOn: Icons.volume_up_rounded,
                                      iconOff: Icons.volume_off_rounded,
                                      tint: const Color(0xFF54D6FF),
                                      onTap: () async {
                                        await GameAudioController.playButtonTap();
                                        GameAudioController.toggleSound();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _SettingTile(
                                      notifier: GameAudioController.musicEnabled,
                                      label: 'Music',
                                      activeText: 'On',
                                      inactiveText: 'Off',
                                      iconOn: Icons.music_note_rounded,
                                      iconOff: Icons.music_off_rounded,
                                      tint: const Color(0xFF00D7A7),
                                      onTap: () async {
                                        await GameAudioController.playButtonTap();
                                        await GameAudioController.toggleMusic();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _SettingTile(
                                      notifier: GameAudioController.hapticEnabled,
                                      label: 'Haptic',
                                      activeText: 'On',
                                      inactiveText: 'Off',
                                      iconOn: Icons.vibration_rounded,
                                      iconOff: Icons.phonelink_erase_rounded,
                                      tint: const Color(0xFFFFC65C),
                                      onTap: () async {
                                        await GameAudioController.playButtonTap();
                                        GameAudioController.toggleHaptic();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'ACTIONS',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.48),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _PrimaryActionButton(
                                label: 'RESUME',
                                subtitle: 'Continue current run',
                                icon: Icons.play_arrow_rounded,
                                colors: const [
                                  Color(0xFF00C897),
                                  Color(0xFF29F0BE),
                                ],
                                onPressed: () async {
                                  await GameAudioController.playButtonTap();
                                  hopletBird.overlays.remove('backMenuOverlay');
                                  hopletBird.togglePauseState();
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MiniActionButton(
                                      label: 'RESTART',
                                      icon: Icons.refresh_rounded,
                                      tint: const Color(0xFFFFB347),
                                      onPressed: () async {
                                        await GameAudioController.playButtonTap();
                                        hopletBird.togglePauseState();
                                        hopletBird.overlays.remove('backMenuOverlay');
                                        await hopletBird.resetGame();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _MiniActionButton(
                                      label: 'EXIT',
                                      icon: Icons.close_rounded,
                                      tint: const Color(0xFFFF7183),
                                      onPressed: () async {
                                        await GameAudioController.playButtonTap();
                                        await SystemNavigator.pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
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
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.notifier,
    required this.label,
    required this.activeText,
    required this.inactiveText,
    required this.iconOn,
    required this.iconOff,
    required this.tint,
    required this.onTap,
  });

  final ValueNotifier<bool> notifier;
  final String label;
  final String activeText;
  final String inactiveText;
  final IconData iconOn;
  final IconData iconOff;
  final Color tint;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, isOn, __) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isOn
                  ? tint.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: isOn
                    ? tint.withValues(alpha: 0.28)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  isOn ? iconOn : iconOff,
                  color: isOn ? tint : Colors.white.withValues(alpha: 0.45),
                  size: 20,
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOn ? activeText : inactiveText,
                  style: TextStyle(
                    color: isOn ? tint : Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.26),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  const _MiniActionButton({
    required this.label,
    required this.icon,
    required this.tint,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: tint.withValues(alpha: 0.10),
          border: Border.all(color: tint.withValues(alpha: 0.24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: tint, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: tint,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
