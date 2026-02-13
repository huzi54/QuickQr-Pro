import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

import '../utils/text_styling.dart';

class AppButtons extends StatelessWidget {
  const AppButtons(
      {super.key,
      this.icon,
      this.text,
      this.textSize,
      this.borderRadius,
      this.iconH,
      this.iconW,
      this.btnH,
      this.btnW,
      this.onTap});
  final String? icon;
  final double? iconH;
  final double? iconW;
  final String? text;
  final double? textSize;

  final double? borderRadius;
  final double? btnH;
  final double? btnW;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: btnH ?? 100,
        width: btnW ?? 130,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary,
                  blurRadius: 5,
                  blurStyle: BlurStyle.outer)
            ],
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(borderRadius ?? 12)),
        child: text != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: iconH ?? 50,
                    width: iconW ?? 50,
                    child: icon != null
                        ? Image.asset(
                            icon!,
                          )
                        : SizedBox(),
                  ),
                  if (icon != null) SizedBox(height: 5),
                  Text(
                    textScaler: TextScaler.linear(1),
                    text ?? '',
                    style: StyledText.txtStyle.copyWith(),
                  )
                ],
              )
            : Center(
                child: SizedBox(
                  height: iconH ?? 50,
                  width: iconW ?? 50,
                  child: icon != null
                      ? Image.asset(
                          icon!,
                        )
                      : SizedBox(),
                ),
              ),
      ),
    );
  }
}
