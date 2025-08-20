import 'package:flutter/material.dart';
import '../logging/app_loger.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get _navigator => navigatorKey.currentState;

  static Future<T?> push<T extends Object?>(
      String routeName,
      Widget page, {
        Object? arguments,
      }) {
    AppLogger.navigation('Navigating to: $routeName');
    return _navigator?.push<T>(
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
    ) ?? Future.value(null);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      String routeName,
      Widget page, {
        TO? result,
        Object? arguments,
      }) {
    AppLogger.navigation('Replacing with: $routeName');
    return _navigator?.pushReplacement<T, TO>(
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
      result: result,
    ) ?? Future.value(null);
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      String routeName,
      Widget page,
      bool Function(Route<dynamic>) predicate, {
        Object? arguments,
      }) {
    AppLogger.navigation('Navigating to $routeName and removing until predicate');
    return _navigator?.pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
      predicate,
    ) ?? Future.value(null);
  }

  static void pop<T extends Object?>([T? result]) {
    AppLogger.navigation('Popping current route');
    _navigator?.pop<T>(result);
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    AppLogger.navigation('Popping until predicate');
    _navigator?.popUntil(predicate);
  }

  static bool canPop() {
    return _navigator?.canPop() ?? false;
  }
}