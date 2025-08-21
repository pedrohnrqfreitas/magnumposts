import 'package:equatable/equatable.dart';
import '../../../../data/authentication/models/params/login_params.dart';
import '../../../../data/authentication/models/params/register_params.dart';
import '../../../../data/authentication/models/user_model.dart';

/// Eventos de autenticação seguindo o princípio Open/Closed
/// Novos eventos podem ser adicionados sem modificar os existentes
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para verificar status inicial de autenticação
class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

/// Evento para realizar login com credenciais
class AuthLoginRequested extends AuthEvent {
  final LoginParams params;

  const AuthLoginRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Evento para realizar registro de nova conta
class AuthRegisterRequested extends AuthEvent {
  final RegisterParams params;

  const AuthRegisterRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Evento para realizar logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Evento interno para mudanças de estado do Firebase
class AuthStateChanged extends AuthEvent {
  final UserModel? user;

  const AuthStateChanged({this.user});

  @override
  List<Object?> get props => [user];
}