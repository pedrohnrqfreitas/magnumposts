class AppConstants {
  // App Info
  static const String appName = 'Magnum Posts';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplicativo de posts para o desafio Magnum Bank';

  // Timeouts
  static const int connectionTimeout = 10; // seconds
  static const int receiveTimeout = 10; // seconds
  static const int sendTimeout = 10; // seconds

  // Pagination
  static const int defaultPostsPerPage = 10;
  static const int maxPostsPerPage = 50;

  // Text Limits
  static const int postBodyTruncateLimit = 100;
  static const int maxProfileNameLength = 50;
  static const int maxInterestsCount = 10;
  static const int maxInterestLength = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minAge = 1;
  static const int maxAge = 120;

  // Cache Duration
  static const Duration profileCacheDuration = Duration(hours: 1);
  static const Duration postsCacheDuration = Duration(minutes: 30);

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double avatarRadius = 20.0;
  static const double buttonHeight = 56.0;

  // Colors (as backup if theme fails)
  static const int primaryColorValue = 0xFF667eea;
  static const int secondaryColorValue = 0xFF764ba2;

  // Error Messages
  static const String genericErrorMessage = 'Algo deu errado. Tente novamente.';
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String timeoutErrorMessage = 'Tempo limite excedido. Tente novamente.';

  // Success Messages
  static const String loginSuccessMessage = 'Login realizado com sucesso!';
  static const String registerSuccessMessage = 'Conta criada com sucesso!';
  static const String profileUpdatedMessage = 'Perfil atualizado com sucesso!';
  static const String profileCreatedMessage = 'Perfil criado com sucesso!';
}
