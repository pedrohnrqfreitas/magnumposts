import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class SuccessProfileBottomSheet extends StatelessWidget {
  const SuccessProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(AppConstants.backgroundColorCardValue),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadiusL),
          topRight: Radius.circular(AppConstants.borderRadiusL),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: AppConstants.iconSizeXxl,
            ),
            const SizedBox(height: AppConstants.paddingS),
            const Text(
              AppConstants.profileSuccessTitle,
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.textColorPrimaryValue),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXxs),
            const Text(
              AppConstants.profileSuccessMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeXs,
                color: Color(AppConstants.textColorTertiaryValue),
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha bottom sheet
                  Navigator.of(context).pop(); // Volta para ProfileDetailPage
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppConstants.primaryColorValue),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}