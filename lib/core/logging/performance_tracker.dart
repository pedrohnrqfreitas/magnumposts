import 'app_loger.dart';

class PerformanceTracker {
  static final Map<String, DateTime> _startTimes = {};

  static void startTracking(String operation) {
    _startTimes[operation] = DateTime.now();
    AppLogger.performance('Started tracking: $operation');
  }

  static void endTracking(String operation) {
    final startTime = _startTimes.remove(operation);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      AppLogger.performance('Completed: $operation', duration: duration);
    }
  }

  static T trackSync<T>(String operation, T Function() function) {
    startTracking(operation);
    try {
      final result = function();
      endTracking(operation);
      return result;
    } catch (e) {
      endTracking(operation);
      AppLogger.error('Error in $operation', error: e);
      rethrow;
    }
  }

  static Future<T> trackAsync<T>(String operation, Future<T> Function() function) async {
    startTracking(operation);
    try {
      final result = await function();
      endTracking(operation);
      return result;
    } catch (e) {
      endTracking(operation);
      AppLogger.error('Error in $operation', error: e);
      rethrow;
    }
  }
}