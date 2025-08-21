import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/authentication/models/params/login_params.dart';
import '../../../home/ui/page/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final bool clearData;

  const LoginPage({
    super.key,
    this.clearData = false,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    if (widget.clearData) {
      _clearFormData();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearFormData();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.dimenXxl),

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
                        Icons.article_rounded,
                        size: AppConstants.avatarSizeS,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingL),
                    const Text(
                      AppConstants.loginTitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                        color: Color(AppConstants.textColorPrimaryValue),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingXxs),
                    const Text(
                      AppConstants.loginSubtitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: Color(AppConstants.textColorTertiaryValue),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.dimenXxl),

                // Formulário
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                const SizedBox(height: AppConstants.dimenXs),

                // Botão Login
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _performLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppConstants.primaryColorValue),
                        minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: AppConstants.iconSizeS,
                        width: AppConstants.iconSizeS,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        AppConstants.loginButtonText,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeS,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
                      AppConstants.loginFooterText,
                      style: TextStyle(
                        color: Color(AppConstants.textColorTertiaryValue),
                        fontSize: AppConstants.fontSizeXs,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: _navigateToRegister,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(AppConstants.primaryColorValue),
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXxs),
                      ),
                      child: const Text(
                        AppConstants.loginFooterButtonText,
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
      case AuthAuthenticated:
        _navigateToHome();
        break;
      case AuthLoading:
        _clearError();
        break;
      case AuthUnauthenticated:
        _clearFormData();
        break;
    }
  }

  void _handleError(AuthError state) {
    setState(() => _errorMessage = state.message);
  }

  void _clearError() {
    setState(() => _errorMessage = null);
  }

  void _clearFormData() {
    _emailController.clear();
    _passwordController.clear();
    _clearError();
    _formKey.currentState?.reset();
    setState(() => _isPasswordVisible = false);
  }

  void _performLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = LoginParams(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    context.read<AuthBloc>().add(AuthLoginRequested(params: params));
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }
}