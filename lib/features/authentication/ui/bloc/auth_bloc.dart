import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase.dart';
import '../../../../data/authentication/models/params/login_params.dart';
import '../../../../data/authentication/models/params/register_params.dart';
import '../../../../data/authentication/models/user_model.dart';

import '../../usercase/check_auth_status_usecase.dart';
import '../../usercase/get_current_user_usecase.dart';
import '../../usercase/login_usecase.dart';
import '../../usercase/logout_usecase.dart';
import '../../usercase/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC seguindo SRP - responsável apenas por gerenciar estado de auth
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Dependency Inversion - depende de abstrações (use cases)
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  StreamSubscription<UserModel?>? _authStatusSubscription;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
  })
      : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        super(const AuthInitial()) {
    // Registrar event handlers
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Escutar mudanças de estado de auth
    _subscribeToAuthChanges();
  }

  /// Método privado para escutar mudanças - SRP
  void _subscribeToAuthChanges() {
    _authStatusSubscription = _checkAuthStatusUseCase.execute().listen(
          (user) => add(AuthStateChanged(user: user)),
    );
  }

  /// Handler para verificar status - Clean Code (nome expressivo)
  Future<void> _onCheckStatusRequested(AuthCheckStatusRequested event,
      Emitter<AuthState> emit,) async {
    emit(const AuthLoading(message: 'Verificando autenticação...'));

    final result = await _getCurrentUserUseCase(NoParams());

    result.fold(
          (failure) => emit(const AuthUnauthenticated()),
          (user) =>
      user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(const AuthUnauthenticated()),
    );
  }

  /// Handler para login - validações e tratamento de erros
  Future<void> _onLoginRequested(AuthLoginRequested event,
      Emitter<AuthState> emit,) async {
    // Validações básicas (Clean Code - fail fast)
    if (!_isValidLoginParams(event.params)) {
      emit(const AuthError(message: 'Email e senha são obrigatórios'));
      return;
    }

    emit(const AuthLoading(message: 'Realizando login...'));

    final result = await _loginUseCase(event.params);

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (authResult) {
        if (authResult.success && authResult.user != null) {
          emit(AuthAuthenticated(user: authResult.user!));
        } else {
          emit(AuthError(message: authResult.message ?? 'Erro no login'));
        }
      },
    );
  }

  /// Handler para registro
  Future<void> _onRegisterRequested(AuthRegisterRequested event,
      Emitter<AuthState> emit,) async {
    // Validações básicas
    if (!_isValidRegisterParams(event.params)) {
      emit(const AuthError(message: 'Todos os campos são obrigatórios'));
      return;
    }

    emit(const AuthLoading(message: 'Criando conta...'));

    final result = await _registerUseCase(event.params);

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (authResult) {
        if (authResult.success && authResult.user != null) {
          emit(AuthSuccess(
            message: 'Conta criada com sucesso! Faça login para continuar.',
            user: authResult.user,
          ));
        } else {
          emit(AuthError(message: authResult.message ?? 'Erro no cadastro'));
        }
      },
    );
  }

  /// Handler para logout
  Future<void> _onLogoutRequested(AuthLogoutRequested event,
      Emitter<AuthState> emit,) async {
    emit(const AuthLoading(message: 'Saindo...'));

    final result = await _logoutUseCase(NoParams());

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(const AuthUnauthenticated()),
    );
  }

  /// Handler para mudança de estado interno
  void _onAuthStateChanged(AuthStateChanged event,
      Emitter<AuthState> emit,) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Validação de parâmetros de login - Clean Code (método expressivo)
  bool _isValidLoginParams(LoginParams params) {
    return params.email.isNotEmpty && params.password.isNotEmpty;
  }

  /// Validação de parâmetros de registro
  bool _isValidRegisterParams(RegisterParams params) {
    return params.email.isNotEmpty &&
        params.password.isNotEmpty &&
        params.confirmPassword.isNotEmpty;
  }

  @override
  Future<void> close() {
    _authStatusSubscription?.cancel();
    return super.close();
  }
}