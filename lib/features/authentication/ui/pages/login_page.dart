// lib/features/authentication/ui/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/authentication/models/params/login_params.dart';
import '../../../home/ui/page/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_widget.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/auth_footer_widget.dart';
import 'register_page.dart';

/// Página de login seguindo Clean Architecture - SEM TOASTS
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildLoginContent(),
          ),
        ),
      ),
    );
  }

  /// Handler LIMPO - apenas navegação e controle de erro
  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthError) {
      setState(() {
        _errorMessage = state.message;
      });
    } else if (state is AuthAuthenticated) {
      _navigateToHome();
    } else if (state is AuthLoading) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  Widget _buildLoginContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        const AuthHeaderWidget(
          title: 'Magnum Posts',
          subtitle: 'Entre com seu email e senha',
          icon: Icons.article_rounded,
        ),
        const SizedBox(height: 60),
        _buildLoginForm(),
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          _buildErrorMessage(),
        ],
        const SizedBox(height: 32),
        _buildLoginButton(),
        const SizedBox(height: 24),
        _buildRegisterFooter(),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return AuthFormWidget(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      isPasswordVisible: _isPasswordVisible,
      onPasswordVisibilityToggle: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
      emailHint: 'Digite seu email',
      passwordHint: 'Digite sua senha',
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : _performLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Text(
            'Entrar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterFooter() {
    return AuthFooterWidget(
      text: 'Não tem uma conta?',
      buttonText: 'Criar conta',
      onPressed: _navigateToRegister,
    );
  }

  void _performLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final params = LoginParams(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      context.read<AuthBloc>().add(
        AuthLoginRequested(params: params),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }
}