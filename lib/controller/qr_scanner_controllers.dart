import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:provider/provider.dart';
import 'package:quickqr_pro/controller/web_view_controllers.dart';

import '../view/scanner/ui/qr_image_scanner_ui.dart';

class QrScanProvider with ChangeNotifier {
  String? qrResult;
  File? selectedImage;
  bool _isNavigated = false;
  bool get isNavigated => _isNavigated;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageAndScanQR(BuildContext context, String route) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        if (selectedImage != null && route == 'scanner') {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => QrImageScannerView(),
              ));
          _isNavigated = true;
        }
        notifyListeners();

        await _scanQRFromFile(selectedImage!, context);
      }
    } catch (e) {
      debugPrint('❌ Error picking image or scanning: $e');
    }
  }

  Future<void> _scanQRFromFile(File imageFile, BuildContext context) async {
    final webViewProvider =
        Provider.of<WebViewProvider>(context, listen: false);
    final inputImage = InputImage.fromFile(imageFile);
    final barcodeScanner = BarcodeScanner();

    final barcodes = await barcodeScanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      qrResult = barcodes.first.rawValue;
      log('✅ QR Code: $qrResult');
      webViewProvider.loadUrl(qrResult ?? '');
    } else {
      qrResult = null;
      webViewProvider.loadUrl(qrResult ?? '');
      debugPrint('❌ No QR code found');
    }

    notifyListeners();
    await barcodeScanner.close();
  }

  void clearImg() {
    selectedImage = null;
    qrResult = null;
    _isNavigated = false;
    notifyListeners();
  }
}
