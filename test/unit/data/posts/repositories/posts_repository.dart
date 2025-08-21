import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/data/posts/repository/implementation/posts_repository.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/data/posts/models/user_post_model.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('PostsRepository', () {
    late PostsRepository repository;
    late MockPostsDatasource mockDatasource;

    setUp(() {
      mockDatasource = MockPostsDatasource();
      repository = PostsRepository(remoteDatasource: mockDatasource);
      setupMocktailFallbacks();
    });

    group('getPosts', () {
      test('should return list of PostModel when datasource call succeeds', () async {
        // Arrange
        const page = 1;
        const limit = 10;
        final postsDTO = MockData.postsResponseDTOList;
        final expectedPosts = MockData.postModelList;

        when(() => mockDatasource.getPosts(page: page, limit: limit))
            .thenAnswer((_) async => postsDTO);

        // Act
        final result = await repository.getPosts(page: page, limit: limit);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.length, equals(expectedPosts.length));

        // Verifica se os dados foram convertidos corretamente
        for (int i = 0; i < expectedPosts.length; i++) {
          expect(result.success![i].id, equals(expectedPosts[i].id));
          expect(result.success![i].title, equals(expectedPosts[i].title));
          expect(result.success![i].body, equals(expectedPosts[i].body));
          expect(result.success![i].userId, equals(expectedPosts[i].userId));
        }

        verify(() => mockDatasource.getPosts(page: page, limit: limit)).called(1);
      });

      test('should return empty list when datasource returns empty list', () async {
        // Arrange
        const page = 1;
        const limit = 10;

        when(() => mockDatasource.getPosts(page: page, limit: limit))
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getPosts(page: page, limit: limit);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.isEmpty, isTrue);

        verify(() => mockDatasource.getPosts(page: page, limit: limit)).called(1);
      });

      test('should return Failure when datasource throws Failure', () async {
        // Arrange
        const page = 1;
        const limit = 10;
        final failure = Failure(message: 'Network error');

        when(() => mockDatasource.getPosts(page: page, limit: limit))
            .thenThrow(failure);

        // Act
        final result = await repository.getPosts(page: page, limit: limit);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockDatasource.getPosts(page: page, limit: limit)).called(1);
      });

      test('should return Failure when datasource throws generic exception', () async {
        // Arrange
        const page = 1;
        const limit = 10;
        final exception = Exception('Unexpected error');

        when(() => mockDatasource.getPosts(page: page, limit: limit))
            .thenThrow(exception);

        // Act
        final result = await repository.getPosts(page: page, limit: limit);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isNotNull);
        expect(result.failure!.message, contains(exception.toString()));

        verify(() => mockDatasource.getPosts(page: page, limit: limit)).called(1);
      });

      test('should use default parameters when not provided', () async {
        // Arrange
        final postsDTO = MockData.postsResponseDTOList;

        when(() => mockDatasource.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => postsDTO);

        // Act
        final result = await repository.getPosts();

        // Assert
        expect(result.isSuccess, isTrue);
        verify(() => mockDatasource.getPosts(page: 1, limit: 10)).called(1);
      });
    });

    group('getPostById', () {
      test('should return PostModel when datasource call succeeds', () async {
        // Arrange
        const postId = 1;
        final postDTO = MockData.singlePostResponseDTO;
        final expectedPost = MockData.singlePostModel;

        when(() => mockDatasource.getPostById(postId))
            .thenAnswer((_) async => postDTO);

        // Act
        final result = await repository.getPostById(postId);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.id, equals(expectedPost.id));
        expect(result.success!.title, equals(expectedPost.title));
        expect(result.success!.body, equals(expectedPost.body));
        expect(result.success!.userId, equals(expectedPost.userId));

        verify(() => mockDatasource.getPostById(postId)).called(1);
      });

      test('should return Failure when datasource throws Failure', () async {
        // Arrange
        const postId = 999;
        final failure = Failure(message: 'Post not found');

        when(() => mockDatasource.getPostById(postId))
            .thenThrow(failure);

        // Act
        final result = await repository.getPostById(postId);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockDatasource.getPostById(postId)).called(1);
      });

      test('should return Failure when datasource throws generic exception', () async {
        // Arrange
        const postId = 1;
        final exception = Exception('Network timeout');

        when(() => mockDatasource.getPostById(postId))
            .thenThrow(exception);

        // Act
        final result = await repository.getPostById(postId);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isNotNull);
        expect(result.failure!.message, contains('Erro inesperado ao buscar post'));

        verify(() => mockDatasource.getPostById(postId)).called(1);
      });
    });

    group('getUserById', () {
      test('should return UserPostModel when datasource call succeeds', () async {
        // Arrange
        const userId = 1;
        final userDTO = MockData.userPostResponseDTO;
        final expectedUser = MockData.userPostModel;

        when(() => mockDatasource.getUserById(userId))
            .thenAnswer((_) async => userDTO);

        // Act
        final result = await repository.getUserById(userId);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.id, equals(expectedUser.id));
        expect(result.success!.name, equals(expectedUser.name));
        expect(result.success!.username, equals(expectedUser.username));
        expect(result.success!.email, equals(expectedUser.email));

        verify(() => mockDatasource.getUserById(userId)).called(1);
      });

      test('should return Failure when datasource throws Failure', () async {
        // Arrange
        const userId = 999;
        final failure = Failure(message: 'User not found');

        when(() => mockDatasource.getUserById(userId))
            .thenThrow(failure);

        // Act
        final result = await repository.getUserById(userId);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, equals(failure));

        verify(() => mockDatasource.getUserById(userId)).called(1);
      });

      test('should return Failure when datasource throws generic exception', () async {
        // Arrange
        const userId = 1;
        final exception = Exception('Connection failed');

        when(() => mockDatasource.getUserById(userId))
            .thenThrow(exception);

        // Act
        final result = await repository.getUserById(userId);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isNotNull);
        expect(result.failure!.message, contains('Erro inesperado ao buscar usuário'));

        verify(() => mockDatasource.getUserById(userId)).called(1);
      });
    });
  });
}