import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GameAudioController {
  static final ValueNotifier<bool> soundEnabled  = ValueNotifier(true);
  static final ValueNotifier<bool> musicEnabled  = ValueNotifier(true);
  static final ValueNotifier<bool> hapticEnabled = ValueNotifier(true);

  static bool _initialized    = false;
  static bool _audioAvailable = false;

  // ── Asset paths ───────────────────────────────────────────────────────────
  static const String _musicTrack         = 'music/music.mp3';
  static const String _sfxClick           = 'sfx/click.mp3';
  static const String _sfxJump            = 'sfx/jump2.mp3';
  static const String _sfxCollect         = 'sfx/jumping.mp3';
  static const String _sfxPowerup         = 'sfx/powerup.mp3';
  static const String _sfxPowerupStarting = 'sfx/powerup_starting.mp3';
  static const String _sfxBoost           = 'sfx/boost.mp3';
  static const String _sfxRocket          = 'sfx/rocket.mp3';
  static const String _sfxCrash           = 'sfx/crash.mp3';
  static const String _sfxGameOver        = 'sfx/gameover.mp3';

  // ── Pre-warmed AudioPools — instant, parallel, zero-latency playback ──────
  static AudioPool? _poolClick;
  static AudioPool? _poolJump;
  static AudioPool? _poolCollect;   // maxPlayers=4 — fires on every bounce
  static AudioPool? _poolPowerup;
  static AudioPool? _poolBoost;
  static AudioPool? _poolCrash;
  static AudioPool? _poolGameOver;

  // Boost loop player (separate — continuous loop)
  static AudioPlayer? _boostPlayer;

  // ── Init ──────────────────────────────────────────────────────────────────

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      FlameAudio.bgm.initialize();

      // Pre-load all assets into cache
      await FlameAudio.audioCache.loadAll(<String>[
        _musicTrack,
        _sfxClick,
        _sfxJump,
        _sfxCollect,
        _sfxPowerup,
        _sfxPowerupStarting,
        _sfxBoost,
        _sfxRocket,
        _sfxCrash,
        _sfxGameOver,
      ]);

      // Create AudioPools — each pool keeps players ready to fire instantly.
      // Multiple players in a pool allow the same sound to overlap itself.
      _poolClick    = await FlameAudio.createPool(_sfxClick,    minPlayers: 1, maxPlayers: 2);
      _poolJump     = await FlameAudio.createPool(_sfxJump,     minPlayers: 1, maxPlayers: 2);
      _poolCollect  = await FlameAudio.createPool(_sfxCollect,  minPlayers: 2, maxPlayers: 4);
      _poolPowerup  = await FlameAudio.createPool(_sfxPowerup,  minPlayers: 1, maxPlayers: 2);
      _poolBoost    = await FlameAudio.createPool(_sfxBoost,    minPlayers: 1, maxPlayers: 2);
      _poolCrash    = await FlameAudio.createPool(_sfxCrash,    minPlayers: 1, maxPlayers: 1);
      _poolGameOver = await FlameAudio.createPool(_sfxGameOver, minPlayers: 1, maxPlayers: 1);

      _audioAvailable = true;
      await _syncMusicPlayback();
    } catch (_) {
      _audioAvailable = false;
      soundEnabled.value = false;
      musicEnabled.value = false;
    }
  }

  // ── Toggles ───────────────────────────────────────────────────────────────

  static Future<void> toggleMusic() async {
    if (!_audioAvailable) {
      musicEnabled.value = false;
      return;
    }
    musicEnabled.value = !musicEnabled.value;
    await _syncMusicPlayback();
  }

  static void toggleSound() {
    if (!_audioAvailable) {
      soundEnabled.value = false;
      return;
    }
    soundEnabled.value = !soundEnabled.value;
    if (!soundEnabled.value) stopBoostLoop();
  }

  static void toggleHaptic() {
    hapticEnabled.value = !hapticEnabled.value;
  }

  // ── Haptic ────────────────────────────────────────────────────────────────

  static Future<void> playHaptic() async {
    if (!hapticEnabled.value) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> playLightHaptic() async {
    if (!hapticEnabled.value) return;
    await HapticFeedback.lightImpact();
  }

  // ── SFX — all fire-and-forget via AudioPool ───────────────────────────────

  /// UI button click — everywhere in menus.
  static Future<void> playButtonTap() async =>
      _firePool(_poolClick, volume: 0.65);

  /// Spring-board jump.
  static Future<void> playJump() async =>
      _firePool(_poolJump, volume: 0.55);

  /// Soft bounce — normal platform landing.
  static Future<void> playCollect() async =>
      _firePool(_poolCollect, volume: 0.28);

  /// Powerup pickup (hat or rocket).
  static Future<void> playPowerup() async =>
      _firePool(_poolPowerup, volume: 0.80);

  /// Hat pickup and fly boost start.
  static Future<void> playBoost() async =>
      _firePool(_poolBoost, volume: 0.80);

  /// Enemy platform crash.
  static Future<void> playCrash() async =>
      _firePool(_poolCrash, volume: 0.85);

  /// Game-over screen — instant via pre-warmed pool.
  static void playGameOver() =>
      _firePool(_poolGameOver, volume: 0.80);

  // ── Boost loop (continuous — separate player) ─────────────────────────────

  /// [isRocket] = true  → loops rocket.mp3
  /// [isRocket] = false → loops boost.mp3 (hat/cap)
  static Future<void> startBoostLoop({bool isRocket = false}) async {
    if (!_initialized || !_audioAvailable || !soundEnabled.value) return;
    await stopBoostLoop();
    try {
      final track = isRocket ? _sfxRocket : _sfxBoost;
      _boostPlayer = await FlameAudio.loop(track, volume: 0.38);
    } catch (_) {}
  }

  static Future<void> stopBoostLoop() async {
    final player = _boostPlayer;
    _boostPlayer = null;
    try {
      await player?.stop();
      player?.dispose();
    } catch (_) {}
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  /// Fires the pool instantly — does NOT wait for previous sound to finish.
  static void _firePool(AudioPool? pool, {required double volume}) {
    if (!_initialized || !_audioAvailable || !soundEnabled.value) return;
    pool?.start(volume: volume);
  }

  static Future<void> _syncMusicPlayback() async {
    if (!_initialized || !_audioAvailable) return;
    try {
      await FlameAudio.bgm.stop();
      if (!musicEnabled.value) return;
      await FlameAudio.bgm.play(_musicTrack, volume: 0.18);
    } catch (_) {
      _audioAvailable = false;
      soundEnabled.value = false;
      musicEnabled.value = false;
    }
  }
}
