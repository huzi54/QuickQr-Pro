import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/banner_ad_widget.dart';
import '../../../widgets/custom_appbar.dart';

class WebViewScreen extends StatefulWidget {
  final String input;

  const WebViewScreen({super.key, required this.input});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // BannerAd bannerAd = BannerAd(
    //   adUnitId: 'ca-app-pub-3940256099942544/6300978111', // test ID
    //   size: AdSize.banner,
    //   request: AdRequest(),
    //   listener: BannerAdListener(
    //     onAdLoaded: (Ad ad) => log('Ad loaded.'),
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       log('Ad failed to load: $error');
    //       ad.dispose();
    //     },
    //   ),
    // )..load();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Webview',
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.input)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                isLoading = false;
              });
              log("WebView load error: $message");
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BannerAdWidget(),
    );
  }
}
