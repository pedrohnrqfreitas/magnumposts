import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:magnumposts/main.dart';

// Mock Firebase para testes
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    setUpAll(() async {
      // Mock Firebase
      FirebasePlatform.instance = MockFirebasePlatform();
    });

    testWidgets('should show splash screen and navigate to login', (tester) async {
      // Build the app
      await tester.pumpWidget(const MagnumPostsApp());

      // Verify splash screen appears
      expect(find.text('Magnum Posts'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for navigation
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to login page
      expect(find.text('Entre com seu email e senha'), findsOneWidget);
      expect(find.byType(TextField), findsAtLeast(2)); // Email and password fields
    });

    testWidgets('should show validation errors for empty fields', (tester) async {
      await tester.pumpWidget(const MagnumPostsApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and tap login button without filling fields
      final loginButton = find.text('Entrar');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Email é obrigatório'), findsOneWidget);
      expect(find.text('Senha é obrigatória'), findsOneWidget);
    });

    testWidgets('should navigate to register page', (tester) async {
      await tester.pumpWidget(const MagnumPostsApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and tap "Criar conta" button
      final registerButton = find.text('Criar conta');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Should navigate to register page
      expect(find.text('Criar Conta'), findsOneWidget);
      expect(find.text('Preencha os dados para se cadastrar'), findsOneWidget);
    });

    testWidgets('should show form validation on register page', (tester) async {
      await tester.pumpWidget(const MagnumPostsApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to register
      await tester.tap(find.text('Criar conta'));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Criar Conta'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Email é obrigatório'), findsOneWidget);
      expect(find.text('Senha é obrigatória'), findsOneWidget);
    });

    testWidgets('should validate email format', (tester) async {
      await tester.pumpWidget(const MagnumPostsApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Fill invalid email
      await tester.enterText(find.byType(TextField).first, 'invalid-email');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      // Try to submit
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Should show email validation error
      expect(find.text('Por favor, insira um email válido'), findsOneWidget);
    });
  });
}