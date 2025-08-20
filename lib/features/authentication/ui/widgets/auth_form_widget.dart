import 'package:flutter/material.dart';

/// Widget de formulário reutilizável - Clean Code (nomes expressivos)
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
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          if (showConfirmPassword) ...[
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
          ],
        ],
      ),
    );
  }

  /// Campo de email - método expressivo (Clean Code)
  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: emailHint,
        prefixIcon: const Icon(Icons.email_outlined),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(isFocused: true),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _validateEmail,
    );
  }

  /// Campo de senha - método expressivo
  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: passwordHint,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onPasswordVisibilityToggle,
        ),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(isFocused: true),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _validatePassword,
    );
  }

  /// Campo de confirmação de senha
  Widget _buildConfirmPasswordField() {
    if (!showConfirmPassword || confirmPasswordController == null) {
      return const SizedBox.shrink();
    }

    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: confirmPasswordHint ?? 'Confirme sua senha',
        prefixIcon: const Icon(Icons.lock_outlined),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(isFocused: true),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _validateConfirmPassword,
    );
  }

  /// Estilo de borda - DRY (Don't Repeat Yourself)
  InputBorder _buildInputBorder({bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isFocused ? const Color(0xFF667eea) : Colors.grey[300]!,
        width: isFocused ? 2 : 1,
      ),
    );
  }

  /// Validação de email - Clean Code (método específico)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
  return null;
}

/// Validação de senha
String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Senha é obrigatória';
  }
  if (value.length < 6) {
    return 'Senha deve ter pelo menos 6 caracteres';
  }
  return null;
}

/// Validação de confirmação de senha
String? _validateConfirmPassword(String? value) {
  if (!showConfirmPassword) return null;

  if (value == null || value.isEmpty) {
    return 'Confirmação de senha é obrigatória';
  }
  if (value != passwordController.text) {
    return 'Senhas não coincidem';
  }
  return null;
}
}