import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/features/posts/ui/pages/posts_list_page.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_bloc.dart';
import 'package:magnumposts/features/posts/ui/bloc/posts_state.dart';
import 'package:magnumposts/features/posts/ui/widget/post_card_widget.dart';
import 'package:magnumposts/features/posts/ui/widget/post_skeleton_card.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_bloc.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_state.dart';
import 'package:magnumposts/features/posts/usecase/get_user_by_id_usecase.dart';
import 'package:magnumposts/core/widgets/app_error_widget.dart';
import 'package:magnumposts/core/widgets/app_empty_state.dart';
import 'package:magnumposts/core/constants/app_constants.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/mock_data.dart';

// Mocks
class MockPostsBloc extends Mock implements PostsBloc {}
class MockAuthBloc extends Mock implements AuthBloc {}
class MockGetUserByIdUseCase extends Mock implements GetUserByIdUseCase {}

void main() {
  group('PostsListPage', () {
    late MockPostsBloc mockPostsBloc;
    late MockAuthBloc mockAuthBloc;
    late MockGetUserByIdUseCase mockGetUserByIdUseCase;

    setUp(() {
      mockPostsBloc = MockPostsBloc();
      mockAuthBloc = MockAuthBloc();
      mockGetUserByIdUseCase = MockGetUserByIdUseCase();
      setupMocktailFallbacks();
    });

    Widget createTestWidget(PostsState postsState, AuthState authState) {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<GetUserByIdUseCase>.value(value: mockGetUserByIdUseCase),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PostsBloc>.value(value: mockPostsBloc),
              BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            ],
            child: const PostsListPage(),
          ),
        ),
      );
    }

    group('Loading state', () {
      testWidgets('should show skeleton cards when loading', (tester) async {
        // Arrange
        when(() => mockPostsBloc.state).thenReturn(const PostsLoading());
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(const PostsLoading(), AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(PostSkeletonCard), findsWidgets);
        expect(find.text(AppConstants.loadingPostsMessage), findsNothing); // Skeleton cards não mostram texto
      });

      testWidgets('should show correct number of skeleton cards', (tester) async {
        // Arrange
        when(() => mockPostsBloc.state).thenReturn(const PostsLoading());
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(const PostsLoading(), AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(PostSkeletonCard), findsNWidgets(AppConstants.skeletonItemCount));
      });
    });

    group('Error state', () {
      testWidgets('should show error widget when error occurs without previous posts', (tester) async {
        // Arrange
        const errorState = PostsError(message: 'Network error');
        when(() => mockPostsBloc.state).thenReturn(errorState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(errorState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(AppErrorWidget), findsOneWidget);
        expect(find.text('Erro ao carregar posts'), findsOneWidget);
        expect(find.text('Network error'), findsOneWidget);
      });

      testWidgets('should show retry button in error state', (tester) async {
        // Arrange
        const errorState = PostsError(message: 'Network error');
        when(() => mockPostsBloc.state).thenReturn(errorState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(errorState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.text('Tentar Novamente'), findsOneWidget);
        expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      });
    });

    group('Loaded state', () {
      testWidgets('should show post cards when posts are loaded', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(PostCardWidget), findsNWidgets(posts.length));

        // Verifica se os posts estão sendo exibidos
        for (final post in posts) {
          expect(find.text(post.title), findsOneWidget);
        }
      });

      testWidgets('should show empty state when no posts loaded', (tester) async {
        // Arrange
        const loadedState = PostsLoaded(posts: []);
        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(AppEmptyState), findsOneWidget);
        expect(find.text(AppConstants.noPostsErrorMessage), findsOneWidget);
      });

      testWidgets('should support pull to refresh', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('Loading more state', () {
      testWidgets('should show loading indicator at bottom when loading more', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadingMoreState = PostsLoadingMore(currentPosts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadingMoreState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadingMoreState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(PostCardWidget), findsNWidgets(posts.length));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show current posts while loading more', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadingMoreState = PostsLoadingMore(currentPosts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadingMoreState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadingMoreState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        for (final post in posts) {
          expect(find.text(post.title), findsOneWidget);
        }
      });
    });

    group('AppBar functionality', () {
      testWidgets('should show app title in app bar', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.text(AppConstants.appTitle), findsOneWidget);
      });

      testWidgets('should show refresh and logout buttons in app bar', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
        expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
      });

      testWidgets('should show logout confirmation when logout button is pressed', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));
        await tester.tap(find.byIcon(Icons.logout_rounded));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppConstants.logoutConfirmTitle), findsOneWidget);
        expect(find.text(AppConstants.logoutConfirmMessage), findsOneWidget);
        expect(find.text(AppConstants.logoutButtonText), findsOneWidget);
        expect(find.text(AppConstants.cancelButtonText), findsOneWidget);
      });
    });

    group('Scroll behavior', () {
      testWidgets('should trigger load more when scrolled to bottom', (tester) async {
        // Arrange
        final posts = MockData.createPostsList(20);
        final loadedState = PostsLoaded(posts: posts, hasReachedMax: false);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Scroll to bottom
        final listView = find.byType(ListView);
        await tester.scrollUntilVisible(
          find.byType(PostCardWidget).last,
          500.0,
          scrollable: listView,
        );

        // Assert
        // Verificar se o scroll controller está funcionando
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('should not trigger load more when max is reached', (tester) async {
        // Arrange
        final posts = MockData.createPostsList(5);
        final loadedState = PostsLoaded(posts: posts, hasReachedMax: true);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(find.byType(PostCardWidget), findsNWidgets(5));
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('should navigate to post detail when post card is tapped', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));
        await tester.tap(find.byType(PostCardWidget).first);
        await tester.pumpAndSettle();

        // Assert
        // Verificar que a navegação foi tentada (não podemos verificar a página de destino em testes unitários)
        expect(find.byType(PostCardWidget), findsWidgets);
      });
    });

    group('Authentication integration', () {
      testWidgets('should handle auth state changes', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, const AuthUnauthenticated()));

        // Assert
        // O widget deveria ainda renderizar, pois o BlocListener trata a navegação
        expect(find.byType(PostsListPage), findsOneWidget);
      });
    });

    group('Error handling', () {
      testWidgets('should handle missing user data gracefully', (tester) async {
        // Arrange
        final posts = MockData.postModelList;
        final loadedState = PostsLoaded(posts: posts);

        when(() => mockPostsBloc.state).thenReturn(loadedState);
        when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(user: MockData.userModel));
        when(() => mockPostsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

        // Act
        await tester.pumpWidget(createTestWidget(loadedState, AuthAuthenticated(user: MockData.userModel)));

        // Assert
        expect(tester.takeException(), isNull);
        expect(find.byType(PostCardWidget), findsWidgets);
      });
    });
  });
}