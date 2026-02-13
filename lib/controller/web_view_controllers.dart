import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewProvider with ChangeNotifier {
  InAppWebViewController? webViewController;
  String? currentUrl;
  bool isUrlValid = false;

  void clearUrl() {
    currentUrl = null;
    isUrlValid = false;
  }

  // Check if string is a valid URL
  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  // Load URL in webview
  void loadUrl(String url) {
    if (isValidUrl(url)) {
      currentUrl = url;
      isUrlValid = true;
      notifyListeners();
    } else {
      isUrlValid = false;
      notifyListeners();
    }
  }

  // Assign controller when WebView is created
  void setController(InAppWebViewController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      webViewController = controller;
      notifyListeners();
    });
  }

  // Refresh page
  void reload() {
    webViewController?.reload();
  }

  // Go back
  void goBack() async {
    if (await webViewController?.canGoBack() ?? false) {
      webViewController?.goBack();
    }
  }

  // Go forward
  void goForward() async {
    if (await webViewController?.canGoForward() ?? false) {
      webViewController?.goForward();
    }
  }
}
