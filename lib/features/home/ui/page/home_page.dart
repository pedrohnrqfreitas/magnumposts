import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/ui/bloc/auth_bloc.dart';
import '../../../authentication/ui/bloc/auth_state.dart';
import '../../../authentication/ui/pages/login_page.dart';
import '../../../posts/ui/pages/posts_list_page.dart';

/// Home Page que redireciona para a listagem de posts
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthStateChange,
      child: const PostsListPage(), // Redireciona diretamente para posts
    );
  }

  /// Handle para mudanças de estado de auth
  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      _navigateToLogin(context);
    }
  }

  /// Navegação para login
  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}