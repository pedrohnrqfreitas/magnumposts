import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnumposts/features/posts/ui/widget/post_card_widget.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/data/posts/models/user_post_model.dart';
import 'package:magnumposts/core/constants/app_constants.dart';

import '../../helpers/mock_data.dart';

void main() {
  group('PostCardWidget', () {
    late PostModel testPost;
    late UserPostModel testAuthor;

    setUp(() {
      testPost = MockData.singlePostModel;
      testAuthor = MockData.userPostModel;
    });

    group('Widget rendering', () {
      testWidgets('should render post title and body correctly', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(testPost.title), findsOneWidget);
        expect(find.text(testPost.truncatedBody), findsOneWidget);
      });

      testWidgets('should render author information when available', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(testAuthor.name), findsOneWidget);
        expect(find.text('@${testAuthor.username}'), findsOneWidget);
      });

      testWidgets('should render post ID correctly', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('${AppConstants.postIdPrefix}${testPost.id}'), findsOneWidget);
      });

      testWidgets('should render avatar with author initials', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        final avatarContainer = find.byType(Container);
        expect(avatarContainer, findsWidgets);

        // Verifica se as iniciais do autor estão presentes
        expect(find.text('JD'), findsOneWidget); // John Doe -> JD
      });
    });

    group('Loading states', () {
      testWidgets('should show skeleton card when author is loading', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: null,
                isLoadingAuthor: true,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        // Deve mostrar o skeleton loader
        expect(find.byType(ShaderMask), findsWidgets);

        // Não deve mostrar o conteúdo real do post
        expect(find.text(testPost.title), findsNothing);
      });

      testWidgets('should show normal card when not loading', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        // Deve mostrar o conteúdo real
        expect(find.text(testPost.title), findsOneWidget);
        expect(find.text(testAuthor.name), findsOneWidget);
      });
    });

    group('Author information handling', () {
      testWidgets('should show fallback author name when author is null', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: null,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('${AppConstants.userFallbackPrefix}${testPost.userId}'), findsOneWidget);
      });

      testWidgets('should generate correct initials for different author names', (tester) async {
        // Test cases for different name formats
        final testCases = [
          {'name': 'John Doe', 'expected': 'JD'},
          {'name': 'Alice', 'expected': 'A'},
          {'name': 'Bob Smith Johnson', 'expected': 'BS'}, // Should take first two words
          {'name': '', 'expected': 'U${testPost.userId}'}, // Fallback for empty name
        ];

        for (final testCase in testCases) {
          final authorWithName = UserPostModel(
            id: testAuthor.id,
            name: testCase['name'] as String,
            username: testAuthor.username,
            email: testAuthor.email,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: PostCardWidget(
                  post: testPost,
                  author: authorWithName,
                  isLoadingAuthor: false,
                  onTap: () {},
                ),
              ),
            ),
          );

          // Assert
          expect(
            find.text(testCase['expected'] as String),
            findsOneWidget,
            reason: 'Failed for name: ${testCase['name']}',
          );

          // Reset for next iteration
          await tester.pumpWidget(Container());
        }
      });
    });

    group('Interactions', () {
      testWidgets('should call onTap when card is tapped', (tester) async {
        // Arrange
        var tapCount = 0;
        void onTapCallback() => tapCount++;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: onTapCallback,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(Card));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(1));
      });

      testWidgets('should call onAvatarTap when avatar is tapped', (tester) async {
        // Arrange
        var avatarTapCount = 0;
        void onAvatarTapCallback() => avatarTapCount++;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
                onAvatarTap: onAvatarTapCallback,
              ),
            ),
          ),
        );

        // Act
        final avatar = find.byType(GestureDetector).first;
        await tester.tap(avatar);
        await tester.pumpAndSettle();

        // Assert
        expect(avatarTapCount, equals(1));
      });

      testWidgets('should not call onAvatarTap when author is null', (tester) async {
        // Arrange
        var avatarTapCount = 0;
        void onAvatarTapCallback() => avatarTapCount++;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: null,
                isLoadingAuthor: false,
                onTap: () {},
                onAvatarTap: onAvatarTapCallback,
              ),
            ),
          ),
        );

        // Act
        final avatar = find.byType(GestureDetector).first;
        await tester.tap(avatar);
        await tester.pumpAndSettle();

        // Assert
        expect(avatarTapCount, equals(0));
      });
    });

    group('See more functionality', () {
      testWidgets('should show "See more" button for long posts', (tester) async {
        // Arrange
        final longPost = PostModel(
          id: 1,
          userId: 1,
          title: 'Test Title',
          body: 'A' * 150, // Long body that will be truncated
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: longPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(AppConstants.seeMoreText), findsOneWidget);
      });

      testWidgets('should not show "See more" button for short posts', (tester) async {
        // Arrange
        final shortPost = PostModel(
          id: 1,
          userId: 1,
          title: 'Test Title',
          body: 'Short body', // Short body
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: shortPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(AppConstants.seeMoreText), findsNothing);
      });

      testWidgets('should call onTap when "See more" button is pressed', (tester) async {
        // Arrange
        var tapCount = 0;
        void onTapCallback() => tapCount++;

        final longPost = PostModel(
          id: 1,
          userId: 1,
          title: 'Test Title',
          body: 'A' * 150, // Long body
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: longPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: onTapCallback,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text(AppConstants.seeMoreText));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(1));
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        // Verifica se os elementos principais estão acessíveis
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(InkWell), findsOneWidget);

        // Verifica se o texto é encontrado corretamente
        expect(find.text(testPost.title), findsOneWidget);
        expect(find.text(testAuthor.name), findsOneWidget);
      });

      testWidgets('should handle overflow text correctly', (tester) async {
        // Arrange
        final postWithLongTitle = PostModel(
          id: 1,
          userId: 1,
          title: 'This is a very long title that should be handled correctly by the widget without causing overflow issues or layout problems',
          body: 'Short body',
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: postWithLongTitle,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        // Não deve gerar overflow warnings
        expect(tester.takeException(), isNull);
      });
    });

    group('Visual styling', () {
      testWidgets('should apply correct styling to components', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        final card = tester.widget<Card>(find.byType(Card));
        expect(card.elevation, equals(AppConstants.cardElevation));

        final cardShape = card.shape as RoundedRectangleBorder;
        expect(cardShape.borderRadius, equals(BorderRadius.circular(AppConstants.borderRadius)));
      });

      testWidgets('should have correct avatar styling', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostCardWidget(
                post: testPost,
                author: testAuthor,
                isLoadingAuthor: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        final avatarContainer = tester.widget<Container>(
          find.descendant(
            of: find.byType(GestureDetector),
            matching: find.byType(Container),
          ).first,
        );

        expect(avatarContainer.constraints?.maxWidth, equals(AppConstants.avatarSizeS));
        expect(avatarContainer.constraints?.maxHeight, equals(AppConstants.avatarSizeS));
      });
    });
  });
}