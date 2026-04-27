import 'package:flutter/material.dart';

import '../../audio/game_audio_controller.dart';
import '../../platform/rate_app_service.dart';

class GameSettingsPanel extends StatelessWidget {
  const GameSettingsPanel({
    super.key,
    this.centered = true,
    this.dark = false,
  });

  final bool centered;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final panel = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(18),
        border: dark
            ? Border.all(color: Colors.white.withValues(alpha: 0.10))
            : null,
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          _SoundToggleButton(dark: dark),
          _MusicToggleButton(dark: dark),
          _HapticToggleButton(dark: dark),
          _RateUsButton(dark: dark),
        ],
      ),
    );

    if (centered) {
      return Center(child: panel);
    }

    return panel;
  }
}

class _SettingsChipButton extends StatelessWidget {
  const _SettingsChipButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.active,
    this.filled = false,
    this.dark = false,
  });

  final Future<void> Function() onPressed;
  final IconData icon;
  final String label;
  final bool active;
  final bool filled;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;

    if (dark) {
      if (filled) {
        backgroundColor = const Color(0xFFFFB300);
        foregroundColor = const Color(0xFF0A0A1A);
      } else if (active) {
        backgroundColor = const Color(0xFF4FC3F7).withValues(alpha: 0.15);
        foregroundColor = const Color(0xFF4FC3F7);
      } else {
        backgroundColor = Colors.white.withValues(alpha: 0.07);
        foregroundColor = Colors.white.withValues(alpha: 0.55);
      }
    } else {
      backgroundColor = filled
          ? scheme.secondary
          : active
              ? scheme.primaryContainer
              : Colors.white;
      foregroundColor = filled
          ? scheme.onSecondary
          : active
              ? scheme.onPrimaryContainer
              : scheme.onSurface;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        await onPressed();
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: dark
                ? (active && !filled
                    ? const Color(0xFF4FC3F7).withValues(alpha: 0.40)
                    : Colors.white.withValues(alpha: 0.10))
                : (filled ? Colors.transparent : scheme.outlineVariant),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foregroundColor, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundToggleButton extends StatelessWidget {
  const _SoundToggleButton({this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GameAudioController.soundEnabled,
      builder: (context, isEnabled, child) {
        return _SettingsChipButton(
          onPressed: () async {
            await GameAudioController.playButtonTap();
            GameAudioController.toggleSound();
          },
          icon: isEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
          label: isEnabled ? 'Sound On' : 'Sound Off',
          active: isEnabled,
          dark: dark,
        );
      },
    );
  }
}

class _MusicToggleButton extends StatelessWidget {
  const _MusicToggleButton({this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GameAudioController.musicEnabled,
      builder: (context, isEnabled, child) {
        return _SettingsChipButton(
          onPressed: () async {
            await GameAudioController.playButtonTap();
            await GameAudioController.toggleMusic();
          },
          icon: isEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
          label: isEnabled ? 'Music On' : 'Music Off',
          active: isEnabled,
          dark: dark,
        );
      },
    );
  }
}

class _HapticToggleButton extends StatelessWidget {
  const _HapticToggleButton({this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GameAudioController.hapticEnabled,
      builder: (context, isEnabled, child) {
        return _SettingsChipButton(
          onPressed: () async {
            await GameAudioController.playButtonTap();
            GameAudioController.toggleHaptic();
          },
          icon: isEnabled ? Icons.vibration_rounded : Icons.phonelink_erase_rounded,
          label: isEnabled ? 'Haptic On' : 'Haptic Off',
          active: isEnabled,
          dark: dark,
        );
      },
    );
  }
}

class _RateUsButton extends StatelessWidget {
  const _RateUsButton({this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return _SettingsChipButton(
      onPressed: () async {
        await GameAudioController.playButtonTap();
        await RateAppService.openStoreListing();
      },
      icon: Icons.star_rate_rounded,
      label: 'Rate Us',
      active: true,
      filled: true,
      dark: dark,
    );
  }
}
