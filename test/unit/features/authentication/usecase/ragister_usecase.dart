import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/features/authentication/usercase/register_usecase.dart';
import 'package:magnumposts/data/authentication/models/params/register_params.dart';
import 'package:magnumposts/data/authentication/models/auth_result_model.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('RegisterUseCase', () {
    late RegisterUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = RegisterUseCase(repository: mockRepository);
      setupMocktailFallbacks();
    });

    group('call - Successful registration', () {
      test('should return successful AuthResultModel when registration succeeds', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
          displayName: MockData.testDisplayName,
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(authResult));
        expect(result.success!.success, isTrue);
        expect(result.success!.user, isNotNull);
        expect(result.success!.user!.email, equals(MockData.testEmail));

        verify(() => mockRepository.register(params)).called(1);
      });

      test('should succeed with minimal required fields', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.success, isTrue);

        verify(() => mockRepository.register(params)).called(1);
      });
    });

    group('call - Validation failures', () {
      test('should return Failure when email is empty', () async {
        // Arrange
        final params = RegisterParams(
          email: '',
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Todos os campos são obrigatórios'));

        verifyNever(() => mockRepository.register(any()));
      });

      test('should return Failure when password is empty', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: '',
          confirmPassword: '',
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Todos os campos são obrigatórios'));

        verifyNever(() => mockRepository.register(any()));
      });

      test('should return Failure when confirmPassword is empty', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: '',
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Todos os campos são obrigatórios'));

        verifyNever(() => mockRepository.register(any()));
      });

      test('should return Failure when email format is invalid', () async {
        // Arrange
        final invalidEmails = [
          'invalid-email',
          '@gmail.com',
          'test@',
          'test@.com',
          'test.gmail.com',
          'test@gmail',
        ];

        for (final email in invalidEmails) {
          final params = RegisterParams(
            email: email,
            password: MockData.testPassword,
            confirmPassword: MockData.testPassword,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isError, isTrue, reason: 'Failed for email: $email');
          expect(result.failure!.message, equals('Por favor, insira um email válido'));

          verifyNever(() => mockRepository.register(any()));
        }
      });

      test('should return Failure when password is too short', () async {
        // Arrange
        final shortPasswords = ['1', '12', '123', '1234', '12345'];

        for (final password in shortPasswords) {
          final params = RegisterParams(
            email: MockData.testEmail,
            password: password,
            confirmPassword: password,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isError, isTrue, reason: 'Failed for password: $password');
          expect(result.failure!.message, equals('Senha deve ter pelo menos 6 caracteres'));

          verifyNever(() => mockRepository.register(any()));
        }
      });

      test('should return Failure when passwords do not match', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: 'different_password',
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Senhas não coincidem'));

        verifyNever(() => mockRepository.register(any()));
      });
    });

    group('call - Repository failures', () {
      test('should return Failure when repository registration fails', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );
        final failure = Failure(message: 'Email already in use', code: 'email-already-in-use');

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));
        expect(result.failure!.message, equals('Email already in use'));
        expect(result.failure!.code, equals('email-already-in-use'));

        verify(() => mockRepository.register(params)).called(1);
      });

      test('should return failed AuthResultModel when registration is unsuccessful', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );
        final authResult = AuthResultModel.error('Registration failed');

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(authResult));
        expect(result.success!.success, isFalse);
        expect(result.success!.message, equals('Registration failed'));

        verify(() => mockRepository.register(params)).called(1);
      });
    });

    group('Edge cases and validation combinations', () {
      test('should accept valid email formats', () async {
        // Arrange
        final validEmails = [
          'test@gmail.com',
          'user.name@domain.co.uk',
          'test+123@email.org',
          'valid@sub.domain.com',
          'user_name@domain-name.com',
        ];

        for (final email in validEmails) {
          final params = RegisterParams(
            email: email,
            password: MockData.testPassword,
            confirmPassword: MockData.testPassword,
          );
          final authResult = AuthResultModel.success(MockData.userModel);

          when(() => mockRepository.register(params))
              .thenAnswer((_) async => ResultData.success(authResult));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isSuccess, isTrue, reason: 'Failed for email: $email');

          verify(() => mockRepository.register(params)).called(1);
        }
      });

      test('should accept password with minimum length', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: '123456', // Exactly 6 characters
          confirmPassword: '123456',
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);

        verify(() => mockRepository.register(params)).called(1);
      });

      test('should handle special characters in password', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: 'P@ssw0rd!#\$%^&*()',
          confirmPassword: 'P@ssw0rd!#\$%^&*()',
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);

        verify(() => mockRepository.register(params)).called(1);
      });

      test('should handle very long display names', () async {
        // Arrange
        final params = RegisterParams(
          email: MockData.testEmail,
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
          displayName: 'A' * 100, // Very long name
        );
        final authResult = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.register(params))
            .thenAnswer((_) async => ResultData.success(authResult));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);

        verify(() => mockRepository.register(params)).called(1);
      });

      test('should handle multiple validation errors in sequence', () async {
        // Test multiple invalid scenarios
        final invalidParams = [
          RegisterParams(email: '', password: '', confirmPassword: ''),
          RegisterParams(email: 'invalid', password: '123', confirmPassword: '456'),
          RegisterParams(email: 'test@test.com', password: 'short', confirmPassword: 'different'),
        ];

        for (final params in invalidParams) {
          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isError, isTrue);

          // Verify repository was never called for invalid params
          verifyNever(() => mockRepository.register(params));
        }
      });
    });

    group('Complex scenarios', () {
      test('should handle concurrent registrations', () async {
        // Arrange
        final params1 = RegisterParams(
          email: 'user1@test.com',
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );
        final params2 = RegisterParams(
          email: 'user2@test.com',
          password: MockData.testPassword,
          confirmPassword: MockData.testPassword,
        );

        final authResult1 = AuthResultModel.success(MockData.userModel);
        final authResult2 = AuthResultModel.success(MockData.userModel);

        when(() => mockRepository.register(params1))
            .thenAnswer((_) async => ResultData.success(authResult1));
        when(() => mockRepository.register(params2))
            .thenAnswer((_) async => ResultData.success(authResult2));

        // Act
        final futures = [
          useCase(params1),
          useCase(params2),
        ];
        final results = await Future.wait(futures);

        // Assert
        expect(results[0].isSuccess, isTrue);
        expect(results[1].isSuccess, isTrue);

        verify(() => mockRepository.register(params1)).called(1);
        verify(() => mockRepository.register(params2)).called(1);
      });
    });
  });
}