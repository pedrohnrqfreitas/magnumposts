import 'package:flutter/material.dart';

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
          _EmailField(controller: emailController, hint: emailHint),
          const SizedBox(height: 16),
          _PasswordField(
            controller: passwordController,
            hint: passwordHint,
            isVisible: isPasswordVisible,
            onVisibilityToggle: onPasswordVisibilityToggle,
          ),
          if (showConfirmPassword) ...[
            const SizedBox(height: 16),
            _ConfirmPasswordField(
              controller: confirmPasswordController!,
              hint: confirmPasswordHint ?? 'Confirme sua senha',
              isVisible: isPasswordVisible,
              originalPassword: passwordController.text,
            ),
          ],
        ],
      ),
    );
  }
}


class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _EmailField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.email_outlined),
        border: _InputBorderStyle.standard(),
        enabledBorder: _InputBorderStyle.standard(),
        focusedBorder: _InputBorderStyle.focused(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _EmailValidator.validate,
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isVisible;
  final VoidCallback onVisibilityToggle;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.isVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: onVisibilityToggle,
        ),
        border: _InputBorderStyle.standard(),
        enabledBorder: _InputBorderStyle.standard(),
        focusedBorder: _InputBorderStyle.focused(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _PasswordValidator.validate,
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isVisible;
  final String originalPassword;

  const _ConfirmPasswordField({
    required this.controller,
    required this.hint,
    required this.isVisible,
    required this.originalPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outlined),
        border: _InputBorderStyle.standard(),
        enabledBorder: _InputBorderStyle.standard(),
        focusedBorder: _InputBorderStyle.focused(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) => _PasswordValidator.validateConfirmation(value, originalPassword),
    );
  }
}

class _InputBorderStyle {
  static OutlineInputBorder standard() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
  );

  static OutlineInputBorder focused() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
  );
}

class _EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    if (!_isValidEmailFormat(value)) {
      return 'Por favor, insira um email válido';
    }

    return null;
  }

  static bool _isValidEmailFormat(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

class _PasswordValidator {
  static const int _minLength = 6;

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < _minLength) {
      return 'Senha deve ter pelo menos $_minLength caracteres';
    }

    return null;
  }

  static String? validateConfirmation(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != originalPassword) {
      return 'Senhas não coincidem';
    }

    return null;
  }
}