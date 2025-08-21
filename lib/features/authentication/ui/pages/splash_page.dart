import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
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
  static const Duration _timeoutDuration = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _initializeAuthCheck();
    _setupTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(AppConstants.primaryColorValue),
                Color(AppConstants.secondaryColorValue),
              ],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone do App
                Icon(
                  Icons.article_rounded,
                  size: AppConstants.authIconSize,
                  color: Colors.white,
                ),
                SizedBox(height: AppConstants.paddingL),

                // Título do App
                Text(
                  AppConstants.splashTitle,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXxxl,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppConstants.paddingXs),

                // Subtítulo
                Text(
                  AppConstants.splashSubtitle,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: AppConstants.dimenXl),

                // Indicador de Loading
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initializeAuthCheck() {
    Future.delayed(_splashDelay, () {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthCheckStatusRequested());
      }
    });
  }

  void _setupTimeout() {
    Future.delayed(_timeoutDuration, () {
      if (mounted) {
        _navigateToLoginWithClearData();
      }
    });
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      _navigateToHome();
    } else if (state is AuthUnauthenticated) {
      _navigateToLoginWithClearData();
    } else if (state is AuthError) {
      _navigateToLoginWithClearData();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

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