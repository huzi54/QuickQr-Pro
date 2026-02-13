import 'package:flutter/material.dart';
import 'package:quickqr_pro/utils/app_images.dart';
import 'package:quickqr_pro/view/onboard_ui.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home/ui/home_ui.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardView()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111110),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                child: Hero(
                  tag: "logo",
                  child: Image.asset(AppImages.appLogo, height: 220),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
