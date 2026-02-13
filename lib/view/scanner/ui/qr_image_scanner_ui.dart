import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickqr_pro/controller/text_fields_controllers.dart';
import 'package:quickqr_pro/view/home/ui/home_ui.dart';
import 'package:quickqr_pro/view/scanner/ui/webview_ui.dart';

import '../../../controller/qr_scanner_controllers.dart';
import '../../../controller/web_view_controllers.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/text_styling.dart';
import '../../../widgets/banner_ad_widget.dart';

class QrImageScannerView extends StatelessWidget {
  const QrImageScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final qrProvider = Provider.of<QrScanProvider>(context, listen: false);
    final webViewProvider =
        Provider.of<WebViewProvider>(context, listen: false);
    final fieldsControllers =
        Provider.of<TextFieldsControllers>(context, listen: false);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background.withValues(alpha: .5),
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeView(),
                  ));
              qrProvider.clearImg();
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Consumer<QrScanProvider>(
              builder: (context, qrProvider, _) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      fieldsControllers.clearQRData();
                      qrProvider.clearImg();
                      webViewProvider.clearUrl();
                      qrProvider.pickImageAndScanQR(context, 'imgscanner');
                    },
                    child: Text(
                      'Pick QR Image from Gallery',
                      textScaler: TextScaler.linear(1),
                      style: StyledText.txtStyle.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // if (qrProvider.selectedImage != null &&
                  //     qrProvider.qrResult != null)
                  qrProvider.selectedImage != null &&
                          qrProvider.qrResult != null
                      ? Image.file(
                          qrProvider.selectedImage!,
                          height: 200,
                          filterQuality: FilterQuality.medium,
                        )
                      : Text(
                          'Image does not contain QR*',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                          textScaler: TextScaler.linear(1),
                        ),
                  SizedBox(height: 5),
                  if (qrProvider.qrResult != null)
                    Text(
                      'QR Code: ${qrProvider.qrResult!}',
                      textScaler: TextScaler.linear(1),
                    ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (qrProvider.qrResult != null)
                        GestureDetector(
                          onTap: () {
                            fieldsControllers.copyQR(
                                context, qrProvider.qrResult);
                            fieldsControllers.clearQRData();

                            // Navigator.pop(dialogContext);
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
                              textScaler: TextScaler.linear(1),
                              style: StyledText.txtStyle.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      //
                      Consumer<WebViewProvider>(
                        builder: (context, webPro, child) {
                          final url = webPro.currentUrl;

                          if (url == null || !webPro.isValidUrl(url)) {
                            return SizedBox(); // or disable the button visually
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                // ✅ Fast navigation, no revalidation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WebViewScreen(input: url),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Open Link",
                                  textScaler: TextScaler.linear(1),
                                  style: StyledText.txtStyle.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
      ),
    );
  }
}
