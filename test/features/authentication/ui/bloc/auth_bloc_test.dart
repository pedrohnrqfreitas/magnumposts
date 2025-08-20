import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/core/usecase.dart';
import 'package:magnumposts/data/authentication/models/auth_result_model.dart';
import 'package:magnumposts/data/authentication/models/params/login_params.dart';
import 'package:magnumposts/data/authentication/models/user_model.dart';
import 'package:magnumposts/features/authentication/usercase/check_auth_status_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/get_current_user_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/login_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/logout_usecase.dart';
import 'package:magnumposts/features/authentication/usercase/register_usecase.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_bloc.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_event.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}

void main() {
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

    // Mock do stream para evitar erros
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

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    final tLoginParams = LoginParams(
      email: 'test@example.com',
      password: 'password123',
    );

    final tUser = UserModel(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      emailVerified: true,
      createdAt: DateTime.now(),
    );

    final tAuthResult = AuthResultModel.success(tUser);

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(const AuthInitial()));
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when login is successful',
        build: () {
          when(() => mockLoginUseCase(tLoginParams))
              .thenAnswer((_) async => ResultData.success(tAuthResult));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: tLoginParams)),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          AuthAuthenticated(user: tUser),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(tLoginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        build: () {
          when(() => mockLoginUseCase(tLoginParams))
              .thenAnswer((_) async => ResultData.error(
            Failure(message: 'Invalid credentials'),
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: tLoginParams)),
        expect: () => [
          const AuthLoading(message: 'Realizando login...'),
          const AuthError(message: 'Invalid credentials'),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(tLoginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthError] when email or password is empty',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthLoginRequested(
          params: LoginParams(email: '', password: 'password'),
        )),
        expect: () => [
          const AuthError(message: 'Email e senha são obrigatórios'),
        ],
        verify: (_) {
          verifyNever(() => mockLoginUseCase(any()));
        },
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when logout is successful',
        build: () {
          when(() => mockLogoutUseCase(NoParams()))
              .thenAnswer((_) async => ResultData.success(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLogoutRequested()),
        expect: () => [
          const AuthLoading(message: 'Saindo...'),
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(() => mockLogoutUseCase(NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when logout fails',
        build: () {
          when(() => mockLogoutUseCase(NoParams()))
              .thenAnswer((_) async => ResultData.error(
            Failure(message: 'Logout failed'),
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLogoutRequested()),
        expect: () => [
          const AuthLoading(message: 'Saindo...'),
          const AuthError(message: 'Logout failed'),
        ],
        verify: (_) {
          verify(() => mockLogoutUseCase(NoParams())).called(1);
        },
      );
    });
  });
}