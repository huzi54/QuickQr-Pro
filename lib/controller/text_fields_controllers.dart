import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickqr_pro/utils/text_styling.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class TextFieldsControllers with ChangeNotifier {
  final TextEditingController qrDataController = TextEditingController();

  String? _qrData;
  String? get qrData => _qrData;

  void generateQR(String val) {
    _qrData = '';
    _qrData = val;

    log("QR Value: $_qrData");
    notifyListeners();
  }

  final FocusNode qrDataFocusNode = FocusNode();

  GlobalKey previewContainer = GlobalKey(); // for screenshot

  bool isProcessing = false;

  void setProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }

  /// Capture widget as image
  Future<Uint8List?> captureWidgetAsImage() async {
    try {
      RenderRepaintBoundary boundary = previewContainer.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        return captureWidgetAsImage(); // retry
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Screenshot error: $e');
      return null;
    }
  }

  /// Save image to gallery
  Future<void> saveQrImage() async {
    try {
      final imageBytes = await captureWidgetAsImage();

      if (imageBytes == null) {
        debugPrint('Failed to capture image.');
        return;
      }

      final status = await Permission.storage.request();
      if (!status.isGranted) {
        debugPrint('Storage permission denied');
        return;
      }

      final time = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'quickqr_$time.png';

      await Gal.putImageBytes(imageBytes, name: fileName);
      debugPrint('Image saved successfully as $fileName');
    } catch (e) {
      debugPrint('Error saving QR image: $e');
    }
  }

  /// Share captured image
  Future<void> shareQrImage() async {
    try {
      final imageBytes = await captureWidgetAsImage();

      if (imageBytes == null) {
        debugPrint('Failed to capture image.');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/qr_share.png';
      final file = await File(filePath).writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Here’s my QR Code!');
    } catch (e) {
      debugPrint('Error sharing QR image: $e');
    }
  }

  void copyQR(BuildContext context, String? scannedQrData) {
    if (scannedQrData != null) {
      Clipboard.setData(ClipboardData(text: scannedQrData));
    } else {
      Clipboard.setData(ClipboardData(text: _qrData ?? ''));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'QR data copied to clipboard!',
          style: StyledText.txtStyle
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> pasteQrDataFromClipboard(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null &&
        clipboardData.text != null &&
        clipboardData.text!.trim().isNotEmpty) {
      qrDataController.text = clipboardData.text!.trim();
      _qrData = qrDataController.text;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Clipboard is empty.",
            style: StyledText.txtStyle
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        return true;
      } else {
        // Optional: Show a dialog to guide the user to app settings
        return false;
      }
    }
    return true; // iOS doesn't need this
  }

  @override
  void dispose() {
    qrDataController.dispose();
    qrDataFocusNode.dispose();
    super.dispose();
  }

  void clearQRData() {
    _qrData = null;
    qrDataController.clear();
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    // Request necessary permissions
    await Permission.storage.request(); // Android pre-13
    await Permission.photos.request(); // iOS and Android 13+
  }

  Future<Uint8List?> captureQrWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Screenshot Error: $e");
      return null;
    }
  }

  Future<void> saveQrToGallery(GlobalKey key, BuildContext context) async {
    requestPermissions();
    final bytes = await captureQrWidget(key);
    if (bytes == null) return;

    final result = await Gal.putImageBytes(bytes, album: 'QuickQR Pro');
    debugPrint("Saved to gallery: ");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'QR saved to gallery',
          style: StyledText.txtStyle
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> shareQr(GlobalKey key) async {
    final bytes = await captureQrWidget(key);
    if (bytes == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/qr_temp.png').create();
    await imagePath.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(imagePath.path)],
      text: "Check out my QR Code from QuickQR Pro!",
    );
  }
}
