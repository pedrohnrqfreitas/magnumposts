import 'package:equatable/equatable.dart';
import '../../../../data/authentication/models/params/login_params.dart';
import '../../../../data/authentication/models/user_model.dart';

/// Eventos abstratos para extensibilidade (OCP)
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para verificar status de autenticação
class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

/// Evento para login - Interface específica (ISP)
class AuthLoginRequested extends AuthEvent {
  final LoginParams params;

  const AuthLoginRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Evento para logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Evento interno para mudança de estado de auth
class AuthStateChanged extends AuthEvent {
  final UserModel? user;

  const AuthStateChanged({this.user});

  @override
  List<Object?> get props => [user];
}