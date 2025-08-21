import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/core/usecase.dart';
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

import '../../../../../helpers/test_helpers.dart';
import '../../../../../helpers/mock_data.dart';

// Mocks dos Use Cases
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}

void main() {
  group('AuthBloc', () {
    late AuthBloc bloc;
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

      // Configura o stream do auth status como vazio por padrão
      when(() => mockCheckAuthStatusUseCase.execute())
          .thenAnswer((_) => const Stream.empty());

      bloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
      );

      setupMocktailFallbacks();

      // Registra fallbacks
      registerFallbackValue(LoginParams(email: '', password: ''));
      registerFallbackValue(RegisterParams(email: '', password: '', confirmPassword: ''));
      registerFallbackValue(NoParams());
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be AuthInitial', () {
      expect(bloc.state, equals(const AuthInitial()));
    });

    group('AuthCheckStatusRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when user is found',
        build: () {
          final user = MockData.userModel;
          when(() => mockGetCurrentUserUseCase(any()))
              .thenAnswer((_) async => ResultData.success(user));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [
          const AuthLoading(message: 'Verificando autenticação...'),
          AuthAuthenticated(user: MockData.userModel),
        ],
        verify: (_) {
          verify(() => mockGetCurrentUserUseCase(any())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when no user found',
        build: () {
          when(() => mockGetCurrentUserUseCase(any()))
              .thenAnswer((_) async => ResultData.success(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [
          const AuthLoading(message: 'Verificando autenticação...'),
          const AuthUnauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when check fails',
        build: () {
          final failure = Failure(message: 'Check failed');
          when(() => mockGetCurrentUserUseCase(any()))
              .thenAnswer((_) async => ResultData.error(failure));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [
          const AuthLoading(message: 'Verificando autenticação...'),
          const AuthUnauthenticated(),
        ],
      );
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          final params = LoginParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
          );
          final authResult = AuthResultModel.success(MockData.userModel);

          when(() => mockLoginUseCase(params))
              .thenAnswer((_) async => ResultData.success(authResult));

          return bloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(
          params: LoginParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
          ),
        )),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          AuthAuthenticated(user: MockData.userModel),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        build: () {
          final params = LoginParams(
            email: MockData.testEmail,
            password: 'wrong_password',
          );
          final failure = Failure(message: 'Invalid credentials');

          when(() => mockLoginUseCase(params))
              .thenAnswer((_) async => ResultData.error(failure));

          return bloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: LoginParams(
          email: MockData.testEmail,
          password: 'wrong_password',
        ))),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          const AuthError(message: 'Invalid credentials'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthError] when login params are invalid',
        build: () => bloc,
        act: (bloc) => bloc.add(AuthLoginRequested(params: LoginParams(
          email: '',
          password: '',
        ))),
        expect: () => [
          const AuthError(message: 'Email e senha são obrigatórios'),
        ],
        verify: (_) {
          verifyNever(() => mockLoginUseCase(any()));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when auth result is unsuccessful',
        build: () {
          final params = LoginParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
          );
          final authResult = AuthResultModel.error('Login failed');

          when(() => mockLoginUseCase(params))
              .thenAnswer((_) async => ResultData.success(authResult));

          return bloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        ))),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          const AuthError(message: 'Login failed'),
        ],
      );
    });

    group('AuthRegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthSuccess] when registration succeeds',
        build: () {
          final params = RegisterParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
            confirmPassword: MockData.testPassword,
            displayName: MockData.testDisplayName,
          );
          final authResult = AuthResultModel.success(MockData.userModel);

          when(() => mockRegisterUseCase(params))
              .thenAnswer((_) async => ResultData.success(authResult));

          return bloc;
        },
        act: (bloc) => bloc.add(AuthRegisterRequested(params: RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
          displayName: MockData.testDisplayName,
        ))),
        expect: () => [
          const AuthLoading(message: 'Criando conta...'),
          AuthSuccess(
            message: 'Conta criada com sucesso! Faça login para continuar.',
            user: MockData.userModel,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when registration fails',
        build: () {
          final params = RegisterParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
            confirmPassword: MockData.testPassword,
          );
          final failure = Failure(message: 'Email already in use');

          when(() => mockRegisterUseCase(params))
              .thenAnswer((_) async => ResultData.error(failure));

          return bloc;
        },
        act: (bloc) => bloc.add(AuthRegisterRequested(params: RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        ))),
        expect: () => [
          const AuthLoading(message: 'Criando conta...'),
          const AuthError(message: 'Email already in use'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthError] when registration params are invalid',
        build: () => bloc,
        act: (bloc) => bloc.add(AuthRegisterRequested(params: RegisterParams(
          email: '',
          password: '',
          confirmPassword: '',
        ))),
        expect: () => [
          const AuthError(message: 'Todos os campos são obrigatórios'),
        ],
        verify: (_) {
          verifyNever(() => mockRegisterUseCase(any()));
        },
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should call logout use case when logout is requested',
        build: () {
          when(() => mockLogoutUseCase(any()))
              .thenAnswer((_) async => ResultData.success(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthLogoutRequested()),
        verify: (_) {
          verify(() => mockLogoutUseCase(any())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should not emit states directly on logout - state change comes from stream',
        build: () {
          when(() => mockLogoutUseCase(any()))
              .thenAnswer((_) async => ResultData.success(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthLogoutRequested()),
        expect: () => [],
      );
    });

    group('AuthStateChanged', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthAuthenticated] when user is provided',
        build: () => bloc,
        act: (bloc) => bloc.add(AuthStateChanged(user: MockData.userModel)),
        expect: () => [
          AuthAuthenticated(user: MockData.userModel),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthUnauthenticated] when user is null',
        build: () => bloc,
        act: (bloc) => bloc.add(const AuthStateChanged(user: null)),
        expect: () => [
          const AuthUnauthenticated(),
        ],
      );
    });

    group('Auth state stream integration', () {
      blocTest<AuthBloc, AuthState>(
        'should emit states based on auth stream changes',
        build: () {
          final user = MockData.userModel;
          final authStream = Stream.fromIterable([null, user, null]);

          when(() => mockCheckAuthStatusUseCase.execute())
              .thenAnswer((_) => authStream);

          return AuthBloc(
            loginUseCase: mockLoginUseCase,
            registerUseCase: mockRegisterUseCase,
            logoutUseCase: mockLogoutUseCase,
            getCurrentUserUseCase: mockGetCurrentUserUseCase,
            checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
          );
        },
        expect: () => [
          const AuthUnauthenticated(),
          AuthAuthenticated(user: MockData.userModel),
          const AuthUnauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'should handle auth stream errors gracefully',
        build: () {
          final authStream = Stream<UserModel?>.error(Exception('Stream error'));

          when(() => mockCheckAuthStatusUseCase.execute())
              .thenAnswer((_) => authStream);

          return AuthBloc(
            loginUseCase: mockLoginUseCase,
            registerUseCase: mockRegisterUseCase,
            logoutUseCase: mockLogoutUseCase,
            getCurrentUserUseCase: mockGetCurrentUserUseCase,
            checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
          );
        },
        expect: () => [
          const AuthUnauthenticated(),
        ],
      );
    });

    group('Complex scenarios', () {
      blocTest<AuthBloc, AuthState>(
        'should handle sequence: check status -> login -> logout correctly',
        build: () {
          // Setup para diferentes chamadas
          when(() => mockGetCurrentUserUseCase(any()))
              .thenAnswer((_) async => ResultData.success(null));

          final loginParams = LoginParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
          );
          final authResult = AuthResultModel.success(MockData.userModel);

          when(() => mockLoginUseCase(loginParams))
              .thenAnswer((_) async => ResultData.success(authResult));

          when(() => mockLogoutUseCase(any()))
              .thenAnswer((_) async => ResultData.success(null));

          return bloc;
        },
        act: (bloc) async {
          bloc.add(const AuthCheckStatusRequested());
          await Future.delayed(const Duration(milliseconds: 10));
          bloc.add(AuthLoginRequested(params: LoginParams(
            email: MockData.testEmail,
            password: MockData.testPassword,
          )));
          await Future.delayed(const Duration(milliseconds: 10));
          bloc.add(const AuthLogoutRequested());
        },
        expect: () => [
          const AuthLoading(message: 'Verificando autenticação...'),
          const AuthUnauthenticated(),
          const AuthLoading(message: 'Realizando login...'),
          AuthAuthenticated(user: MockData.userModel),
        ],
      );
    });
  });
}