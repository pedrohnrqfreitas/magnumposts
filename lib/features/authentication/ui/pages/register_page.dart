import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/authentication/models/params/register_params.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(AppConstants.textColorPrimaryValue)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.paddingM),

                // Header
                Column(
                  children: [
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
                      child: const Icon(
                        Icons.person_add_rounded,
                        size: AppConstants.avatarSizeS,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingL),
                    const Text(
                      AppConstants.registerTitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                        color: Color(AppConstants.textColorPrimaryValue),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingXxs),
                    const Text(
                      AppConstants.registerSubtitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: Color(AppConstants.textColorTertiaryValue),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.avatarSizeS),

                // Formulário
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo Nome
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: AppConstants.nameFieldOptionalLabel,
                          prefixIcon: const Icon(Icons.person_outlined),
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
                      ),
                      const SizedBox(height: AppConstants.paddingS),

                      // Campo Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: AppConstants.emailFieldHint,
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
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: AppConstants.passwordFieldHint,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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
                      const SizedBox(height: AppConstants.paddingS),

                      // Campo Confirmar Senha
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: AppConstants.confirmPasswordFieldHint,
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
                          if (value != _passwordController.text) {
                            return AppConstants.passwordMismatchMessage;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Mensagem de Erro
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppConstants.paddingS),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingXs),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[600], size: AppConstants.iconSizeS),
                        const SizedBox(width: AppConstants.paddingXxs),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: AppConstants.fontSizeXs,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Mensagem de Sucesso
                if (_successMessage != null) ...[
                  const SizedBox(height: AppConstants.paddingS),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingXs),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green[600], size: AppConstants.iconSizeS),
                        const SizedBox(width: AppConstants.paddingXxs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _successMessage!,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: AppConstants.fontSizeXs,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppConstants.redirectingMessage,
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: AppConstants.fontSizeXxs,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.paddingL),

                // Botão Registrar
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _performRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppConstants.primaryColorValue),
                        minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        elevation: AppConstants.authCardElevation,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading) ...[
                            const SizedBox(
                              height: AppConstants.iconSizeS,
                              width: AppConstants.iconSizeS,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: AppConstants.paddingXs),
                            const Text(
                              AppConstants.creatingAccountMessage,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeS,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            const Icon(Icons.person_add_rounded, color: Colors.white),
                            const SizedBox(width: AppConstants.paddingXxs),
                            const Text(
                              AppConstants.registerButtonText,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeS,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppConstants.paddingL),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppConstants.registerFooterText,
                      style: TextStyle(
                        color: Color(AppConstants.textColorTertiaryValue),
                        fontSize: AppConstants.fontSizeXs,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(AppConstants.primaryColorValue),
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXxs),
                      ),
                      child: const Text(
                        AppConstants.registerFooterButtonText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppConstants.fontSizeXs,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    switch (state.runtimeType) {
      case AuthError:
        _handleError(state as AuthError);
        break;
      case AuthSuccess:
        _handleSuccess(state as AuthSuccess);
        break;
      case AuthLoading:
        _clearMessages();
        break;
    }
  }

  void _handleError(AuthError state) {
    setState(() {
      _errorMessage = state.message;
      _successMessage = null;
    });
  }

  void _handleSuccess(AuthSuccess state) {
    setState(() {
      _errorMessage = null;
      _successMessage = state.message;
    });
    _navigateToLoginAfterDelay();
  }

  void _clearMessages() {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });
  }

  void _navigateToLoginAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginPage(clearData: true),
          ),
        );
      }
    });
  }

  void _performRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = RegisterParams(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      displayName: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : null,
    );

    context.read<AuthBloc>().add(AuthRegisterRequested(params: params));
  }
}