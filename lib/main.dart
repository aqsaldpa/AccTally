import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/database/database_init.dart';
import 'core/logger/app_logger.dart';
import 'core/preferences/app_preferences.dart';
import 'core/localization/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    logger.info('=== App Startup ===');

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
