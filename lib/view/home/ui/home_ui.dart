import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quickqr_pro/utils/app_images.dart';
import 'package:quickqr_pro/utils/text_styling.dart';
import 'package:quickqr_pro/widgets/app_buttons.dart';
import 'package:quickqr_pro/widgets/banner_ad_widget.dart';
import '../../../controller/text_fields_controllers.dart';
import '../../../utils/app_colors.dart';
import '../../qr generate/ui/generate_qr_ui.dart';
import '../../scanner/ui/qr_scanner_ui.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BannerAd bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111', // test ID
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => log('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        log('Ad failed to load: $error');
        ad.dispose();
      },
    ),
  )..load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Column(
                children: [
                  SizedBox(height: 80, child: Image.asset(AppImages.appLogo1)),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Choose your action!",
                      textScaler: TextScaler.linear(1),
                      style: StyledText.txtStyle.copyWith(
                          fontSize: 25,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 100),
                  Wrap(
                    spacing: 20, // Horizontal space between buttons
                    runSpacing: 10, // Vertical space when buttons wrap
                    alignment: WrapAlignment.center,
                    children: [
                      AppButtons(
                        onTap: () async {
                          final scannedData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QRScannerView()),
                          );

                          if (scannedData != null && context.mounted) {
                            final controller =
                                Provider.of<TextFieldsControllers>(context,
                                    listen: false);
                            controller.qrDataController.text =
                                scannedData.toString();
                          }
                        },
                        icon: AppImages.scan,
                        text: "Scan QR",
                      ),
                      AppButtons(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GenerateQRView()),
                          );
                        },
                        icon: AppImages.qr,
                        text: "Generate QR",
                      ),
                    ],
                  )
                ],
              ),
              Center(
                child: Text(
                  textScaler: TextScaler.linear(1),
                  "App Version: 1.0.2",
                  style: StyledText.txtStyle.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ),
              BannerAdWidget()
              // Container(
              //   alignment: Alignment.center,
              //   width: bannerAd.size.width.toDouble(),
              //   height: bannerAd.size.height.toDouble(),
              //   child: AdWidget(ad: bannerAd),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
