import 'package:flutter/material.dart';

/// Widget de rodapé reutilizável - SRP
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
            color: Color(0xFF718096),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF667eea),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}