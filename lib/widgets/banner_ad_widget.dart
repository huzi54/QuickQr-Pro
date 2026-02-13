import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/ads/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _adService.initBannerAd(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _adService.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_adService.isBannerAdLoaded) return const SizedBox();
    return SizedBox(
      width: _adService.bannerAd.size.width.toDouble(),
      height: _adService.bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _adService.bannerAd),
    );
  }
}
