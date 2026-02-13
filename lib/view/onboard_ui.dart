import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickqr_pro/utils/app_colors.dart';
import 'package:quickqr_pro/utils/app_images.dart';
import 'package:quickqr_pro/utils/text_styling.dart';
import 'package:quickqr_pro/view/home/ui/home_ui.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Center(
            child: SizedBox(
              height: 420,
              width: 250,
              child:
                  Hero(tag: 'appLogo', child: Image.asset(AppImages.appLogo)),
            ),
          ),
          Container(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Get Started",
                  textScaler: TextScaler.linear(1),
                  style: StyledText.txtStyle.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background),
                ),
                Text(
                  "Scan and generate any QR code in seconds. Fast, smart, and easy to use.",
                  textScaler: TextScaler.linear(1),
                  textAlign: TextAlign.center,
                  style: StyledText.txtStyle
                      .copyWith(fontSize: 16, color: AppColors.background),
                ),
                IconButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomeView(),
                        )),
                    icon: Icon(
                      Icons.arrow_circle_right_rounded,
                      color: AppColors.background,
                      size: 75,
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}
