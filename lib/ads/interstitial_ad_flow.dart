import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdFlow {
  static String get _adUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
  }

  static Future<void> showThen(VoidCallback onDone) async {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onDone();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onDone();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          onDone();
        },
      ),
    );
  }
}
