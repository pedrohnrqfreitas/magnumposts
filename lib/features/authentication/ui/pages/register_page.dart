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

/// Página de registro seguindo Clean Architecture
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
        listener: _handleAuthStateChange,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildRegisterContent(),
          ),
        ),
      ),
    );
  }

  /// AppBar simples - Clean Code
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

  /// Handler para mudanças de estado
  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showErrorSnackBar(state.message);
    } else if (state is AuthSuccess) {
      _showSuccessSnackBar(state.message);
      _navigateToLogin();
    }
  }

  /// Exibir mensagem de erro
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Exibir mensagem de sucesso
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navegação para login
  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  /// Conteúdo principal da página
  Widget _buildRegisterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const AuthHeaderWidget(
          title: 'Criar Conta',
          subtitle: 'Preencha os dados para se cadastrar',
          icon: Icons.person_add_rounded,
        ),
        const SizedBox(height: 40),
        _buildNameField(),
        const SizedBox(height: 16),
        _buildRegisterForm(),
        const SizedBox(height: 24),
        _buildRegisterButton(),
        const SizedBox(height: 24),
        AuthFooterWidget(
          text: 'Já tem uma conta?',
          buttonText: 'Fazer login',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  /// Campo de nome - widget separado
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

  /// Formulário de registro
  Widget _buildRegisterForm() {
    return AuthFormWidget(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      isPasswordVisible: _isPasswordVisible,
      onPasswordVisibilityToggle: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
      emailHint: 'Digite seu email',
      passwordHint: 'Digite sua senha',
      confirmPasswordHint: 'Confirme sua senha',
      showConfirmPassword: true,
    );
  }

  /// Botão de registro com loading
  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return LoadingButtonWidget(
          text: 'Criar Conta',
          isLoading: state is AuthLoading,
          onPressed: _performRegister,
          icon: Icons.person_add_rounded,
        );
      },
    );
  }

  /// Estilo de borda - reutilizado
  InputBorder _buildInputBorder({bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isFocused ? const Color(0xFF667eea) : Colors.grey[300]!,
        width: isFocused ? 2 : 1,
      ),
    );
  }

  /// Executar registro - responsabilidade única
  void _performRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final params = RegisterParams(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        displayName: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : null,
      );


    }
  }
}