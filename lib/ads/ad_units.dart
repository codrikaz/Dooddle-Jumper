import 'package:flutter/foundation.dart';

class AdUnits {
  static const bool _adsEnabledInRelease = true;

  // Real Android ad unit IDs used in release builds.
  static const String _androidBannerRelease = 'ca-app-pub-5123860085265147/2317864156';
  static const String _androidInterstitialRelease = 'ca-app-pub-5123860085265147/2456323315';
  static const String _androidNativeRelease = 'ca-app-pub-5123860085265147/8830159974';

  static String? get banner {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (!_adsEnabledInRelease || _androidBannerRelease.isEmpty) {
      return null;
    }
    return _androidBannerRelease;
  }

  static String? get interstitial {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    if (!_adsEnabledInRelease || _androidInterstitialRelease.isEmpty) {
      return null;
    }
    return _androidInterstitialRelease;
  }

  static String? get native {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/2247696110';
    }
    if (!_adsEnabledInRelease || _androidNativeRelease.isEmpty) {
      return null;
    }
    return _androidNativeRelease;
  }
}
