import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

class AdService {
  late BannerAd bannerAd;
  bool isBannerAdLoaded = false;

  void initBannerAd(Function onLoaded) {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdLoaded = true;
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('Ad failed to load: $error');
        },
      ),
    );

    bannerAd.load();
  }

  void disposeBannerAd() {
    bannerAd.dispose();
  }
}
