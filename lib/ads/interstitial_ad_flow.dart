import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_units.dart';

class InterstitialAdFlow {
  static InterstitialAd? _loadedAd;
  static bool _isLoading = false;

  static void preload() {
    if (_isLoading || _loadedAd != null) {
      return;
    }

    final adUnitId = AdUnits.interstitial;
    if (adUnitId == null) {
      return;
    }

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
        },
      ),
    );
  }

  static Future<void> showThen(VoidCallback onDone) async {
    final ad = _loadedAd;
    _loadedAd = null;

    if (ad == null) {
      preload();
      onDone();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        onDone();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        preload();
        onDone();
      },
    );

    ad.show();
  }
}
