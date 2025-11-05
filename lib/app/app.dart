import 'package:acctally/app/modules/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/constants/app_constants.dart';
import '../core/logger/app_logger.dart';
import '../core/localization/localization_service.dart';
import 'shared/theme/app_theme.dart';

class AccTallyApp extends StatelessWidget {
  const AccTallyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.getLightTheme(),
          themeMode: ThemeMode.system,
          home: child,
          translations: LocalizationService(),
          locale: LocalizationService.currentLocale,
          fallbackLocale: LocalizationService.enLocale,
          supportedLocales: const [
            LocalizationService.enLocale,
            LocalizationService.msLocale,
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          onReady: () {
            logger.info('App initialized and ready');
          },
        );
      },
      child: const OnboardingScreen(),
    );
  }
}
