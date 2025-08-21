import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;

  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null) ...[
          Container(
            width: AppConstants.authHeaderIconSize,
            height: AppConstants.authHeaderIconSize,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(AppConstants.primaryColorValue),
                  Color(AppConstants.secondaryColorValue),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.authHeaderIconRadius),
            ),
            child: Icon(
              icon,
              size: AppConstants.avatarSizeS,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXxl,
            fontWeight: FontWeight.bold,
            color: Color(AppConstants.textColorPrimaryValue),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.paddingXxs),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeS,
            color: Color(AppConstants.textColorTertiaryValue),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}