import 'package:shared_preferences/shared_preferences.dart';
import '../logger/app_logger.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      logger.info('SharedPreferences initialized successfully');
    } catch (e) {
      logger.error('Failed to initialize SharedPreferences', e);
      rethrow;
    }
  }

  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      logger.debug('Saved string: $key');
    } catch (e) {
      logger.error('Error saving string: $key', e);
      rethrow;
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      logger.error('Error reading string: $key', e);
      return null;
    }
  }

  Future<void> setInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
      logger.debug('Saved int: $key');
    } catch (e) {
      logger.error('Error saving int: $key', e);
      rethrow;
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      logger.error('Error reading int: $key', e);
      return null;
    }
  }

  Future<void> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
      logger.debug('Saved bool: $key');
    } catch (e) {
      logger.error('Error saving bool: $key', e);
      rethrow;
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      logger.error('Error reading bool: $key', e);
      return null;
    }
  }

  Future<void> setDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
      logger.debug('Saved double: $key');
    } catch (e) {
      logger.error('Error saving double: $key', e);
      rethrow;
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      logger.error('Error reading double: $key', e);
      return null;
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
      logger.debug('Removed key: $key');
    } catch (e) {
      logger.error('Error removing key: $key', e);
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
      logger.info('All preferences cleared');
    } catch (e) {
      logger.error('Error clearing preferences', e);
      rethrow;
    }
  }
}

final preferences = AppPreferences();
