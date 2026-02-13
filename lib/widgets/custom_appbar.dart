import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/text_styling.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: GestureDetector(
        onTap: onBackTap ?? () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 25, bottom: 25),
          child: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(AppImages.backArrow),
          ),
        ),
      ),
      toolbarHeight: 85,
      centerTitle: true,
      title: Text(
        title,
        textScaler: TextScaler.linear(1),
        style: StyledText.txtStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(85);
}
