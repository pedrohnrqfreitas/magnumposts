import 'package:flutter/material.dart';

/// Widget reutilizável para cabeçalho de auth - SRP (responsabilidade única)
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF718096),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}