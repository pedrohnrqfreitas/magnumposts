import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/services/firebase/implementation/firebase_auth_service_impl.dart';
import 'package:magnumposts/core/errors/failure.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUserMetadata extends Mock implements UserMetadata {}

void main() {
  group('FirebaseAuthServiceImpl', () {
    late FirebaseAuthServiceImpl authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      authService = FirebaseAuthServiceImpl(firebaseAuth: mockFirebaseAuth);
    });

    group('signInWithEmailAndPassword', () {
      test('deve retornar UserCredential quando login for bem-sucedido', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.signInWithEmailAndPassword(email, password);

        // Assert
        expect(result, equals(mockUserCredential));
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
      });

      test('deve lançar Failure quando FirebaseAuthException ocorrer', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        // Act & Assert
        expect(
              () => authService.signInWithEmailAndPassword(email, password),
          throwsA(isA<Failure>()),
        );
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('deve retornar UserCredential quando registro for bem-sucedido', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.createUserWithEmailAndPassword(email, password);

        // Assert
        expect(result, equals(mockUserCredential));
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
      });

      test('deve lançar Failure quando FirebaseAuthException ocorrer', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        // Act & Assert
        expect(
              () => authService.createUserWithEmailAndPassword(email, password),
          throwsA(isA<Failure>()),
        );
      });
    });

    group('signOut', () {
      test('deve chamar signOut do FirebaseAuth', () async {
        // Arrange
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // Act
        await authService.signOut();

        // Assert
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });
    });

    group('currentUser', () {
      test('deve retornar user atual', () {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final result = authService.currentUser;

        // Assert
        expect(result, equals(mockUser));
      });

      test('deve retornar null quando não há usuário logado', () {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = authService.currentUser;

        // Assert
        expect(result, isNull);
      });
    });

    group('updateDisplayName', () {
      test('deve atualizar displayName do usuário atual', () async {
        // Arrange
        const displayName = 'Test User';
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.updateDisplayName(displayName)).thenAnswer((_) async {});
        when(() => mockUser.reload()).thenAnswer((_) async {});

        // Act
        await authService.updateDisplayName(displayName);

        // Assert
        verify(() => mockUser.updateDisplayName(displayName)).called(1);
        verify(() => mockUser.reload()).called(1);
      });
    });
  });
}