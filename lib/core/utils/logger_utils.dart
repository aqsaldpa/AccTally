import '../logger/app_logger.dart';

class LoggerUtils {
  static void logApiCall(String method, String endpoint, [Map<String, dynamic>? params]) {
    final paramStr = params != null ? ' | ${params.toString()}' : '';
    logger.info('API: $method $endpoint$paramStr');
  }

  static void logDbOperation(String operation, String table, [int? recordCount]) {
    final countStr = recordCount != null ? ' | Records: $recordCount' : '';
    logger.debug('DB: $operation on $table$countStr');
  }

  static void logUiEvent(String screen, String action, [String? details]) {
    final detailStr = details != null ? ' | $details' : '';
    logger.debug('UI: [$screen] $action$detailStr');
  }

  static void logPerformance(String operation, Duration duration) {
    logger.debug('Performance: $operation completed in ${duration.inMilliseconds}ms');
  }

  static void logFeatureUsage(String featureName) {
    logger.info('Feature used: $featureName');
  }

  static void logErrorWithContext(
    String context,
    String message,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    logger.error('[$context] $message', error, stackTrace);
  }
}
