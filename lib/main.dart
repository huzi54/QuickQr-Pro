import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quickqr_pro/controller/qr_scanner_controllers.dart';
import 'package:quickqr_pro/controller/web_view_controllers.dart';
import 'package:quickqr_pro/utils/app_colors.dart';
import 'package:quickqr_pro/view/splash_ui.dart';
import 'package:flutter/services.dart';
import 'controller/text_fields_controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TextFieldsControllers>(
          create: (_) => TextFieldsControllers(),
        ),
        ChangeNotifierProvider<WebViewProvider>(
          create: (_) => WebViewProvider(),
        ),
        ChangeNotifierProvider<QrScanProvider>(
          create: (_) => QrScanProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        checkerboardOffscreenLayers: true,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffF4B438)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffF4B438),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const SplashView(),
      ),
    );
  }
}
