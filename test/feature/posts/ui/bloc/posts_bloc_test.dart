import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_bloc.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_event.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_state.dart';
import 'package:magnumposts/features/posts/usecase/get_posts_usecase.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {
  group('PostsBloc', () {
    late PostsBloc postsBloc;
    late MockGetPostsUseCase mockGetPostsUseCase;

    setUp(() {
      mockGetPostsUseCase = MockGetPostsUseCase();
      postsBloc = PostsBloc(getPostsUseCase: mockGetPostsUseCase);
    });

    setUpAll(() {
      registerFallbackValue(GetPostsParams());
    });

    tearDown(() {
      postsBloc.close();
    });

    test('estado inicial deve ser PostsInitial', () {
      expect(postsBloc.state, equals(const PostsInitial()));
    });

    group('PostsLoadRequested', () {
      final mockPosts = [
        PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
        PostModel(id: 2, userId: 1, title: 'Post 2', body: 'Body 2'),
      ];

      // Define lessPosts outside the blocTest build callback
      final lessPosts = [
        PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
      ]; // Menos que 10 posts (limite padrão)

      blocTest<PostsBloc, PostsState>(
        'deve emitir [PostsLoading, PostsLoaded] quando posts forem carregados com sucesso',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(mockPosts));
          return postsBloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: mockPosts, hasReachedMax: false),
        ],
        verify: (_) {
          verify(() => mockGetPostsUseCase(any())).called(1);
        },
      );

      blocTest<PostsBloc, PostsState>(
        'deve emitir [PostsLoading, PostsError] quando carregar posts falhar',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.error(Failure(message: 'Erro na API')));
          return postsBloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          const PostsError(message: 'Erro na API'),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'deve marcar hasReachedMax como true quando retornar menos posts que o limite',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(lessPosts));
          return postsBloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: lessPosts, hasReachedMax: true),
        ],
      );
    });

    group('PostRefreshRequested', () {
      final mockPosts = [
        PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
      ];

      blocTest<PostsBloc, PostsState>(
        'deve emitir PostsLoaded com isRefreshing=true depois PostsLoaded normal',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(mockPosts));
          return postsBloc;
        },
        seed: () => PostsLoaded(posts: mockPosts),
        act: (bloc) => bloc.add(const PostRefreshRequested()),
        expect: () => [
          PostsLoaded(posts: mockPosts, isRefreshing: true),
          PostsLoaded(posts: mockPosts, hasReachedMax: true),
        ],
      );
    });

    group('PostsLoadMoreRequested', () {
      final existingPosts = [
        PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
      ];

      final newPosts = [
        PostModel(id: 2, userId: 1, title: 'Post 2', body: 'Body 2'),
      ];

      blocTest<PostsBloc, PostsState>(
        'deve adicionar novos posts aos existentes',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(newPosts));
          return postsBloc;
        },
        seed: () => PostsLoaded(posts: existingPosts, hasReachedMax: false),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [
          PostsLoadingMore(currentPosts: existingPosts),
          PostsLoaded(
            posts: [...existingPosts, ...newPosts],
            hasReachedMax: true, // Apenas 1 post retornado, menos que o limite
          ),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'não deve carregar mais posts quando hasReachedMax for true',
        build: () => postsBloc,
        seed: () => PostsLoaded(posts: existingPosts, hasReachedMax: true),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [],
      );

      blocTest<PostsBloc, PostsState>(
        'deve manter posts existentes quando falhar ao carregar mais',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.error(Failure(message: 'Erro na API')));
          return postsBloc;
        },
        seed: () => PostsLoaded(posts: existingPosts, hasReachedMax: false),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [
          PostsLoadingMore(currentPosts: existingPosts),
          PostsLoaded(posts: existingPosts, hasReachedMax: false),
        ],
      );
    });
  });
}
