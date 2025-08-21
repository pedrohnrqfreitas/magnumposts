import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:magnumposts/core/services/firebase/firebase_auth_service.dart';
import 'package:magnumposts/core/services/firestore/firestore_service.dart';
import 'package:magnumposts/core/services/http/http_service.dart';
import 'package:magnumposts/data/authentication/datasource/i_auth_datasource.dart';
import 'package:magnumposts/data/posts/datasource/i_posts_datasource.dart';
import 'package:magnumposts/data/profile/datasource/i_profile_datasource.dart';
import 'package:magnumposts/data/authentication/repositories/i_auth_repository.dart';
import 'package:magnumposts/data/posts/repository/i_posts_repository.dart';
import 'package:magnumposts/data/profile/repository/i_profile_repository.dart';

// ========================================
// MOCKS DOS SERVICES EXTERNOS
// ========================================

/// Mock do Firebase Auth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mock do Firebase User
class MockUser extends Mock implements User {}

/// Mock do UserCredential
class MockUserCredential extends Mock implements UserCredential {}

/// Mock do UserMetadata
class MockUserMetadata extends Mock implements UserMetadata {}

/// Mock do Firestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

/// Mock do DocumentSnapshot
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

/// Mock do CollectionReference
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

/// Mock do DocumentReference
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

/// Mock do Dio
class MockDio extends Mock implements Dio {}

/// Mock do Response
class MockResponse extends Mock implements Response {}

/// Mock do SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

// ========================================
// MOCKS DOS NOSSOS SERVICES
// ========================================

/// Mock do nosso FirebaseAuthService
class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

/// Mock do nosso FirestoreService
class MockFirestoreService extends Mock implements FirestoreService {}

/// Mock do nosso HttpService
class MockHttpService extends Mock implements HttpService {}

// ========================================
// MOCKS DOS DATASOURCES
// ========================================

/// Mock do AuthDatasource
class MockAuthRemoteDatasource extends Mock implements IAuthDatasource {}

/// Mock do AuthLocalDatasource
class MockAuthLocalDatasource extends Mock implements IAuthDatasource {}

/// Mock do PostsDatasource
class MockPostsDatasource extends Mock implements IPostsDatasource {}

/// Mock do ProfileDatasource
class MockProfileDatasource extends Mock implements IProfileDatasource {}

// ========================================
// MOCKS DOS REPOSITORIES
// ========================================

/// Mock do AuthRepository
class MockAuthRepository extends Mock implements IAuthRepository {}

/// Mock do PostsRepository
class MockPostsRepository extends Mock implements IPostsRepository {}

/// Mock do ProfileRepository
class MockProfileRepository extends Mock implements IProfileRepository {}

// ========================================
// HELPER FUNCTIONS
// ========================================

/// Configura fallback values para o Mocktail
void setupMocktailFallbacks() {
  // Registra fallback values para tipos que o mocktail precisa
  registerFallbackValue(const Duration(seconds: 1));
  registerFallbackValue(<String, dynamic>{});
  registerFallbackValue(Uri.parse('https://example.com'));
}

/// Cria um User mock com dados padrão
MockUser createMockUser({
  String uid = 'test_uid_123',
  String? email = 'test@example.com',
  String? displayName = 'Test User',
  String? photoURL,
  bool emailVerified = true,
}) {
  final mockUser = MockUser();
  final mockMetadata = MockUserMetadata();

  when(() => mockUser.uid).thenReturn(uid);
  when(() => mockUser.email).thenReturn(email);
  when(() => mockUser.displayName).thenReturn(displayName);
  when(() => mockUser.photoURL).thenReturn(photoURL);
  when(() => mockUser.emailVerified).thenReturn(emailVerified);
  when(() => mockUser.metadata).thenReturn(mockMetadata);

  // Configurar metadata
  when(() => mockMetadata.creationTime).thenReturn(DateTime.now());
  when(() => mockMetadata.lastSignInTime).thenReturn(DateTime.now());

  return mockUser;
}

/// Cria um UserCredential mock
MockUserCredential createMockUserCredential({
  User? user,
}) {
  final mockCredential = MockUserCredential();
  when(() => mockCredential.user).thenReturn(user ?? createMockUser());
  return mockCredential;
}

/// Cria um Response mock do Dio
MockResponse createMockDioResponse({
  dynamic data,
  int statusCode = 200,
  String statusMessage = 'OK',
}) {
  final mockResponse = MockResponse();
  when(() => mockResponse.data).thenReturn(data);
  when(() => mockResponse.statusCode).thenReturn(statusCode);
  when(() => mockResponse.statusMessage).thenReturn(statusMessage);
  return mockResponse;
}

/// Aguarda o próximo frame - útil para testes de widgets
Future<void> pumpAndSettle() async {
  await Future.delayed(const Duration(milliseconds: 100));
}