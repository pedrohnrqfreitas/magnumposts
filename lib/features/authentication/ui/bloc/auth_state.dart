import 'package:equatable/equatable.dart';
import '../../../../data/authentication/models/user_model.dart';

/// Estados abstratos para extensibilidade (OCP)
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - responsabilidade única (SRP)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carregamento com mensagem opcional
class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de usuário autenticado
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado de usuário não autenticado
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de erro com detalhes
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

/// Estado de sucesso para ações específicas
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