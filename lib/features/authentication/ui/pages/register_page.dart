import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/authentication/models/params/register_params.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_widget.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/auth_footer_widget.dart';
import '../widgets/loading_button_widget.dart';
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
      appBar: _buildAppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildRegisterContent(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildRegisterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        _buildHeader(),
        const SizedBox(height: 40),
        _buildNameField(),
        const SizedBox(height: 16),
        _buildRegisterForm(),
        _buildErrorMessage(),
        _buildSuccessMessage(),
        const SizedBox(height: 24),
        _buildRegisterButton(),
        const SizedBox(height: 24),
        _buildLoginFooter(),
      ],
    );
  }

  Widget _buildHeader() => const AuthHeaderWidget(
    title: 'Criar Conta',
    subtitle: 'Preencha os dados para se cadastrar',
    icon: Icons.person_add_rounded,
  );

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Nome completo (opcional)',
        prefixIcon: const Icon(Icons.person_outlined),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(isFocused: true),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildRegisterForm() => AuthFormWidget(
    formKey: _formKey,
    emailController: _emailController,
    passwordController: _passwordController,
    confirmPasswordController: _confirmPasswordController,
    isPasswordVisible: _isPasswordVisible,
    onPasswordVisibilityToggle: _togglePasswordVisibility,
    emailHint: 'Digite seu email',
    passwordHint: 'Digite sua senha',
    confirmPasswordHint: 'Confirme sua senha',
    showConfirmPassword: true,
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

  Widget _buildSuccessMessage() {
    if (_successMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _successMessage!,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Redirecionando para login...',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() => BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return LoadingButtonWidget(
        text: 'Criar Conta',
        isLoading: state is AuthLoading,
        onPressed: _performRegister,
        icon: Icons.person_add_rounded,
      );
    },
  );

  Widget _buildLoginFooter() => AuthFooterWidget(
    text: 'Já tem uma conta?',
    buttonText: 'Fazer login',
    onPressed: () => Navigator.of(context).pop(),
  );

  InputBorder _buildInputBorder({bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isFocused ? const Color(0xFF667eea) : Colors.grey[300]!,
        width: isFocused ? 2 : 1,
      ),
    );
  }

  /// Handlers de eventos seguindo Single Responsibility Principle

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

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  /// Navega para login após sucesso do registro, garantindo dados limpos
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