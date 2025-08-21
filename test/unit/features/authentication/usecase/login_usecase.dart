import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/features/authentication/usercase/login_usecase.dart';
import 'package:magnumposts/data/authentication/models/params/login_params.dart';
import 'package:magnumposts/data/authentication/models/auth_result_model.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(repository: mockRepository);
      setupMocktailFallbacks();
    });

    group('call', () {
      test('should return successful AuthResultModel when login succeeds', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(authResult));
        expect(result.success!.success, isTrue);
        expect(result.success!.user, isNotNull);
        expect(result.success!.user!.email, equals(MockData.testEmail));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should return Failure when repository login fails', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: 'wrong_password',
        );
        final failure = Failure(message: 'Invalid credentials', code: 'wrong-password');

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));
        expect(result.failure!.message, equals('Invalid credentials'));
        expect(result.failure!.code, equals('wrong-password'));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should return failed AuthResultModel when login is unsuccessful', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final authResult = AuthResultModel.error('Login failed');

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(authResult));
        expect(result.success!.success, isFalse);
        expect(result.success!.user, isNull);
        expect(result.success!.message, equals('Login failed'));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should handle network failures correctly', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final failure = Failure(
          message: 'No internet connection',
          code: 'network_error',
        );

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('No internet connection'));
        expect(result.failure!.code, equals('network_error'));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should handle various authentication errors', () async {
        // Arrange & Act & Assert for different error scenarios
        final testCases = [
          {
            'params': LoginParams(email: 'invalid@email', password: MockData.testPassword),
            'failure': Failure(message: 'Invalid email format', code: 'invalid-email'),
          },
          {
            'params': LoginParams(email: MockData.testEmail, password: ''),
            'failure': Failure(message: 'Password is required', code: 'missing-password'),
          },
          {
            'params': LoginParams(email: 'user@notfound.com', password: MockData.testPassword),
            'failure': Failure(message: 'User not found', code: 'user-not-found'),
          },
        ];

        for (final testCase in testCases) {
          final params = testCase['params'] as LoginParams;
          final failure = testCase['failure'] as Failure;

          when(() => mockRepository.login(params))
              .thenAnswer((_) async => ResultData.error(failure));

          final result = await useCase(params);

          expect(result.isError, isTrue);
          expect(result.failure!.message, equals(failure.message));
          expect(result.failure!.code, equals(failure.code));
        }
      });
    });

    group('Edge cases', () {
      test('should handle empty email', () async {
        // Arrange
        final params = LoginParams(email: '', password: MockData.testPassword);
        final failure = Failure(message: 'Email is required');

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Email is required'));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should handle empty password', () async {
        // Arrange
        final params = LoginParams(email: MockData.testEmail, password: '');
        final failure = Failure(message: 'Password is required');

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Password is required'));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should handle extremely long email and password', () async {
        // Arrange
        final longEmail = '${'a' * 100}@${'b' * 100}.com';
        final longPassword = 'c' * 200;
        final params = LoginParams(email: longEmail, password: longPassword);
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(() => mockRepository.login(params)).called(1);
      });

      test('should handle special characters in credentials', () async {
        // Arrange
        final params = LoginParams(
          email: 'test+123@email-test.co.uk',
          password: 'P@ssw0rd!#\$%^&*()',
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.login(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(() => mockRepository.login(params)).called(1);
      });
    });

    group('Performance and timing', () {
      test('should handle slow network responses', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.login(params)).thenAnswer((_) async {
          // Simula resposta lenta
          await Future.delayed(const Duration(milliseconds: 100));
          return ResultData.success(authResult);
        });

        // Act
        final stopwatch = Stopwatch()..start();
        final result = await useCase(params);
        stopwatch.stop();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));

        verify(() => mockRepository.login(params)).called(1);
      });

      test('should handle timeout scenarios', () async {
        // Arrange
        final params = LoginParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
        );
        final failure = Failure(message: 'Request timeout', code: 'timeout');

        when(() => mockRepository.login(params)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return ResultData.error(failure);
        });

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Request timeout'));
        expect(result.failure!.code, equals('timeout'));

        verify(() => mockRepository.login(params)).called(1);
      });
    });
  });
}