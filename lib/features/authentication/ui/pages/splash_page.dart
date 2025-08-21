import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/ui/page/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Duration _splashDelay = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _initializeAuthCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: const _SplashContent(),
      ),
    );
  }

  /// Inicializa verificação de autenticação após delay
  void _initializeAuthCheck() {
    Future.delayed(_splashDelay, () {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthCheckStatusRequested());
      }
    });
  }

  /// Gerencia mudanças de estado de autenticação
  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    switch (state.runtimeType) {
      case AuthAuthenticated:
        _navigateToHome();
        break;
      case AuthUnauthenticated:
        _navigateToLoginWithClearData();
        break;
    // AuthError e AuthLoading são ignorados intencionalmente
    // para manter uma experiência de splash suave
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  /// Navega para login garantindo que os dados sejam limpos
  void _navigateToLoginWithClearData() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginPage(clearData: true),
        ),
      );
    }
  }
}

/// Widget de conteúdo da splash seguindo Single Responsibility Principle
class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const _SplashGradient(),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AppIcon(),
            SizedBox(height: 24),
            _AppTitle(),
            SizedBox(height: 12),
            _AppSubtitle(),
            SizedBox(height: 48),
            _LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Widgets específicos seguindo Single Responsibility Principle

class _SplashGradient extends BoxDecoration {
  const _SplashGradient()
      : super(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
  );
}

class _AppIcon extends StatelessWidget {
  const _AppIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.article_rounded,
      size: 100,
      color: Colors.white,
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Magnum Posts',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _AppSubtitle extends StatelessWidget {
  const _AppSubtitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Seu app de posts favorito',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}