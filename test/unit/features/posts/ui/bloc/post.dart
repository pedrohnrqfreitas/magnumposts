import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_bloc.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_event.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_state.dart';
import 'package:magnumposts/features/posts/usecase/get_posts_usecase.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';

import '../../../../../helpers/test_helpers.dart';
import '../../../../../helpers/mock_data.dart';

// Mock do UseCase
class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {
  group('PostsBloc', () {
    late PostsBloc bloc;
    late MockGetPostsUseCase mockGetPostsUseCase;

    setUp(() {
      mockGetPostsUseCase = MockGetPostsUseCase();
      bloc = PostsBloc(getPostsUseCase: mockGetPostsUseCase);
      setupMocktailFallbacks();

      // Registra fallback para GetPostsParams
      registerFallbackValue(GetPostsParams(page: 1, limit: 10));
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be PostsInitial', () {
      expect(bloc.state, equals(const PostsInitial()));
    });

    group('PostsLoadRequested', () {
      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoading, PostsLoaded] when loading posts succeeds',
        build: () {
          final posts = MockData.postModelList;
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(posts));
          return bloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: MockData.postModelList, hasReachedMax: true),
        ],
        verify: (_) {
          verify(() => mockGetPostsUseCase(any())).called(1);
        },
      );

      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoading, PostsError] when loading posts fails',
        build: () {
          final failure = Failure(message: 'Network error');
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.error(failure));
          return bloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          const PostsError(message: 'Network error'),
        ],
        verify: (_) {
          verify(() => mockGetPostsUseCase(any())).called(1);
        },
      );

      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoading, PostsLoaded] with hasReachedMax=false when full page is returned',
        build: () {
          // Retorna exatamente 10 posts (tamanho da página)
          final posts = MockData.createPostsList(10);
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(posts));
          return bloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: MockData.createPostsList(10), hasReachedMax: false),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoading, PostsLoaded] with hasReachedMax=true when partial page is returned',
        build: () {
          // Retorna menos que 10 posts (fim da lista)
          final posts = MockData.createPostsList(5);
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(posts));
          return bloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: MockData.createPostsList(5), hasReachedMax: true),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoading, PostsLoaded] with empty list when no posts returned',
        build: () {
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success([]));
          return bloc;
        },
        act: (bloc) => bloc.add(const PostsLoadRequested()),
        expect: () => [
          const PostsLoading(),
          const PostsLoaded(posts: [], hasReachedMax: true),
        ],
      );
    });

    group('PostsLoadMoreRequested', () {
      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoadingMore, PostsLoaded] when loading more posts succeeds',
        build: () {
          final initialPosts = MockData.createPostsList(10);
          final morePosts = MockData.createPostsList(5).map((post) =>
              post.copyWith(id: post.id + 10)
          ).toList();

          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(morePosts));

          return bloc;
        },
        seed: () => PostsLoaded(
          posts: MockData.createPostsList(10),
          hasReachedMax: false,
        ),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [
          PostsLoadingMore(currentPosts: MockData.createPostsList(10)),
          PostsLoaded(
            posts: [
              ...MockData.createPostsList(10),
              ...MockData.createPostsList(5).map((post) =>
                  post.copyWith(id: post.id + 10)
              ).toList(),
            ],
            hasReachedMax: true,
          ),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should not emit anything when already at max',
        build: () => bloc,
        seed: () => const PostsLoaded(
          posts: [],
          hasReachedMax: true,
        ),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetPostsUseCase(any()));
        },
      );

      blocTest<PostsBloc, PostsState>(
        'should revert to previous state when loading more fails',
        build: () {
          final failure = Failure(message: 'Network error');
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.error(failure));
          return bloc;
        },
        seed: () => PostsLoaded(
          posts: MockData.createPostsList(10),
          hasReachedMax: false,
        ),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [
          PostsLoadingMore(currentPosts: MockData.createPostsList(10)),
          PostsLoaded(
            posts: MockData.createPostsList(10),
            hasReachedMax: false,
          ),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should not load more when state is not PostsLoaded',
        build: () => bloc,
        seed: () => const PostsLoading(),
        act: (bloc) => bloc.add(const PostsLoadMoreRequested()),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetPostsUseCase(any()));
        },
      );
    });

    group('PostRefreshRequested', () {
      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoaded with isRefreshing=true, PostsLoaded] when refresh succeeds from loaded state',
        build: () {
          final refreshedPosts = MockData.createPostsList(8);
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(refreshedPosts));
          return bloc;
        },
        seed: () => PostsLoaded(
          posts: MockData.createPostsList(10),
          hasReachedMax: false,
        ),
        act: (bloc) => bloc.add(const PostRefreshRequested()),
        expect: () => [
          PostsLoaded(
            posts: MockData.createPostsList(10),
            hasReachedMax: false,
            isRefreshing: true,
          ),
          PostsLoaded(
            posts: MockData.createPostsList(8),
            hasReachedMax: true,
          ),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoading, PostsLoaded] when refresh succeeds from non-loaded state',
        build: () {
          final posts = MockData.createPostsList(5);
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.success(posts));
          return bloc;
        },
        seed: () => const PostsError(message: 'Previous error'),
        act: (bloc) => bloc.add(const PostRefreshRequested()),
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: MockData.createPostsList(5), hasReachedMax: true),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should emit [PostsLoaded with isRefreshing=true, PostsError] when refresh fails',
        build: () {
          final failure = Failure(message: 'Refresh failed');
          when(() => mockGetPostsUseCase(any()))
              .thenAnswer((_) async => ResultData.error(failure));
          return bloc;
        },
        seed: () => PostsLoaded(
          posts: MockData.createPostsList(5),
          hasReachedMax: false,
        ),
        act: (bloc) => bloc.add(const PostRefreshRequested()),
        expect: () => [
          PostsLoaded(
            posts: MockData.createPostsList(5),
            hasReachedMax: false,
            isRefreshing: true,
          ),
          PostsError(
            message: 'Refresh failed',
            previousPosts: MockData.createPostsList(5),
          ),
        ],
      );

      blocTest<PostsBloc, PostsState>(
        'should reset pagination when refresh is requested',
        build: () {
          // Simula que já estamos na página 3
          final posts = MockData.createPostsList(10);
          when(() => mockGetPostsUseCase(GetPostsParams(page: 1, limit: 10)))
              .thenAnswer((_) async => ResultData.success(posts));
          return bloc;
        },
        seed: () => PostsLoaded(
          posts: MockData.createPostsList(30), // Simula 30 posts carregados
          hasReachedMax: false,
        ),
        act: (bloc) => bloc.add(const PostRefreshRequested()),
        verify: (_) {
          // Verifica que chamou com página 1
          verify(() => mockGetPostsUseCase(GetPostsParams(page: 1, limit: 10))).called(1);
        },
      );
    });

    group('Multiple events sequence', () {
      blocTest<PostsBloc, PostsState>(
        'should handle sequence: load -> load more -> refresh correctly',
        build: () {
          // Setup para diferentes chamadas
          when(() => mockGetPostsUseCase(GetPostsParams(page: 1, limit: 10)))
              .thenAnswer((_) async => ResultData.success(MockData.createPostsList(10)));

          when(() => mockGetPostsUseCase(GetPostsParams(page: 2, limit: 10)))
              .thenAnswer((_) async => ResultData.success(MockData.createPostsList(5).map((post) =>
              post.copyWith(id: post.id + 10)
          ).toList()));

          return bloc;
        },
        act: (bloc) async {
          bloc.add(const PostsLoadRequested());
          await Future.delayed(const Duration(milliseconds: 10));
          bloc.add(const PostsLoadMoreRequested());
          await Future.delayed(const Duration(milliseconds: 10));
          bloc.add(const PostRefreshRequested());
        },
        expect: () => [
          const PostsLoading(),
          PostsLoaded(posts: MockData.createPostsList(10), hasReachedMax: false),
          PostsLoadingMore(currentPosts: MockData.createPostsList(10)),
          PostsLoaded(
            posts: [
              ...MockData.createPostsList(10),
              ...MockData.createPostsList(5).map((post) => post.copyWith(id: post.id + 10)),
            ],
            hasReachedMax: true,
          ),
          PostsLoaded(
            posts: [
              ...MockData.createPostsList(10),
              ...MockData.createPostsList(5).map((post) => post.copyWith(id: post.id + 10)),
            ],
            hasReachedMax: true,
            isRefreshing: true,
          ),
          PostsLoaded(posts: MockData.createPostsList(10), hasReachedMax: false),
        ],
      );
    });
  });
}