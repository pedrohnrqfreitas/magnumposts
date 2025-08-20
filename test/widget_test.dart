import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:magnumposts/main.dart';

// Mock Firebase
class FakeFirebaseApp extends Fake implements FirebaseApp {
  @override
  String get name => 'test_app';

  @override
  FirebaseOptions get options => const FirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project-id',
  );
}

class MockFirebasePlatform extends Fake
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return FakeFirebaseApp();
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return FakeFirebaseApp();
  }
}

void main() {
  setUpAll(() async {
    // Mock Firebase
    FirebasePlatform.instance = MockFirebasePlatform();
  });

  testWidgets('App should build without error', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MagnumPostsApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}