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
            padding: const EdgeInsets.all(24),
            child: _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        _buildHeader(),
        const SizedBox(height: 60),
        _buildFormFields(),
        _buildErrorMessage(),
        const SizedBox(height: 32),
        _buildLoginButton(),
        const SizedBox(height: 24),
        _buildRegisterFooter(),
      ],
    );
  }

  Widget _buildHeader() => const AuthHeaderWidget(
    title: 'Magnum Posts',
    subtitle: 'Entre com seu email e senha',
    icon: Icons.article_rounded,
  );

  Widget _buildFormFields() => AuthFormWidget(
    formKey: _formKey,
    emailController: _emailController,
    passwordController: _passwordController,
    isPasswordVisible: _isPasswordVisible,
    onPasswordVisibilityToggle: _togglePasswordVisibility,
    emailHint: 'Digite seu email',
    passwordHint: 'Digite sua senha',
  );

  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red[700], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() => BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      final isLoading = state is AuthLoading;

      return ElevatedButton(
        onPressed: isLoading ? null : _performLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF667eea),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildRegisterFooter() => AuthFooterWidget(
    text: 'Não tem uma conta?',
    buttonText: 'Criar conta',
    onPressed: _navigateToRegister,
  );


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
      /// Limpa dados quando usuário não está autenticado (após logout)
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

    setState(() {
      _isPasswordVisible = false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
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