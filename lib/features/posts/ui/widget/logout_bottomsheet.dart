import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class LogoutBottomsheet extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutBottomsheet({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppConstants.logoutConfirmTitle,
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          const Text(
            AppConstants.logoutConfirmMessage,
            style: TextStyle(
              fontSize: AppConstants.fontSizeS,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            child: const Text(
              AppConstants.logoutButtonText,
              style: TextStyle(fontSize: AppConstants.fontSizeS),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXxs),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            child: const Text(
              AppConstants.cancelButtonText,
              style: TextStyle(fontSize: AppConstants.fontSizeS),
            ),
          ),
        ],
      ),
    );
  }
}