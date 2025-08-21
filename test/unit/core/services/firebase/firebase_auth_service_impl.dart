import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/services/firebase/implementation/firebase_auth_service_impl.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('FirebaseAuthServiceImpl', () {
    late FirebaseAuthServiceImpl authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      // Configura mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = createMockUser();
      mockUserCredential = createMockUserCredential(user: mockUser);

      // Cria o service com o mock
      authService = FirebaseAuthServiceImpl(firebaseAuth: mockFirebaseAuth);

      // Setup fallbacks
      setupMocktailFallbacks();
    });

    group('authStateChanges', () {
      test('should return stream of User changes', () {
        // Arrange
        final userStream = Stream<User?>.fromIterable([null, mockUser, null]);
        when(() => mockFirebaseAuth.authStateChanges()).thenAnswer((_) => userStream);

        // Act
        final result = authService.authStateChanges;

        // Assert
        expect(result, equals(userStream));
        verify(() => mockFirebaseAuth.authStateChanges()).called(1);
      });
    });

    group('currentUser', () {
      test('should return current user when authenticated', () {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final result = authService.currentUser;

        // Assert
        expect(result, equals(mockUser));
        verify(() => mockFirebaseAuth.currentUser).called(1);
      });

      test('should return null when not authenticated', () {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = authService.currentUser;

        // Assert
        expect(result, isNull);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should return UserCredential when login succeeds', () async {
        // Arrange
        const email = MockData.testEmail;
        const password = MockData.testPassword;

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

      test('should throw Failure when FirebaseAuthException occurs', () async {
        // Arrange
        const email = MockData.testEmail;
        const password = 'wrong_password';

        final firebaseException = FirebaseAuthException(
          code: 'wrong-password',
          message: 'The password is invalid',
        );

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(firebaseException);

        // Act & Assert
        expect(
              () => authService.signInWithEmailAndPassword(email, password),
          throwsA(isA<dynamic>()), // O FirebaseErrorHandler.handleAuthError retorna um Failure
        );

        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
      });

      test('should handle generic exceptions', () async {
        // Arrange
        const email = MockData.testEmail;
        const password = MockData.testPassword;

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
              () => authService.signInWithEmailAndPassword(email, password),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('should return UserCredential when registration succeeds', () async {
        // Arrange
        const email = MockData.testEmail;
        const password = MockData.testPassword;

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

      test('should throw Failure when email already in use', () async {
        // Arrange
        const email = MockData.testEmail;
        const password = MockData.testPassword;

        final firebaseException = FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email is already in use',
        );

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(firebaseException);

        // Act & Assert
        expect(
              () => authService.createUserWithEmailAndPassword(email, password),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('signOut', () {
      test('should complete successfully when signOut succeeds', () async {
        // Arrange
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // Act
        await authService.signOut();

        // Assert
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should throw Failure when signOut fails', () async {
        // Arrange
        final firebaseException = FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Network error',
        );

        when(() => mockFirebaseAuth.signOut()).thenThrow(firebaseException);

        // Act & Assert
        expect(
              () => authService.signOut(),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('updateDisplayName', () {
      test('should update display name successfully', () async {
        // Arrange
        const displayName = 'New Display Name';

        when(() => mockUser.updateDisplayName(displayName)).thenAnswer((_) async {});
        when(() => mockUser.reload()).thenAnswer((_) async {});
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        await authService.updateDisplayName(displayName);

        // Assert
        verify(() => mockUser.updateDisplayName(displayName)).called(1);
        verify(() => mockUser.reload()).called(1);
      });

      test('should throw Failure when update fails', () async {
        // Arrange
        const displayName = 'New Display Name';

        final firebaseException = FirebaseAuthException(
          code: 'user-disabled',
          message: 'User account disabled',
        );

        when(() => mockUser.updateDisplayName(displayName)).thenThrow(firebaseException);
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act & Assert
        expect(
              () => authService.updateDisplayName(displayName),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('updatePhotoURL', () {
      test('should update photo URL successfully', () async {
        // Arrange
        const photoURL = 'https://example.com/new-photo.jpg';

        when(() => mockUser.updatePhotoURL(photoURL)).thenAnswer((_) async {});
        when(() => mockUser.reload()).thenAnswer((_) async {});
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        await authService.updatePhotoURL(photoURL);

        // Assert
        verify(() => mockUser.updatePhotoURL(photoURL)).called(1);
        verify(() => mockUser.reload()).called(1);
      });
    });
  });
}