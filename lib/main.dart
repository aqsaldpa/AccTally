import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'app/app.dart';
import 'core/database/database_init.dart';
import 'core/logger/app_logger.dart';
import 'core/preferences/app_preferences.dart';
import 'core/localization/localization_service.dart';

// Conditional imports based on platform
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi_native;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as ffi_web;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    logger.info('=== App Startup ===');

    // Initialize database factory based on platform
    if (kIsWeb) {
      // For web, initialize FFI web with IndexedDB
      databaseFactory = ffi_web.databaseFactoryFfiWeb;
      logger.info('Database factory initialized for web (IndexedDB)');
    } else {
      // For native platforms, initialize FFI
      ffi_native.sqfliteFfiInit();
      databaseFactory = ffi_native.databaseFactoryFfi;
      logger.info('Database factory initialized for native platform (FFI)');
    }

    await preferences.init();
    logger.info('SharedPreferences initialized');

    await LocalizationService.init();
    logger.info('Localization initialized');

    await databaseInit.init();
    logger.info('Database initialized');

    logger.info('All systems initialized successfully');
  } catch (e, stackTrace) {
    logger.error('Initialization error', e, stackTrace);
    rethrow;
  }

  runApp(const AccTallyApp());
}
