import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class AppLogger {
  static const String _tag = 'MagnumPosts';

  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void critical(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.critical, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
      LogLevel level,
      String message, {
        String? tag,
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag ?? _tag;
      final levelStr = level.name.toUpperCase();

      String logMessage = '[$timestamp] [$levelStr] [$logTag] $message';

      if (error != null) {
        logMessage += '\nError: $error';
      }

      if (stackTrace != null) {
        logMessage += '\nStack trace:\n$stackTrace';
      }

      // Use different methods based on log level
      switch (level) {
        case LogLevel.debug:
          developer.log(logMessage, name: logTag, level: 500);
          break;
        case LogLevel.info:
          developer.log(logMessage, name: logTag, level: 800);
          break;
        case LogLevel.warning:
          developer.log(logMessage, name: logTag, level: 900);
          break;
        case LogLevel.error:
        case LogLevel.critical:
          developer.log(
            logMessage,
            name: logTag,
            level: 1000,
            error: error,
            stackTrace: stackTrace,
          );
          break;
      }
    }
  }

  // Specific logging methods for different modules
  static void auth(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: 'AUTH', error: error, stackTrace: stackTrace);
  }

  static void api(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: 'API', error: error, stackTrace: stackTrace);
  }

  static void navigation(String message) {
    _log(LogLevel.debug, message, tag: 'NAV');
  }

  static void performance(String message, {Duration? duration}) {
    final msg = duration != null ? '$message (${duration.inMilliseconds}ms)' : message;
    _log(LogLevel.info, msg, tag: 'PERF');
  }

  static void bloc(String blocName, String event, String state) {
    _log(LogLevel.debug, '$blocName: $event -> $state', tag: 'BLOC');
  }
}