import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AuthFooterWidget extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthFooterWidget({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(AppConstants.textColorTertiaryValue),
            fontSize: AppConstants.fontSizeXs,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: const Color(AppConstants.primaryColorValue),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXxs),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppConstants.fontSizeXs,
            ),
          ),
        ),
      ],
    );
  }
}