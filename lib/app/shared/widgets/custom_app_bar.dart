import 'package:acctally/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final Gradient? gradient;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.toolbarHeight,
    this.backgroundColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight ?? 60.h,
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient:
              gradient ??
              const LinearGradient(
                colors: [
                  AppColors.gradientColorBluePrimary,
                  AppColors.gradientColorBlueSecondary,
                ],
                stops: [0.13, 10],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 60.h);
}
