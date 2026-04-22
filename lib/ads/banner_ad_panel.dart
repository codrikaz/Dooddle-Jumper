import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_units.dart';

class BannerAdPanel extends StatefulWidget {
  const BannerAdPanel({super.key});

  @override
  State<BannerAdPanel> createState() => _BannerAdPanelState();
}

class _BannerAdPanelState extends State<BannerAdPanel> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  int? _lastRequestedWidth;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadAdForWidth(int width) async {
    if (_lastRequestedWidth == width || width <= 0) {
      return;
    }

    _lastRequestedWidth = width;
    _isLoaded = false;
    _bannerAd?.dispose();

    final adUnitId = AdUnits.banner;
    if (adUnitId == null) {
      return;
    }

    final adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (!mounted || adaptiveSize == null) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: adaptiveSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          if (!mounted) {
            return;
          }
          setState(() {
            _isLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final safeWidth = MediaQuery.sizeOf(context).width -
            MediaQuery.paddingOf(context).left -
            MediaQuery.paddingOf(context).right;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : safeWidth;
        final requestWidth = availableWidth.floor();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _loadAdForWidth(requestWidth);
          }
        });

        final ad = _bannerAd;
        final adHeight = _isLoaded && ad != null
            ? ad.size.height.toDouble()
            : 0.0;

        return SafeArea(
          bottom: false,
          child: SizedBox(
            width: double.infinity,
            height: adHeight,
            child: _isLoaded && ad != null
                ? Center(
                    child: SizedBox(
                      width: ad.size.width.toDouble(),
                      height: adHeight,
                      child: AdWidget(ad: ad),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
