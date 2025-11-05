import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:acctally/core/logger/app_logger.dart';
import 'package:acctally/core/preferences/app_preferences.dart';
import 'en.dart';
import 'ms.dart';

class LocalizationService extends Translations {
  static const String enUS = 'en_US';
  static const String msMY = 'ms_MY';

  static final LocalizationService _instance = LocalizationService._internal();

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  static const Locale enLocale = Locale('en', 'US');
  static const Locale msLocale = Locale('ms', 'MY');

  @override
  Map<String, Map<String, String>> get keys => {
    enUS: enLocalization.cast<String, String>(),
    msMY: msLocalization.cast<String, String>(),
  };

  static Locale get currentLocale {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ms') {
      return msLocale;
    }
    return enLocale;
  }

  static Future<void> init() async {
    try {
      final savedLanguage = preferences.getString('language');

      if (savedLanguage == 'ms') {
        Get.updateLocale(msLocale);
        logger.info('Language set to Malay');
      } else {
        Get.updateLocale(enLocale);
        logger.info('Language set to English');
      }
    } catch (e) {
      logger.error('Error initializing localization', e);
      Get.updateLocale(enLocale);
    }
  }

  static Future<void> setLanguage(String language) async {
    try {
      if (language == 'ms') {
        Get.updateLocale(msLocale);
        await preferences.setString('language', 'ms');
        logger.info('Language changed to Malay');
      } else {
        Get.updateLocale(enLocale);
        await preferences.setString('language', 'en');
        logger.info('Language changed to English');
      }
    } catch (e) {
      logger.error('Error changing language', e);
    }
  }

  static String get(String key) {
    try {
      return key.tr;
    } catch (e) {
      logger.warning('Translation key not found: $key');
      return key;
    }
  }

  static String getCurrentLanguage() {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ms') {
      return 'Bahasa Melayu';
    }
    return 'English';
  }

  static String getCurrentLanguageCode() {
    final lang = Get.locale?.languageCode ?? 'en';
    return lang == 'ms' ? 'ms' : 'en';
  }
}

final localization = LocalizationService();
