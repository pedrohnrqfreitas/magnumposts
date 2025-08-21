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

class AuthBloc extends Bloc<AuthEvent, AuthState> {
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
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        super(const AuthInitial()) {

    /// FLUXO DO BLOC - NUMERADO:
    /// 1. Registra os handlers de eventos
    /// 2. Inicia escuta do stream de mudanças de autenticação
    /// 3. Processa eventos conforme chegam
    /// 4. Emite novos estados baseados nos resultados

    _registerEventHandlers();
    _subscribeToAuthChanges();
  }

  /// 1. REGISTRO DOS HANDLERS - Mapeia eventos para suas funções correspondentes
  void _registerEventHandlers() {
    on<AuthCheckStatusRequested>(_handleCheckStatus);
    on<AuthLoginRequested>(_handleLogin);
    on<AuthRegisterRequested>(_handleRegister);
    on<AuthLogoutRequested>(_handleLogout);
    on<AuthStateChanged>(_handleAuthStateChange);
  }

  /// 2. ESCUTA DE MUDANÇAS - Stream reativo do Firebase Auth
  void _subscribeToAuthChanges() {
    _authStatusSubscription = _checkAuthStatusUseCase.execute().listen(
          (user) => add(AuthStateChanged(user: user)),
      onError: (_) => add(const AuthStateChanged(user: null)),
    );
  }

  /// 3. VERIFICAÇÃO DE STATUS - Handler para evento de verificação inicial
  Future<void> _handleCheckStatus(
      AuthCheckStatusRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading(message: 'Verificando autenticação...'));

    final result = await _getCurrentUserUseCase(NoParams());

    result.fold(
          (_) => emit(const AuthUnauthenticated()),
          (user) => user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(const AuthUnauthenticated()),
    );
  }

  /// 4. PROCESSO DE LOGIN - Handler para evento de login
  Future<void> _handleLogin(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (!_isValidLoginParams(event.params)) {
      emit(const AuthError(message: 'Email e senha são obrigatórios'));
      return;
    }

    emit(const AuthLoading(message: 'Realizando login...'));

    final result = await _loginUseCase(event.params);

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (authResult) => authResult.success && authResult.user != null
          ? emit(AuthAuthenticated(user: authResult.user!))
          : emit(AuthError(message: authResult.message ?? 'Erro no login')),
    );
  }

  /// 5. PROCESSO DE REGISTRO - Handler para evento de registro
  Future<void> _handleRegister(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (!_isValidRegisterParams(event.params)) {
      emit(const AuthError(message: 'Todos os campos são obrigatórios'));
      return;
    }

    emit(const AuthLoading(message: 'Criando conta...'));

    final result = await _registerUseCase(event.params);

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (authResult) => authResult.success && authResult.user != null
          ? emit(AuthSuccess(
        message: 'Conta criada com sucesso! Faça login para continuar.',
        user: authResult.user,
      ))
          : emit(AuthError(message: authResult.message ?? 'Erro no cadastro')),
    );
  }

  /// 6. PROCESSO DE LOGOUT - Handler para evento de logout
  Future<void> _handleLogout(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _logoutUseCase(NoParams());
    // O stream automaticamente emitirá AuthUnauthenticated
  }

  /// 7. MUDANÇA DE ESTADO AUTOMÁTICA - Handler para mudanças do Firebase
  void _handleAuthStateChange(
      AuthStateChanged event,
      Emitter<AuthState> emit,
      ) {
    event.user != null
        ? emit(AuthAuthenticated(user: event.user!))
        : emit(const AuthUnauthenticated());
  }

  /// VALIDAÇÕES - Métodos auxiliares para validação de parâmetros
  bool _isValidLoginParams(LoginParams params) =>
      params.email.isNotEmpty && params.password.isNotEmpty;

  bool _isValidRegisterParams(RegisterParams params) =>
      params.email.isNotEmpty &&
          params.password.isNotEmpty &&
          params.confirmPassword.isNotEmpty;

  @override
  Future<void> close() {
    _authStatusSubscription?.cancel();
    return super.close();
  }
}