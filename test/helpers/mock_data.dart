import 'package:magnumposts/data/authentication/dto/response/auth_response_dto.dart';
import 'package:magnumposts/data/authentication/dto/response/user_response_dto.dart';
import 'package:magnumposts/data/posts/dto/response/post_response_dto.dart';
import 'package:magnumposts/data/posts/dto/response/user_post_response_dto.dart';
import 'package:magnumposts/data/profile/dto/profile_dto.dart';
import 'package:magnumposts/data/authentication/models/user_model.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/data/posts/models/user_post_model.dart';
import 'package:magnumposts/data/profile/models/profile_model.dart';

class MockData {
  // ========================================
  // AUTH DATA
  // ========================================

  static const String testUserId = 'test_user_123';
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testDisplayName = 'Test User';

  static UserResponseDTO get userResponseDTO => UserResponseDTO(
    uid: testUserId,
    email: testEmail,
    displayName: testDisplayName,
    photoURL: 'https://example.com/avatar.jpg',
    emailVerified: true,
    lastSignInTime: DateTime.now().toIso8601String(),
    creationTime: DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
  );

  static AuthResponseDTO get successAuthResponse => AuthResponseDTO(
    user: userResponseDTO,
    success: true,
    message: 'Login successful',
    accessToken: 'mock_access_token',
  );

  static AuthResponseDTO get failureAuthResponse => AuthResponseDTO(
    success: false,
    message: 'Invalid credentials',
  );

  static UserModel get userModel => UserModel(
    uid: testUserId,
    email: testEmail,
    displayName: testDisplayName,
    photoURL: 'https://example.com/avatar.jpg',
    emailVerified: true,
    lastSignIn: DateTime.now(),
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  // ========================================
  // POSTS DATA
  // ========================================

  static List<PostResponseDTO> get postsResponseDTOList => [
    PostResponseDTO(
      userId: 1,
      id: 1,
      title: 'Test Post 1',
      body: 'This is the body of test post 1. It contains some sample content to test the application.',
    ),
    PostResponseDTO(
      userId: 1,
      id: 2,
      title: 'Test Post 2',
      body: 'This is the body of test post 2. Another sample content for testing purposes.',
    ),
    PostResponseDTO(
      userId: 2,
      id: 3,
      title: 'Test Post 3',
      body: 'This is the body of test post 3. More sample content for comprehensive testing.',
    ),
  ];

  static PostResponseDTO get singlePostResponseDTO => PostResponseDTO(
    userId: 1,
    id: 1,
    title: 'Single Test Post',
    body: 'This is a single post for testing individual post retrieval.',
  );

  static List<PostModel> get postModelList => postsResponseDTOList
      .map((dto) => PostModel.fromDTO(dto))
      .toList();

  static PostModel get singlePostModel => PostModel.fromDTO(singlePostResponseDTO);

  static UserPostResponseDTO get userPostResponseDTO => UserPostResponseDTO(
    id: 1,
    name: 'John Doe',
    username: 'johndoe',
    email: 'john@example.com',
    phone: '+1234567890',
    website: 'johndoe.com',
    address: AddressDTO(
      street: '123 Main St',
      suite: 'Apt 1',
      city: 'Test City',
      zipcode: '12345',
      geo: GeoDTO(lat: '40.7128', lng: '-74.0060'),
    ),
    company: CompanyDTO(
      name: 'Test Company',
      catchPhrase: 'Testing made easy',
      bs: 'test business',
    ),
  );

  static UserPostModel get userPostModel => UserPostModel.fromDTO(userPostResponseDTO);

  // ========================================
  // PROFILE DATA
  // ========================================

  static ProfileDTO get profileDTO => ProfileDTO(
    userId: testUserId,
    name: 'Test User Profile',
    imageUrl: 'https://example.com/profile.jpg',
    postsCount: 5,
    age: 25,
    interests: ['Technology', 'Sports', 'Music'],
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  static ProfileModel get profileModel => ProfileModel.fromDTO(profileDTO);

  // ========================================
  // API RESPONSE DATA (Raw JSON)
  // ========================================

  static Map<String, dynamic> get postJsonResponse => {
    'userId': 1,
    'id': 1,
    'title': 'Test Post',
    'body': 'Test post body content',
  };

  static List<Map<String, dynamic>> get postsJsonResponse => [
    {
      'userId': 1,
      'id': 1,
      'title': 'Test Post 1',
      'body': 'Test post 1 body content',
    },
    {
      'userId': 1,
      'id': 2,
      'title': 'Test Post 2',
      'body': 'Test post 2 body content',
    },
  ];

  static Map<String, dynamic> get userJsonResponse => {
    'id': 1,
    'name': 'John Doe',
    'username': 'johndoe',
    'email': 'john@example.com',
    'phone': '+1234567890',
    'website': 'johndoe.com',
    'address': {
      'street': '123 Main St',
      'suite': 'Apt 1',
      'city': 'Test City',
      'zipcode': '12345',
      'geo': {
        'lat': '40.7128',
        'lng': '-74.0060',
      },
    },
    'company': {
      'name': 'Test Company',
      'catchPhrase': 'Testing made easy',
      'bs': 'test business',
    },
  };

  static Map<String, dynamic> get profileFirestoreData => {
    'userId': testUserId,
    'name': 'Test User Profile',
    'imageUrl': 'https://example.com/profile.jpg',
    'postsCount': 5,
    'age': 25,
    'interests': ['Technology', 'Sports', 'Music'],
    'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  // ========================================
  // ERROR RESPONSES
  // ========================================

  static Exception get networkException => Exception('Network error');
  static Exception get authException => Exception('Authentication failed');
  static Exception get firestoreException => Exception('Firestore error');
  static Exception get notFoundException => Exception('Not found');

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Cria uma lista de posts com quantidade específica
  static List<PostModel> createPostsList(int count) {
    return List.generate(count, (index) => PostModel(
      id: index + 1,
      userId: (index % 3) + 1, // Distribui entre 3 usuários
      title: 'Test Post ${index + 1}',
      body: 'This is the body content for test post ${index + 1}.',
    ));
  }

  /// Cria dados de perfil com parâmetros específicos
  static ProfileModel createProfile({
    String? userId,
    String? name,
    int? age,
    List<String>? interests,
  }) {
    return ProfileModel(
      userId: userId ?? testUserId,
      name: name ?? 'Test User',
      postsCount: 0,
      age: age,
      interests: interests ?? [],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  /// Cria resposta de erro do Dio
  static Map<String, dynamic> get dioErrorResponse => {
    'error': 'Bad Request',
    'message': 'Invalid request parameters',
    'statusCode': 400,
  };
}