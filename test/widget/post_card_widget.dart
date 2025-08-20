import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/features/posts/ui/widget/post_card_widget.dart';

void main() {
  late PostModel testPost;

  setUp(() {
    testPost = PostModel(
      id: 1,
      userId: 1,
      title: 'Test Post Title',
      body: 'This is a test post body that is longer than 100 characters to test the truncation functionality. It should show "Ver mais" button.',
    );
  });

  testWidgets('PostCardWidget should display post information', (tester) async {
    bool wasTapped = false;
    bool wasAvatarTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCardWidget(
            post: testPost,
            onTap: () => wasTapped = true,
            onAvatarTap: () => wasAvatarTapped = true,
          ),
        ),
      ),
    );

    // Verify post information is displayed
    expect(find.text('Test Post Title'), findsOneWidget);
    expect(find.text('Usuário 1'), findsOneWidget);
    expect(find.text('Post #1'), findsOneWidget);
    expect(find.text('U1'), findsOneWidget); // Avatar text
  });

  testWidgets('PostCardWidget should show "Ver mais" for long content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCardWidget(
            post: testPost,
            onTap: () {},
          ),
        ),
      ),
    );

    // Should show "Ver mais" button for truncated content
    expect(find.text('Ver mais'), findsOneWidget);
  });

  testWidgets('PostCardWidget should handle tap events', (tester) async {
    bool wasTapped = false;
    bool wasAvatarTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCardWidget(
            post: testPost,
            onTap: () => wasTapped = true,
            onAvatarTap: () => wasAvatarTapped = true,
          ),
        ),
      ),
    );

    // Tap on card
    await tester.tap(find.byType(Card));
    expect(wasTapped, true);

    // Tap on avatar
    wasTapped = false;
    await tester.tap(find.byType(CircleAvatar));
    expect(wasAvatarTapped, true);
  });

  testWidgets('PostCardWidget should not show "Ver mais" for short content', (tester) async {
    final shortPost = PostModel(
      id: 1,
      userId: 1,
      title: 'Short Title',
      body: 'Short body',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCardWidget(
            post: shortPost,
            onTap: () {},
          ),
        ),
      ),
    );

    // Should not show "Ver mais" button for short content
    expect(find.text('Ver mais'), findsNothing);
  });
}