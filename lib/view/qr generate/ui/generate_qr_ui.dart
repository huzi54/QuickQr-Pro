import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickqr_pro/controller/text_fields_controllers.dart';
import 'package:quickqr_pro/utils/app_colors.dart';
import 'package:quickqr_pro/utils/app_images.dart';
import 'package:quickqr_pro/utils/text_styling.dart';
import 'package:quickqr_pro/widgets/app_buttons.dart';

import '../../../widgets/banner_ad_widget.dart';

class GenerateQRView extends StatefulWidget {
  const GenerateQRView({super.key});

  @override
  State<GenerateQRView> createState() => _GenerateQRViewState();
}

class _GenerateQRViewState extends State<GenerateQRView> {
  late FocusNode qrFocusNode;

  @override
  void initState() {
    super.initState();
    qrFocusNode = FocusNode();
  }

  @override
  void dispose() {
    qrFocusNode.dispose();

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
  final GlobalKey qrKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final fieldsControllers = Provider.of<TextFieldsControllers>(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        fieldsControllers.clearQRData();
        qrFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
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
            "Generate QR",
            style: StyledText.txtStyle
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  padding: EdgeInsets.only(left: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff1F1F1F),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: qrFocusNode,
                          controller: fieldsControllers.qrDataController,
                          style: StyledText.txtStyle,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          qrFocusNode.unfocus();
                          if (fieldsControllers.qrDataController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '⚠️ Enter some data to generate a QR code!',
                                  style: StyledText.txtStyle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                duration: Duration(seconds: 5),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          fieldsControllers.generateQR(
                              fieldsControllers.qrDataController.text);
                        },
                        child: Container(
                          height: 45,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                            color: AppColors.primary,
                          ),
                          child: Center(
                              child: Text(
                            "Go",
                            style: StyledText.txtStyle.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                AppButtons(
                  btnH: 30,
                  btnW: 80,
                  iconW: 0,
                  iconH: 0,
                  text: "Paste",
                  onTap: () {
                    qrFocusNode.unfocus();
                    fieldsControllers.pasteQrDataFromClipboard(context);
                  },
                ),
                SizedBox(height: 50),
                Consumer<TextFieldsControllers>(
                  builder: (context, fieldsCons, child) => (fieldsCons.qrData !=
                          null)
                      ? Column(
                          children: [
                            // Take Screenshot of this QrImageView only

// Inside your build method
                            RepaintBoundary(
                              key: qrKey,
                              child: Container(
                                color: Colors.white, // Ensure white background
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    QrImageView(
                                      data: fieldsCons.qrData ?? '',
                                      version: QrVersions.auto,
                                      size: 200.0,
                                      eyeStyle: QrEyeStyle(
                                        color: AppColors.background,
                                        eyeShape: QrEyeShape.square,
                                      ),
                                      dataModuleStyle: QrDataModuleStyle(
                                        color: AppColors.background,
                                        dataModuleShape:
                                            QrDataModuleShape.square,
                                      ),
                                    ),
                                    Text(
                                      "Powered by QuickQR Pro",
                                      style: StyledText.txtStyle.copyWith(
                                          fontSize: 10,
                                          color: AppColors.background),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            // RepaintBoundary(
                            //   key: fieldsControllers.previewContainer,
                            //   child: Column(
                            //     children: [
                            //       QrImageView(
                            //         data: fieldsCons.qrData ?? '',
                            //         version: QrVersions.auto,
                            //         size: 200.0,
                            //         eyeStyle: QrEyeStyle(
                            //             color: AppColors.primary,
                            //             eyeShape: QrEyeShape.square),
                            //         dataModuleStyle: QrDataModuleStyle(
                            //           color: AppColors.primary,
                            //           dataModuleShape: QrDataModuleShape.square,
                            //         ),
                            //       ),
                            //       Text(
                            //         "Powered by QuickQR Pro",
                            //         style: StyledText.txtStyle
                            //             .copyWith(fontSize: 10),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // QrImageView end
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppButtons(
                                    icon: AppImages.copy,
                                    iconH: 20,
                                    btnW: 50,
                                    iconW: 100,
                                    btnH: 50,
                                    borderRadius: 100,
                                    onTap: () {
                                      qrFocusNode.unfocus();
                                      fieldsControllers.copyQR(context, null);
                                    }),
                                AppButtons(
                                  icon: AppImages.share,
                                  iconH: 20,
                                  btnW: 50,
                                  iconW: 100,
                                  btnH: 50,
                                  borderRadius: 100,
                                  onTap: () async {
                                    qrFocusNode.unfocus();

                                    await fieldsControllers.shareQr(qrKey);
                                  },
                                ),
                                AppButtons(
                                  icon: AppImages.save,
                                  iconH: 20,
                                  btnW: 50,
                                  iconW: 100,
                                  btnH: 50,
                                  borderRadius: 100,
                                  onTap: () async {
                                    qrFocusNode.unfocus();

                                    await fieldsCons.saveQrToGallery(
                                        qrKey, context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
                SizedBox(
                  height: 20,
                ),
                BannerAdWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
