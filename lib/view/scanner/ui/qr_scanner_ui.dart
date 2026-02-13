import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:quickqr_pro/controller/text_fields_controllers.dart';
import 'package:quickqr_pro/controller/web_view_controllers.dart';
import 'package:quickqr_pro/utils/app_colors.dart';
import 'package:quickqr_pro/view/scanner/ui/qr_image_scanner_ui.dart';
import 'package:quickqr_pro/view/scanner/ui/webview_ui.dart';

import '../../../controller/qr_scanner_controllers.dart';
import '../../../utils/app_images.dart';
import '../../../utils/text_styling.dart';
import '../../../widgets/banner_ad_widget.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

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

  void _onDetect(BarcodeCapture capture) async {
    final fieldsControllers =
        Provider.of<TextFieldsControllers>(context, listen: false);
    final webviewControllers =
        Provider.of<WebViewProvider>(context, listen: false);
    if (isScanned) return;

    final String? qrData = capture.barcodes.first.rawValue;
    if (qrData != null) {
      setState(() => isScanned = true);
      fieldsControllers.generateQR(qrData);
      webviewControllers.loadUrl(qrData);

      await controller.stop(); // stop camera

      // Show snackbar before popping context
      if (mounted) {
        // Optional: Show dialog before navigating back
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => PopScope(
            canPop: false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // Removed fixed height
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xff1F1F1F),
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'QR Code: $qrData',
                          maxLines: 2,
                          style: StyledText.txtStyle.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                fieldsControllers.copyQR(context, null);
                                fieldsControllers.clearQRData();
                                Navigator.pop(dialogContext);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Copy",
                                  style: StyledText.txtStyle.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            //
                            Consumer<WebViewProvider>(
                              builder: (context, webPro, child) => webPro
                                          .isUrlValid ==
                                      true
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          fieldsControllers.copyQR(
                                              context, null);
                                          fieldsControllers.clearQRData();

                                          final url = webPro.currentUrl;
                                          // HERE i CAll WEb View
                                          if (url != null &&
                                              webPro.isValidUrl(url)) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      WebViewScreen(input: url),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Open Link",
                                            style: StyledText.txtStyle.copyWith(
                                              color: AppColors.background,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Navigate back after UI is shown
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrProvider = Provider.of<QrScanProvider>(context, listen: false);
    final webviewControllers =
        Provider.of<WebViewProvider>(context, listen: false);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background.withValues(alpha: .5),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 25, bottom: 25),
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset(AppImages.backArrow)),
            ),
          ),
          toolbarHeight: 85,
          title: Text(
            "Scan QR",
            style: StyledText.txtStyle
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              qrProvider.pickImageAndScanQR(context, 'scanner').then(
                (value) {
                  if (qrProvider.selectedImage != null &&
                      qrProvider.isNavigated == true) {
                    controller.stop();
                    webviewControllers.loadUrl(qrProvider.qrResult ?? '');
                  }
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pick QR Image from Gallery',
                  textScaler: TextScaler.linear(1),
                  style:
                      StyledText.txtStyle.copyWith(fontWeight: FontWeight.w700),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.primary,
                )
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: controller,
              onDetect: _onDetect,
            ),
            Consumer<TextFieldsControllers>(
              builder: (context, con, child) =>
                  con.qrData == null || con.qrData == ''
                      ? AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Positioned(
                              top: MediaQuery.of(context).size.height * 0.25 +
                                  _animation.value *
                                      MediaQuery.of(context).size.height *
                                      0.4,
                              left: 40,
                              right: 40,
                              child: Container(
                                height: 2,
                                color: Colors.greenAccent,
                              ),
                            );
                          },
                        )
                      : SizedBox(),
            ),
            BannerAdWidget()
          ],
        ),
      ),
    );
  }
}
