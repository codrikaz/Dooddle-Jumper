import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'interstitial_ad_flow.dart';

class AdService {
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    InterstitialAdFlow.preload();
  }
}
