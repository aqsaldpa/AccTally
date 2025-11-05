import 'package:acctally/app/modules/home/views/home_screen.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:acctally/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.primaryColor],
          ),
        ),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Image.asset(Assets.images.logo.path, height: 165.h),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 400.h),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.red),
                      children: [
                        TextSpan(
                          text: 'appName'.tr,
                          style: TextStyle(
                            color: AppColors.darkBlueColor,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        TextSpan(
                          text: 'appName2'.tr,
                          style: TextStyle(
                            color: AppColors.lightGreenColor,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.w),
                    child: Text(
                      'onboardingSubtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 15.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                  Gap(20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'getStarted'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
