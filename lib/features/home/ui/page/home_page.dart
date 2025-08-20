import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/ui/bloc/auth_bloc.dart';
import '../../../authentication/ui/bloc/auth_event.dart';
import '../../../authentication/ui/bloc/auth_state.dart';
import '../../../authentication/ui/pages/login_page.dart';

/// Home Page temporária - será expandida com posts
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: _buildHomeContent(),
      ),
    );
  }

  /// AppBar com ação de logout
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Magnum Posts'),
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => _performLogout(context),
        ),
      ],
    );
  }

  /// Conteúdo temporário da home
  Widget _buildHomeContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_rounded,
            size: 100,
            color: Color(0xFF667eea),
          ),
          SizedBox(height: 24),
          Text(
            'Bem-vindo ao Magnum Posts!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Em breve: listagem de posts do JSONPlaceholder',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Handle para mudanças de estado de auth
  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      _navigateToLogin(context);
    }
  }

  /// Executar logout
  void _performLogout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  /// Navegação para login
  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}