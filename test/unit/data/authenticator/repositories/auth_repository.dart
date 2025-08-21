import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/data/authentication/repositories/implementation/auth_repository.dart';
import 'package:magnumposts/data/authentication/models/params/login_params.dart';
import 'package:magnumposts/data/authentication/models/params/register_params.dart';
import 'package:magnumposts/data/authentication/models/params/update_profile_params.dart';
import 'package:magnumposts/data/authentication/models/auth_result_model.dart';
import 'package:magnumposts/data/authentication/models/user_model.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('AuthRepository', () {
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
      setupMocktailFallbacks();
    });

    group('authStateChanges', () {
      test('should return stream of UserModel and cache user when authenticated', () async {
        // Arrange
        final userDTO = MockData.userResponseDTO;
        final userStream = Stream.fromIterable([null, userDTO, null]);

        when(() => mockRemoteDatasource.authStateChanges).thenAnswer((_) => userStream);
        when(() => mockLocalDatasource.cacheUser(any())).thenAnswer((_) async {});
        when(() => mockLocalDatasource.clearCache()).thenAnswer((_) async {});

        // Act
        final result = repository.authStateChanges;
        final states = await result.take(3).toList();

        // Assert
        expect(states.length, equals(3));
        expect(states[0], isNull);
        expect(states[1], isNotNull);
        expect(states[1]!.uid, equals(userDTO.uid));
        expect(states[2], isNull);

        verify(() => mockLocalDatasource.cacheUser(any())).called(1);
        verify(() => mockLocalDatasource.clearCache()).called(1);
      });
    });

    group('currentUser', () {
      test('should return UserModel when user is authenticated', () {
        // Arrange
        final userDTO = MockData.userResponseDTO;
        when(() => mockRemoteDatasource.currentUser).thenReturn(userDTO);

        // Act
        final result = repository.currentUser;

        // Assert
        expect(result, isNotNull);
        expect(result!.uid, equals(userDTO.uid));
        expect(result.email, equals(userDTO.email));

        verify(() => mockRemoteDatasource.currentUser).called(1);
      });

      test('should return null when user is not authenticated', () {
        // Arrange
        when(() => mockRemoteDatasource.currentUser).thenReturn(null);

        // Act
        final result = repository.currentUser;

        // Assert
        expect(result, isNull);
        verify(() => mockRemoteDatasource.currentUser).called(1);
      });
    });

    group('login', () {
      test('should return successful AuthResultModel when login succeeds', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final authResponse = MockData.successAuthResponse;

        when(() => mockRemoteDatasource.login(any()))
            .thenAnswer((_) async => authResponse);
        when(() => mockLocalDatasource.cacheUser(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.login(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.success, isTrue);
        expect(result.success!.user, isNotNull);
        expect(result.success!.user!.email, equals(MockData.testEmail));

        verify(() => mockRemoteDatasource.login(any())).called(1);
        verify(() => mockLocalDatasource.cacheUser(any())).called(1);
      });

      test('should return failure when login fails', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: 'wrong_password',
        );
        final authResponse = MockData.failureAuthResponse;

        when(() => mockRemoteDatasource.login(any()))
            .thenAnswer((_) async => authResponse);

        // Act
        final result = await repository.login(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isNotNull);
        expect(result.failure!.message, equals(authResponse.message));

        verify(() => mockRemoteDatasource.login(any())).called(1);
        verifyNever(() => mockLocalDatasource.cacheUser(any()));
      });

      test('should return failure when datasource throws Failure', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final failure = Failure(message: 'Network error');

        when(() => mockRemoteDatasource.login(any()))
            .thenThrow(failure);

        // Act
        final result = await repository.login(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockRemoteDatasource.login(any())).called(1);
      });

      test('should return failure when datasource throws generic exception', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final exception = Exception('Unexpected error');

        when(() => mockRemoteDatasource.login(any()))
            .thenThrow(exception);

        // Act
        final result = await repository.login(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isNotNull);
        expect(result.failure!.message, contains('Erro inesperado no login'));

        verify(() => mockRemoteDatasource.login(any())).called(1);
      });
    });

    group('register', () {
      test('should return successful AuthResultModel when registration succeeds', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
          displayName: MockData.testDisplayName,
        );
        final authResponse = MockData.successAuthResponse;

        when(() => mockRemoteDatasource.register(any()))
            .thenAnswer((_) async => authResponse);
        when(() => mockLocalDatasource.cacheUser(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.register(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.success, isTrue);
        expect(result.success!.user, isNotNull);
        expect(result.success!.user!.email, equals(MockData.testEmail));

        verify(() => mockRemoteDatasource.register(any())).called(1);
        verify(() => mockLocalDatasource.cacheUser(any())).called(1);
      });

      test('should return failure when registration fails', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );
        final authResponse = AuthResultModel.error('Email already in use');

        when(() => mockRemoteDatasource.register(any()))
            .thenAnswer((_) async => authResponse.toDTO());

        // Act
        final result = await repository.register(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isNotNull);
        expect(result.failure!.message, contains('Email already in use'));

        verify(() => mockRemoteDatasource.register(any())).called(1);
        verifyNever(() => mockLocalDatasource.cacheUser(any()));
      });
    });

    group('logout', () {
      test('should complete successfully when logout succeeds', () async {
        // Arrange
        when(() => mockRemoteDatasource.logout()).thenAnswer((_) async {});
        when(() => mockLocalDatasource.logout()).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isSuccess, isTrue);

        verify(() => mockRemoteDatasource.logout()).called(1);
        verify(() => mockLocalDatasource.logout()).called(1);
      });

      test('should return failure when logout fails', () async {
        // Arrange
        final failure = Failure(message: 'Logout failed');

        when(() => mockRemoteDatasource.logout()).thenThrow(failure);

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockRemoteDatasource.logout()).called(1);
      });
    });

    group('updateProfile', () {
      test('should return updated UserModel when update succeeds', () async {
        // Arrange
        final params = UpdateProfileParams(
          displayName: 'Updated Name',
          photoURL: 'https://example.com/new-photo.jpg',
        );
        final updatedUserDTO = MockData.userResponseDTO.copyWith(
          displayName: 'Updated Name',
          photoURL: 'https://example.com/new-photo.jpg',
        );

        when(() => mockRemoteDatasource.updateProfile(any()))
            .thenAnswer((_) async => updatedUserDTO);
        when(() => mockLocalDatasource.cacheUser(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.updateProfile(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.displayName, equals('Updated Name'));

        verify(() => mockRemoteDatasource.updateProfile(any())).called(1);
        verify(() => mockLocalDatasource.cacheUser(any())).called(1);
      });

      test('should return failure when update fails', () async {
        // Arrange
        final params = UpdateProfileParams(displayName: 'Updated Name');
        final failure = Failure(message: 'Update failed');

        when(() => mockRemoteDatasource.updateProfile(any()))
            .thenThrow(failure);

        // Act
        final result = await repository.updateProfile(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockRemoteDatasource.updateProfile(any())).called(1);
      });
    });

    group('getCachedUser', () {
      test('should return cached UserModel when available', () async {
        // Arrange
        final userDTO = MockData.userResponseDTO;
        when(() => mockLocalDatasource.getCachedUser())
            .thenAnswer((_) async => userDTO);

        // Act
        final result = await repository.getCachedUser();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.uid, equals(userDTO.uid));

        verify(() => mockLocalDatasource.getCachedUser()).called(1);
      });

      test('should return null when no cached user', () async {
        // Arrange
        when(() => mockLocalDatasource.getCachedUser())
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getCachedUser();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNull);

        verify(() => mockLocalDatasource.getCachedUser()).called(1);
      });

      test('should return failure when cache access fails', () async {
        // Arrange
        final failure = Failure(message: 'Cache error');
        when(() => mockLocalDatasource.getCachedUser())
            .thenThrow(failure);

        // Act
        final result = await repository.getCachedUser();

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockLocalDatasource.getCachedUser()).called(1);
      });
    });
  });
}

extension on AuthResultModel {
  MockData.AuthResponseDTO toDTO() {
    return MockData.AuthResponseDTO(
      user: user?.toDTO(),
      success: success,
      message: message,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}