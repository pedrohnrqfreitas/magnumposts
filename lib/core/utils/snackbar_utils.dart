import 'package:flutter/material.dart';
import '../navigation/app_navigator.dart';

class SnackBarUtils {
  static void showError(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showSuccess(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showWarning(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void showInfo(String message) {
    _showSnackBar(
      message,
      backgroundColor: const Color(0xFF667eea),
      icon: Icons.info_outline_rounded,
    );
  }

  static void _showSnackBar(
      String message, {
        required Color backgroundColor,
        required IconData icon,
      }) {
    final context = AppNavigator.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
