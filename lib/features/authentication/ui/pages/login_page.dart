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

/// Página de login seguindo Clean Architecture - apenas login conforme PDF
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

  /// Handler para mudanças de estado - responsabilidade única
  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showErrorSnackBar(state.message);
    } else if (state is AuthAuthenticated) {
      _navigateToHome();
    }
  }

  /// Exibir erro - método utilitário
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navegação para home
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  /// Conteúdo principal da página - organizado em widgets
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
        const SizedBox(height: 32),
        _buildLoginButton(),
        const SizedBox(height: 24),
        _buildRegisterFooter(),
      ],
    );
  }

  /// Formulário de login - widget separado para organização
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

  /// Botão de login com loading - Clean Code
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

  /// Footer com link para registro
  Widget _buildRegisterFooter() {
    return AuthFooterWidget(
      text: 'Não tem uma conta?',
      buttonText: 'Criar conta',
      onPressed: _navigateToRegister,
    );
  }

  /// Executar login - método com responsabilidade única
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

  /// Navegar para página de registro
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }
}