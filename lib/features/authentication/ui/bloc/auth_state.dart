import 'package:equatable/equatable.dart';
import '../../../../data/authentication/models/user_model.dart';

/// Estados de autenticação seguindo Single Responsibility Principle
/// Cada estado tem uma responsabilidade específica e bem definida
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial antes de qualquer operação
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carregamento durante operações assíncronas
class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado quando usuário está autenticado com sucesso
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado quando usuário não está autenticado
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de erro durante operações de autenticação
class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Estado de sucesso para operações específicas (ex: registro)
class AuthSuccess extends AuthState {
  final String message;
  final UserModel? user;

  const AuthSuccess({
    required this.message,
    this.user,
  });

  @override
  List<Object?> get props => [message, user];
}