import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/data/authentication/datasource/implementation/auth_local_datasource.dart';
import 'package:magnumposts/data/authentication/datasource/implementation/auth_remote_datasource.dart';
import 'package:magnumposts/data/authentication/dto/request/login_request_dto.dart';
import 'package:magnumposts/data/authentication/dto/response/auth_response_dto.dart';
import 'package:magnumposts/data/authentication/dto/response/user_response_dto.dart';
import 'package:magnumposts/data/authentication/models/params/login_params.dart';
import 'package:magnumposts/data/authentication/repositories/implementation/auth_repository.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

void main() {
  late AuthRepository repository;
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockAuthLocalDatasource mockLocalDatasource;

  setUp(() {
    mockRemoteDatasource = MockAuthRemoteDatasource();
    mockLocalDatasource = MockAuthLocalDatasource();
    repository = AuthRepository(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
    );
  });

  group('AuthRepository', () {
    final tLoginParams = LoginParams(
      email: 'test@example.com',
      password: 'password123',
    );

    final tLoginRequest = LoginRequestDTO(
      email: 'test@example.com',
      password: 'password123',
    );

    final tUserResponseDTO = UserResponseDTO(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      emailVerified: true,
    );

    final tAuthResponseDTO = AuthResponseDTO(
      user: tUserResponseDTO,
      success: true,
      message: 'Login successful',
    );

    group('login', () {
      test('should return AuthResultModel when login is successful', () async {
        // arrange
        when(() => mockRemoteDatasource.login(any()))
            .thenAnswer((_) async => tAuthResponseDTO);
        when(() => mockLocalDatasource.cacheUser(any()))
            .thenAnswer((_) async {});

        // act
        final result = await repository.login(tLoginParams);

        // assert
        expect(result, isA<ResultData>());
        expect(result.isSuccess, true);

        result.fold(
              (failure) => fail('Should not return failure'),
              (authResult) {
            expect(authResult.success, true);
            expect(authResult.user?.email, 'test@example.com');
          },
        );

        verify(() => mockRemoteDatasource.login(any())).called(1);
        verify(() => mockLocalDatasource.cacheUser(any())).called(1);
      });

      test('should return Failure when remote datasource throws exception', () async {
        // arrange
        when(() => mockRemoteDatasource.login(any()))
            .thenThrow(Exception('Network error'));

        // act
        final result = await repository.login(tLoginParams);

        // assert
        expect(result, isA<ResultData>());
        expect(result.isSuccess, false);

        result.fold(
              (failure) => expect(failure.message, contains('Erro inesperado no login')),
              (authResult) => fail('Should not return success'),
        );

        verify(() => mockRemoteDatasource.login(any())).called(1);
        verifyNever(() => mockLocalDatasource.cacheUser(any()));
      });
    });
  });
}
