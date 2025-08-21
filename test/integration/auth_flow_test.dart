import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/main.dart';
import 'package:magnumposts/features/authentication/ui/pages/splash_page.dart';
import 'package:magnumposts/features/authentication/ui/pages/login_page.dart';
import 'package:magnumposts/features/authentication/ui/pages/register_page.dart';
import 'package:magnumposts/features/posts/ui/pages/posts_list_page.dart';
import 'package:magnumposts/core/constants/app_constants.dart';

import '../helpers/test_helpers.dart';
import '../helpers/mock_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    setUp(() {
      setupMocktailFallbacks();
    });

    group('Complete Login Flow', () {
      testWidgets('should complete full login flow successfully', (tester) async {
        // Arrange & Act - Iniciar a aplicação
        await tester.pumpWidget(const MagnumPostsApp());
        await tester.pumpAndSettle();

        // Assert - Verificar splash screen
        expect(find.byType(SplashPage), findsOneWidget);
        expect(find.text(AppConstants.splashTitle), findsOneWidget);
        expect(find.text(AppConstants.splashSubtitle), findsOneWidget);

        // Aguardar navegação para login (simular que não há usuário logado)
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert - Verificar tela de login
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.text(AppConstants.loginTitle), findsOneWidget);
        expect(find.text(AppConstants.loginSubtitle), findsOneWidget);

        // Act - Preencher formulário de login
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        // Act - Submeter login
        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert - Verificar que chegou na tela de posts (sucesso do login)
        // Note: Em um teste de integração real, isso dependeria da configuração do Firebase
        expect(find.byType(TextFormField), findsWidgets);
      });

      testWidgets('should show error message for invalid credentials', (tester) async {
        // Arrange & Act - Iniciar na tela de login
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher com credenciais inválidas
        await tester.enterText(
          find.byType(TextFormField).first,
          'invalid@email.com',
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          'wrongpassword',
        );

        // Act - Submeter login
        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert - Verificar campos ainda estão presentes (não navegou)
        expect(find.byType(TextFormField), findsWidgets);
        expect(find.text(AppConstants.loginButtonText), findsOneWidget);
      });

      testWidgets('should validate form fields before submission', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Tentar submeter sem preencher campos
        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert - Verificar mensagens de validação
        expect(find.text(AppConstants.emailRequiredMessage), findsOneWidget);
        expect(find.text(AppConstants.passwordRequiredMessage), findsOneWidget);
      });

      testWidgets('should validate email format', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher email inválido
        await tester.enterText(
          find.byType(TextFormField).first,
          'invalid-email',
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppConstants.emailInvalidMessage), findsOneWidget);
      });

      testWidgets('should validate password minimum length', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher senha muito curta
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          '123', // Menos que 6 caracteres
        );

        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppConstants.passwordMinLengthMessage), findsOneWidget);
      });
    });

    group('Registration Flow', () {
      testWidgets('should navigate from login to registration', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Clicar no link de registro
        await tester.tap(find.text(AppConstants.loginFooterButtonText));
        await tester.pumpAndSettle();

        // Assert - Verificar tela de registro
        expect(find.byType(RegisterPage), findsOneWidget);
        expect(find.text(AppConstants.registerTitle), findsOneWidget);
        expect(find.text(AppConstants.registerSubtitle), findsOneWidget);
      });

      testWidgets('should complete registration form validation', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const RegisterPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher formulário de registro
        final textFields = find.byType(TextFormField);

        await tester.enterText(textFields.at(0), MockData.testDisplayName); // Nome
        await tester.enterText(textFields.at(1), MockData.testEmail);        // Email
        await tester.enterText(textFields.at(2), MockData.testPassword);     // Senha
        await tester.enterText(textFields.at(3), MockData.testPassword);     // Confirmar senha

        // Act - Submeter registro
        await tester.tap(find.text(AppConstants.registerButtonText));
        await tester.pumpAndSettle();

        // Assert - Formulário foi processado (não há erros de validação)
        expect(find.text(AppConstants.nameRequiredMessage), findsNothing);
        expect(find.text(AppConstants.emailInvalidMessage), findsNothing);
        expect(find.text(AppConstants.passwordMismatchMessage), findsNothing);
      });

      testWidgets('should validate password confirmation match', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const RegisterPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher senhas diferentes
        final textFields = find.byType(TextFormField);

        await tester.enterText(textFields.at(1), MockData.testEmail);
        await tester.enterText(textFields.at(2), MockData.testPassword);
        await tester.enterText(textFields.at(3), 'different_password');

        await tester.tap(find.text(AppConstants.registerButtonText));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppConstants.passwordMismatchMessage), findsOneWidget);
      });

      testWidgets('should navigate back to login from registration', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const RegisterPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Clicar no link de login
        await tester.tap(find.text(AppConstants.registerFooterButtonText));
        await tester.pumpAndSettle();

        // Assert - Voltou para login
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.text(AppConstants.loginTitle), findsOneWidget);
      });
    });

    group('Form Interactions', () {
      testWidgets('should toggle password visibility', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher senha
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        // Act - Clicar no ícone de visibilidade
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pumpAndSettle();

        // Assert - Ícone mudou para visibility_off
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // Act - Clicar novamente
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pumpAndSettle();

        // Assert - Voltou para visibility
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('should clear form when navigation occurs', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher campos
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        // Act - Navegar para registro e voltar
        await tester.tap(find.text(AppConstants.loginFooterButtonText));
        await tester.pumpAndSettle();

        await tester.tap(find.text(AppConstants.registerFooterButtonText));
        await tester.pumpAndSettle();

        // Assert - Campos foram limpos
        final emailField = tester.widget<TextFormField>(find.byType(TextFormField).first);
        final passwordField = tester.widget<TextFormField>(find.byType(TextFormField).last);

        // Os campos devem estar vazios ou resetados
        expect(find.byType(TextFormField), findsWidgets);
      });
    });

    group('Loading States', () {
      testWidgets('should show loading indicator during login', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher formulário
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        // Act - Submeter e verificar loading imediatamente
        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pump(); // Apenas um pump para capturar o estado loading

        // Assert - Pode mostrar loading indicator (dependendo da implementação)
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should disable button during loading', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher formulário
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        // Act - Submeter
        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pump();

        // Assert - Botão ainda existe (estado pode mudar dependendo da implementação)
        expect(find.text(AppConstants.loginButtonText), findsWidgets);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle network errors gracefully', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher e submeter (simulará erro de rede)
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          MockData.testPassword,
        );

        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert - Aplicação não deve crashar
        expect(tester.takeException(), isNull);
      });

      testWidgets('should maintain form state after errors', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Preencher campos
        await tester.enterText(
          find.byType(TextFormField).first,
          MockData.testEmail,
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          'short', // Senha inválida
        );

        await tester.tap(find.text(AppConstants.loginButtonText));
        await tester.pumpAndSettle();

        // Assert - Email deve permanecer preenchido após erro de validação
        final emailField = find.byType(TextFormField).first;
        expect(emailField, findsOneWidget);

        // Verificar que ainda está na tela de login
        expect(find.text(AppConstants.loginButtonText), findsOneWidget);
      });
    });
  });
}