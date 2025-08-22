import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_bloc.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_event.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_state.dart';
import 'package:magnumposts/features/authentication/usercase/login_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/register_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/logout_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/get_current_user_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/check_auth_status_usecase.dart';
import 'package:magnumposts/data/authentication/models/params/login_params.dart';
import 'package:magnumposts/data/authentication/models/params/register_params.dart';
import 'package:magnumposts/data/authentication/models/auth_result_model.dart';
import 'package:magnumposts/data/authentication/models/user_model.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/core/usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();

      // Mock do stream para evitar problemas de subscription
      when(() => mockCheckAuthStatusUseCase.execute())
          .thenAnswer((_) => Stream.value(null));

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
      );
    });

    setUpAll(() {
      registerFallbackValue(LoginParams(email: 'test', password: 'test'));
      registerFallbackValue(RegisterParams(email: 'test', password: 'test', confirmPassword: 'test'));
      registerFallbackValue(NoParams());
    });

    tearDown(() {
      authBloc.close();
    });

    test('estado inicial deve ser AuthInitial', () {
      expect(authBloc.state, equals(const AuthInitial()));
    });

    group('AuthLoginRequested', () {
      final loginParams = LoginParams(
        email: 'test@test.com',
        password: 'password123',
      );

      final mockUser = UserModel(
        uid: 'user123',
        email: 'test@test.com',
        emailVerified: true,
        createdAt: DateTime.now(),
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir [AuthLoading, AuthAuthenticated] quando login for bem-sucedido',
        build: () {
          when(() => mockLoginUseCase(loginParams))
              .thenAnswer((_) async => ResultData.success(
            AuthResultModel.success(mockUser),
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          AuthAuthenticated(user: mockUser),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(loginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir [AuthLoading, AuthError] quando login falhar',
        build: () {
          when(() => mockLoginUseCase(loginParams))
              .thenAnswer((_) async => ResultData.error(
            Failure(message: 'Email ou senha inválidos'),
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          const AuthError(message: 'Email ou senha inválidos'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir AuthError quando credenciais estiverem vazias',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthLoginRequested(
          params: LoginParams(email: '', password: ''),
        )),
        expect: () => [
          const AuthError(message: 'Email e senha são obrigatórios'),
        ],
      );
    });

    group('AuthRegisterRequested', () {
      final registerParams = RegisterParams(
        email: 'test@test.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      final mockUser = UserModel(
        uid: 'user123',
        email: 'test@test.com',
        emailVerified: false,
        createdAt: DateTime.now(),
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir [AuthLoading, AuthSuccess] quando registro for bem-sucedido',
        build: () {
          when(() => mockRegisterUseCase(registerParams))
              .thenAnswer((_) async => ResultData.success(
            AuthResultModel.success(mockUser),
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthRegisterRequested(params: registerParams)),
        expect: () => [
          const AuthLoading(message: 'Criando conta...'),
          AuthSuccess(
            message: 'Conta criada com sucesso! Faça login para continuar.',
            user: mockUser,
          ),
        ],
        verify: (_) {
          verify(() => mockRegisterUseCase(registerParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir [AuthLoading, AuthError] quando registro falhar',
        build: () {
          when(() => mockRegisterUseCase(registerParams))
              .thenAnswer((_) async => ResultData.error(
            Failure(message: 'Email já está em uso'),
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthRegisterRequested(params: registerParams)),
        expect: () => [
          const AuthLoading(message: 'Criando conta...'),
          const AuthError(message: 'Email já está em uso'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir AuthError quando campos obrigatórios estiverem vazios',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthRegisterRequested(
          params: RegisterParams(email: '', password: '', confirmPassword: ''),
        )),
        expect: () => [
          const AuthError(message: 'Todos os campos são obrigatórios'),
        ],
      );
    });

    group('AuthCheckStatusRequested', () {
      final mockUser = UserModel(
        uid: 'user123',
        email: 'test@test.com',
        emailVerified: true,
        createdAt: DateTime.now(),
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir [AuthLoading, AuthAuthenticated] quando usuário estiver logado',
        build: () {
          when(() => mockGetCurrentUserUseCase(NoParams()))
              .thenAnswer((_) async => ResultData.success(mockUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [
          const AuthLoading(message: 'Verificando autenticação...'),
          AuthAuthenticated(user: mockUser),
        ],
        verify: (_) {
          verify(() => mockGetCurrentUserUseCase(NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir [AuthLoading, AuthUnauthenticated] quando usuário não estiver logado',
        build: () {
          when(() => mockGetCurrentUserUseCase(NoParams()))
              .thenAnswer((_) async => ResultData.success(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [
          const AuthLoading(message: 'Verificando autenticação...'),
          const AuthUnauthenticated(),
        ],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'deve chamar logout use case',
        build: () {
          when(() => mockLogoutUseCase(NoParams()))
              .thenAnswer((_) async => ResultData.success(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLogoutRequested()),
        expect: () => [],
        verify: (_) {
          verify(() => mockLogoutUseCase(NoParams())).called(1);
        },
      );
    });

    group('AuthStateChanged', () {
      final mockUser = UserModel(
        uid: 'user123',
        email: 'test@test.com',
        emailVerified: true,
        createdAt: DateTime.now(),
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir AuthAuthenticated quando usuário não for null',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthStateChanged(user: mockUser)),
        expect: () => [
          AuthAuthenticated(user: mockUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'deve emitir AuthUnauthenticated quando usuário for null',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthStateChanged(user: null)),
        expect: () => [
          const AuthUnauthenticated(),
        ],
      );
    });
  });
}