import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AuthFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final String emailHint;
  final String passwordHint;
  final String? confirmPasswordHint;
  final bool showConfirmPassword;

  const AuthFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.emailHint,
    required this.passwordHint,
    this.confirmPasswordController,
    this.confirmPasswordHint,
    this.showConfirmPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Campo Email
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: emailHint,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: AppConstants.authInputBorderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: AppConstants.authInputBorderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: Color(AppConstants.primaryColorValue),
                  width: AppConstants.authInputFocusedBorderWidth,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.emailRequiredMessage;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return AppConstants.emailInvalidMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingS),

          // Campo Senha
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              hintText: passwordHint,
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: onPasswordVisibilityToggle,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: AppConstants.authInputBorderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: AppConstants.authInputBorderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: Color(AppConstants.primaryColorValue),
                  width: AppConstants.authInputFocusedBorderWidth,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.passwordRequiredMessage;
              }
              if (value.length < AppConstants.minPasswordLength) {
                return AppConstants.passwordMinLengthMessage;
              }
              return null;
            },
          ),

          // Campo Confirmar Senha (se necessário)
          if (showConfirmPassword) ...[
            const SizedBox(height: AppConstants.paddingS),
            TextFormField(
              controller: confirmPasswordController!,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: confirmPasswordHint ?? AppConstants.confirmPasswordFieldHint,
                prefixIcon: const Icon(Icons.lock_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: AppConstants.authInputBorderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: AppConstants.authInputBorderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: const BorderSide(
                    color: Color(AppConstants.primaryColorValue),
                    width: AppConstants.authInputFocusedBorderWidth,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.confirmPasswordRequiredMessage;
                }
                if (value != passwordController.text) {
                  return AppConstants.passwordMismatchMessage;
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }
}