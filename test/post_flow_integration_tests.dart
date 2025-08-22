import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/features/posts/usecase/get_posts_usecase.dart';
import 'package:magnumposts/features/posts/usecase/get_user_by_id_usecase.dart';
import 'package:magnumposts/data/posts/repository/i_posts_repository.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'helper/test_helpers.dart';

class MockPostsRepository extends Mock implements IPostsRepository {}

/// Testes de integração para validar o fluxo completo de posts
void main() {
  group('Posts Flow Integration Tests', () {
    late MockPostsRepository mockRepository;
    late GetPostsUseCase getPostsUseCase;
    late GetUserByIdUseCase getUserByIdUseCase;

    setUp(() {
      setupTestDependencies();
      mockRepository = MockPostsRepository();
      getPostsUseCase = GetPostsUseCase(repository: mockRepository);
      getUserByIdUseCase = GetUserByIdUseCase(repository: mockRepository);
    });

    setUpAll(() {
      registerFallbackValue(GetPostsParams());
    });

    group('Fluxo completo de carregamento de posts', () {
      test('deve carregar posts e seus autores com sucesso', () async {
        // Arrange
        final mockPosts = TestHelpers.createMockPosts(3);
        final mockUser = TestHelpers.createMockUserPost();

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(mockPosts));

        when(() => mockRepository.getUserById(1))
            .thenAnswer((_) async => ResultData.success(mockUser));

        // Act - Carregar posts
        final postsResult = await getPostsUseCase(GetPostsParams(page: 1, limit: 10));

        // Assert - Posts carregados
        expect(postsResult.isSuccess, isTrue);
        expect(postsResult.success!.length, equals(3));

        // Act - Carregar autor do primeiro post
        final userResult = await getUserByIdUseCase(mockPosts.first.userId);

        // Assert - Autor carregado
        expect(userResult.isSuccess, isTrue);
        expect(userResult.success!.name, equals('Test User'));

        // Verify - Métodos chamados
        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
        verify(() => mockRepository.getUserById(1)).called(1);
      });

      test('deve lidar com falha no carregamento de posts', () async {
        // Arrange
        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.error(
          Failure(message: 'Erro de rede'),
        ));

        // Act
        final result = await getPostsUseCase(GetPostsParams(page: 1, limit: 10));

        // Assert
        expect(result.isError, isTrue);
        expect(result.failure!.message, equals('Erro de rede'));
      });

      test('deve lidar com falha no carregamento de autor', () async {
        // Arrange
        final mockPosts = TestHelpers.createMockPosts(1);

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(mockPosts));

        when(() => mockRepository.getUserById(1))
            .thenAnswer((_) async => ResultData.error(
          Failure(message: 'Usuário não encontrado'),
        ));

        // Act
        final postsResult = await getPostsUseCase(GetPostsParams(page: 1, limit: 10));
        final userResult = await getUserByIdUseCase(1);

        // Assert
        expect(postsResult.isSuccess, isTrue);
        expect(userResult.isError, isTrue);
        expect(userResult.failure!.message, equals('Usuário não encontrado'));
      });
    });

    group('Fluxo de paginação', () {
      test('deve carregar múltiplas páginas de posts', () async {
        // Arrange
        final page1Posts = TestHelpers.createMockPosts(10);
        final page2Posts = TestHelpers.createMockPosts(5).map(
              (post) => TestHelpers.createMockPost(
            id: post.id + 10,
            title: 'Page 2 ${post.title}',
          ),
        ).toList();

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(page1Posts));

        when(() => mockRepository.getPosts(page: 2, limit: 10))
            .thenAnswer((_) async => ResultData.success(page2Posts));

        // Act - Carregar primeira página
        final page1Result = await getPostsUseCase(
          GetPostsParams(page: 1, limit: 10),
        );

        // Act - Carregar segunda página
        final page2Result = await getPostsUseCase(
          GetPostsParams(page: 2, limit: 10),
        );

        // Assert
        expect(page1Result.isSuccess, isTrue);
        expect(page1Result.success!.length, equals(10));

        expect(page2Result.isSuccess, isTrue);
        expect(page2Result.success!.length, equals(5));

        // Verify
        verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
        verify(() => mockRepository.getPosts(page: 2, limit: 10)).called(1);
      });
    });

    group('Validação de dados', () {
      test('posts devem ter dados válidos', () async {
        // Arrange
        final mockPosts = [
          TestHelpers.createMockPost(
            id: 1,
            userId: 1,
            title: 'Post Válido',
            body: 'Conteúdo do post válido',
          ),
        ];

        when(() => mockRepository.getPosts(page: 1, limit: 10))
            .thenAnswer((_) async => ResultData.success(mockPosts));

        // Act
        final result = await getPostsUseCase(GetPostsParams());

        // Assert
        expect(result.isSuccess, isTrue);
        final post = result.success!.first;

        expect(post.id, greaterThan(0));
        expect(post.userId, greaterThan(0));
        expect(post.title, isNotEmpty);
        expect(post.body, isNotEmpty);
      });

      test('usuários devem ter dados válidos', () async {
        // Arrange
        final mockUser = TestHelpers.createMockUserPost(
          id: 1,
          name: 'Usuário Válido',
          username: 'usuario_valido',
          email: 'usuario@email.com',
        );

        when(() => mockRepository.getUserById(1))
            .thenAnswer((_) async => ResultData.success(mockUser));

        // Act
        final result = await getUserByIdUseCase(1);

        // Assert
        expect(result.isSuccess, isTrue);
        final user = result.success!;

        expect(user.id, greaterThan(0));
        expect(user.name, isNotEmpty);
        expect(user.username, isNotEmpty);
        expect(user.email, contains('@'));
      });
    });
  });
}