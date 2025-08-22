import 'package:flutter_test/flutter_test.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/data/posts/models/user_post_model.dart';
import 'package:magnumposts/data/authentication/models/user_model.dart';
import 'package:magnumposts/data/profile/models/profile_model.dart';

/// Helper class para criar objetos de teste comuns
class TestHelpers {

  /// Cria um PostModel de exemplo para testes
  static PostModel createMockPost({
    int id = 1,
    int userId = 1,
    String title = 'Test Post Title',
    String body = 'Test post body content',
  }) {
    return PostModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
    );
  }

  /// Cria uma lista de posts para testes
  static List<PostModel> createMockPosts(int count) {
    return List.generate(
      count,
          (index) => createMockPost(
        id: index + 1,
        userId: 1,
        title: 'Post ${index + 1}',
        body: 'Body content ${index + 1}',
      ),
    );
  }

  /// Cria um UserPostModel de exemplo para testes
  static UserPostModel createMockUserPost({
    int id = 1,
    String name = 'Test User',
    String username = 'testuser',
    String email = 'test@test.com',
  }) {
    return UserPostModel(
      id: id,
      name: name,
      username: username,
      email: email,
    );
  }

  /// Cria um UserModel de exemplo para testes
  static UserModel createMockUser({
    String uid = 'user123',
    String email = 'test@test.com',
    String? displayName = 'Test User',
    bool emailVerified = true,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      emailVerified: emailVerified,
      createdAt: DateTime(2023, 1, 1),
    );
  }

  /// Cria um ProfileModel de exemplo para testes
  static ProfileModel createMockProfile({
    String userId = 'user123',
    String name = 'Test User',
    int postsCount = 5,
    int? age = 25,
    List<String>? interests,
  }) {
    return ProfileModel(
      userId: userId,
      name: name,
      postsCount: postsCount,
      age: age,
      interests: interests ?? ['tecnologia', 'música'],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );
  }
}

/// Setup comum para todos os testes
void setupTestDependencies() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Registra fallback values comuns para mocktail
void registerCommonFallbackValues() {
  // Registra tipos comuns aqui se necessário
}

/// Extensão para facilitar assertions em testes
extension TestAssertions on Object? {
  void shouldBeA<T>() {
    expect(this, isA<T>());
  }

  void shouldEqual(Object? expected) {
    expect(this, equals(expected));
  }

  void shouldNotBeNull() {
    expect(this, isNotNull);
  }

  void shouldBeNull() {
    expect(this, isNull);
  }
}