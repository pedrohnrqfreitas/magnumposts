import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/data/posts/repository/implementation/posts_repository.dart';
import 'package:magnumposts/data/posts/datasource/i_posts_datasource.dart';
import 'package:magnumposts/data/posts/dto/response/post_response_dto.dart';
import 'package:magnumposts/data/posts/dto/response/user_post_response_dto.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/data/posts/models/user_post_model.dart';
import 'package:magnumposts/core/errors/failure.dart';

class MockPostsDatasource extends Mock implements IPostsDatasource {}

void main() {
  group('PostsRepository', () {
    late PostsRepository repository;
    late MockPostsDatasource mockDatasource;

    setUp(() {
      mockDatasource = MockPostsDatasource();
      repository = PostsRepository(remoteDatasource: mockDatasource);
    });

    group('getPosts', () {
      test('deve retornar lista de posts quando datasource retornar dados', () async {
        // Arrange
        final postsDTO = [
          PostResponseDTO(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
          PostResponseDTO(id: 2, userId: 1, title: 'Post 2', body: 'Body 2'),
        ];

        when(() => mockDatasource.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => postsDTO);

        // Act
        final result = await repository.getPosts(page: 1, limit: 10);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!.length, equals(2));
        expect(result.success![0], isA<PostModel>());
        expect(result.success![0].id, equals(1));
        expect(result.success![0].title, equals('Post 1'));

        verify(() => mockDatasource.getPosts(page: 1, limit: 10)).called(1);
      });

      test('deve retornar Failure quando datasource lançar exceção', () async {
        // Arrange
        when(() => mockDatasource.getPosts(page: 1, limit: 10))
            .thenThrow(Exception('Erro na API'));

        // Act
        final result = await repository.getPosts(page: 1, limit: 10);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isA<Failure>());
        expect(result.failure!.message, contains('Exception: Erro na API'));
      });
    });

    group('getPostById', () {
      test('deve retornar post quando datasource retornar dados', () async {
        // Arrange
        const postId = 1;
        final postDTO = PostResponseDTO(
          id: postId,
          userId: 1,
          title: 'Post Title',
          body: 'Post Body',
        );

        when(() => mockDatasource.getPostById(postId))
            .thenAnswer((_) async => postDTO);

        // Act
        final result = await repository.getPostById(postId);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!, isA<PostModel>());
        expect(result.success!.id, equals(postId));
        expect(result.success!.title, equals('Post Title'));

        verify(() => mockDatasource.getPostById(postId)).called(1);
      });

      test('deve retornar Failure quando datasource lançar exceção', () async {
        // Arrange
        const postId = 1;
        when(() => mockDatasource.getPostById(postId))
            .thenThrow(Exception('Post não encontrado'));

        // Act
        final result = await repository.getPostById(postId);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isA<Failure>());
        expect(result.failure!.message, contains('Post não encontrado'));
      });
    });

    group('getUserById', () {
      test('deve retornar usuário quando datasource retornar dados', () async {
        // Arrange
        const userId = 1;
        final userDTO = UserPostResponseDTO(
          id: userId,
          name: 'Test User',
          username: 'testuser',
          email: 'test@test.com',
        );

        when(() => mockDatasource.getUserById(userId))
            .thenAnswer((_) async => userDTO);

        // Act
        final result = await repository.getUserById(userId);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, isNotNull);
        expect(result.success!, isA<UserPostModel>());
        expect(result.success!.id, equals(userId));
        expect(result.success!.name, equals('Test User'));

        verify(() => mockDatasource.getUserById(userId)).called(1);
      });

      test('deve retornar Failure quando datasource lançar exceção', () async {
        // Arrange
        const userId = 1;
        when(() => mockDatasource.getUserById(userId))
            .thenThrow(Exception('Usuário não encontrado'));

        // Act
        final result = await repository.getUserById(userId);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure, isA<Failure>());
        expect(result.failure!.message, contains('Usuário não encontrado'));
      });
    });
  });
}