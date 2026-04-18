import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameOverNativeAdPanel extends StatefulWidget {
  const GameOverNativeAdPanel({super.key});

  @override
  State<GameOverNativeAdPanel> createState() => _GameOverNativeAdPanelState();
}

class _GameOverNativeAdPanelState extends State<GameOverNativeAdPanel> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  String? get _adUnitId {
    if (kIsWeb) {
      return null;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'ca-app-pub-3940256099942544/2247696110';
      case TargetPlatform.iOS:
        return 'ca-app-pub-3940256099942544/3986624511';
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final adUnitId = _adUnitId;
    if (adUnitId == null) {
      return;
    }

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _nativeAd = ad as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: const Color(0xFFF7F2ED),
        cornerRadius: 18,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: const Color(0xFFE48B60),
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFF46342C),
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFF7B6257),
          style: NativeTemplateFontStyle.normal,
          size: 13,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFF9A7F72),
          style: NativeTemplateFontStyle.normal,
          size: 12,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 320,
            minHeight: 90,
            maxWidth: 420,
            maxHeight: 120,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AdWidget(ad: _nativeAd!),
          ),
        ),
      ),
    );
  }
}
