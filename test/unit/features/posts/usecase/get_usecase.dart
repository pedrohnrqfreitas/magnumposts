import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/features/posts/usecase/get_posts_usecase.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('GetPostsUseCase', () {
    late GetPostsUseCase useCase;
    late MockPostsRepository mockRepository;

    setUp(() {
      mockRepository = MockPostsRepository();
      useCase = GetPostsUseCase(repository: mockRepository);
      setupMocktailFallbacks();
    });

    group('call', () {
      test('should return list of PostModel when repository call succeeds', () async {
        // Arrange
        final params = GetPostsParams(page: 1, limit: 10);
        final posts = MockData.postModelList;

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(posts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(posts));
        expect(result.success!.length, equals(posts.length));

        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      });

      test('should return empty list when repository returns empty list', () async {
        // Arrange
        final params = GetPostsParams(page: 1, limit: 10);
        final emptyPosts = <PostModel>[];

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(emptyPosts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(emptyPosts));
        expect(result.success!.isEmpty, isTrue);

        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      });

      test('should return Failure when repository call fails', () async {
        // Arrange
        final params = GetPostsParams(page: 1, limit: 10);
        final failure = Failure(message: 'Network error');

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));
        expect(result.failure!.message, equals('Network error'));

        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      });

      test('should use default parameters when not specified', () async {
        // Arrange
        final params = GetPostsParams(); // Usa valores padrão: page=1, limit=10
        final posts = MockData.postModelList;

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(posts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      });

      test('should pass custom parameters correctly', () async {
        // Arrange
        final params = GetPostsParams(page: 3, limit: 20);
        final posts = MockData.createPostsList(15);

        when(() => mockRepository.getPosts(page: 3, limit: 20))
            .thenAnswer((_) async => ResultData.success(posts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, equals(posts));

        verify(() => mockRepository.getPosts(page: 3, limit: 20)).called(1);
      });

      test('should handle large page numbers correctly', () async {
        // Arrange
        final params = GetPostsParams(page: 100, limit: 5);
        final emptyPosts = <PostModel>[];

        when(() => mockRepository.getPosts(page: 100, limit: 5))
            .thenAnswer((_) async => ResultData.success(emptyPosts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.isEmpty, isTrue);

        verify(() => mockRepository.getPosts(page: 100, limit: 5)).called(1);
      });

      test('should handle different failure scenarios', () async {
        // Arrange
        final params = GetPostsParams(page: 1, limit: 10);
        final networkFailure = Failure(message: 'No internet connection', code: 'network_error');

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.error(networkFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('No internet connection'));
        expect(result.failure!.code, equals('network_error'));

        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      });
    });

    group('Edge cases', () {
      test('should handle zero limit gracefully', () async {
        // Arrange
        final params = GetPostsParams(page: 1, limit: 0);
        final emptyPosts = <PostModel>[];

        when(() => mockRepository.getPosts(page: 1, limit: 0))
            .thenAnswer((_) async => ResultData.success(emptyPosts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.isEmpty, isTrue);

        verify(() => mockRepository.getPosts(page: 1, limit: 0)).called(1);
      });

      test('should handle zero page gracefully', () async {
        // Arrange
        final params = GetPostsParams(page: 0, limit: 10);
        final posts = MockData.postModelList;

        when(() => mockRepository.getPosts(page: 0, limit: 10))
            .thenAnswer((_) async => ResultData.success(posts));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isSuccess, isTrue);

        verify(() => mockRepository.getPosts(page: 0, limit: 10)).called(1);
      });

      test('should handle negative parameters', () async {
        // Arrange
        final params = GetPostsParams(page: -1, limit: -5);
        final failure = Failure(message: 'Invalid parameters');

        when(() => mockRepository.getPosts(page: -1, limit: -5))
            .thenAnswer((_) async => ResultData.error(failure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Invalid parameters'));

        verify(() => mockRepository.getPosts(page: -1, limit: -5)).called(1);
      });
    });
  });
}