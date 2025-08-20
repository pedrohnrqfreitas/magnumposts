import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/data/authentication/models/auth_result_model.dart';
import 'package:magnumposts/data/authentication/models/params/login_params.dart';
import 'package:magnumposts/data/authentication/models/user_model.dart';
import 'package:magnumposts/data/authentication/repositories/i_auth_repository.dart';
import 'package:magnumposts/features/authentication/usercase/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  group('LoginUseCase', () {
    final tLoginParams = LoginParams(
      email: 'test@example.com',
      password: 'password123',
    );

    final tUserModel = UserModel(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      emailVerified: true,
      createdAt: DateTime.now(),
    );

    final tAuthResult = AuthResultModel.success(tUserModel);

    test('should return AuthResultModel when login is successful', () async {
      // arrange
      when(() => mockRepository.login(tLoginParams))
          .thenAnswer((_) async => ResultData.success(tAuthResult));

      // act
      final result = await useCase(tLoginParams);

      // assert
      expect(result, isA<ResultData<Failure, AuthResultModel>>());
      expect(result.isSuccess, true);

      result.fold(
            (failure) => fail('Should not return failure'),
            (authResult) {
          expect(authResult.success, true);
          expect(authResult.user, equals(tUserModel));
        },
      );

      verify(() => mockRepository.login(tLoginParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when login fails', () async {
      // arrange
      final tFailure = Failure(message: 'Invalid credentials');
      when(() => mockRepository.login(tLoginParams))
          .thenAnswer((_) async => ResultData.error(tFailure));

      // act
      final result = await useCase(tLoginParams);

      // assert
      expect(result, isA<ResultData<Failure, AuthResultModel>>());
      expect(result.isSuccess, false);

      result.fold(
            (failure) => expect(failure.message, 'Invalid credentials'),
            (authResult) => fail('Should not return success'),
      );

      verify(() => mockRepository.login(tLoginParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
