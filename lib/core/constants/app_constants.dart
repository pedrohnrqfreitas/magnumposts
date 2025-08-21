class AppConstants {
  // Text Limits
  static const int maxProfileNameLength = 50;
  static const int maxInterestsCount = 10;
  static const int maxInterestLength = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minAge = 1;
  static const int maxAge = 120;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants - Dimensions (múltiplos de 8)
  static const double dimenBase = 8;
  static const double dimenXxxs = 16;
  static const double dimenXxs = 24;
  static const double dimenXs = 32;
  static const double dimenS = 40;
  static const double dimenM = 48;
  static const double dimenL = 56;
  static const double dimenXl = 64;
  static const double dimenXxl = 72;
  static const double dimenXxxl = 80;

  // Padding & Margin
  static const double paddingXxs = 8;
  static const double paddingXs = 12;
  static const double paddingS = 16;
  static const double paddingM = 20;
  static const double paddingL = 24;
  static const double paddingXl = 32;

  static const double marginXs = 8;
  static const double marginS = 12;
  static const double marginM = 16;
  static const double marginL = 24;
  static const double marginXl = 32;

  // Border Radius
  static const double borderRadius = 12.0;
  static const double borderRadiusS = 8.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXl = 20.0;

  // Avatar Sizes
  static const double avatarRadius = 20.0;
  static const double avatarRadiusS = 16.0;
  static const double avatarRadiusM = 20.0;
  static const double avatarRadiusL = 24.0;
  static const double avatarRadiusXl = 32.0;

  static const double avatarSizeXs = 32.0;
  static const double avatarSizeS = 40.0;
  static const double avatarSizeM = 48.0;
  static const double avatarSizeL = 56.0;
  static const double avatarSizeXl = 64.0;

  // Button & Card
  static const double buttonHeight = 56.0;
  static const double cardElevation = 2.0;
  static const double cardElevationLow = 1.0;
  static const double cardElevationHigh = 4.0;

  // Font Sizes (múltiplos de 2 ou 4)
  static const double fontSizeXxxs = 10;
  static const double fontSizeXxs = 12;
  static const double fontSizeXs = 14;
  static const double fontSizeS = 16;
  static const double fontSizeM = 18;
  static const double fontSizeL = 20;
  static const double fontSizeXl = 24;
  static const double fontSizeXxl = 28;
  static const double fontSizeXxxl = 32;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightCompact = 1.3;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightLoose = 1.6;

  // Icon Sizes (múltiplos de 8)
  static const double iconSizeXxs = 12;
  static const double iconSizeXs = 16;
  static const double iconSizeS = 20;
  static const double iconSizeM = 24;
  static const double iconSizeL = 32;
  static const double iconSizeXl = 40;
  static const double iconSizeXxl = 48;

  // Text MaxLines
  static const int maxLinesTitle = 2;
  static const int maxLinesSubtitle = 3;
  static const int maxLinesSingle = 1;
  static const int maxLinesContent = 5;

  // UI Specific - Posts
  static const int skeletonItemCount = 6;
  static const int postsPerPage = 10;
  static const double scrollThreshold = 0.8;

  // Colors (as backup if theme fails)
  static const int primaryColorValue = 0xFF667eea;
  static const int secondaryColorValue = 0xFF764ba2;

  // Text Colors
  static const int textColorPrimaryValue = 0xFF2D3748;
  static const int textColorSecondaryValue = 0xFF4A5568;
  static const int textColorTertiaryValue = 0xFF718096;
  static const int textColorPlaceholderValue = 0xFFA0AEC0;

  // Background Colors
  static const int backgroundColorLightValue = 0xFFF7FAFC;
  static const int backgroundColorCardValue = 0xFFFFFFFF;
  static const int borderColorLightValue = 0xFFE2E8F0;

  // Error Messages
  static const String genericErrorMessage = 'Algo deu errado. Tente novamente.';
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String timeoutErrorMessage = 'Tempo limite excedido. Tente novamente.';
  static const String noPostsErrorMessage = 'Nenhum post encontrado.';
  static const String loadingPostsMessage = 'Carregando posts...';
  static const String loadingAuthorMessage = 'Carregando autor...';

  // Success Messages
  static const String loginSuccessMessage = 'Login realizado com sucesso!';
  static const String registerSuccessMessage = 'Conta criada com sucesso!';
  static const String profileUpdatedMessage = 'Perfil atualizado com sucesso!';
  static const String profileCreatedMessage = 'Perfil criado com sucesso!';

  // Post Messages
  static const String seeMoreText = 'Ver mais';
  static const String postDetailTitle = 'Detalhes do Post';
  static const String contentSectionTitle = 'Conteúdo';
  static const String logoutConfirmTitle = 'Confirmar Logout';
  static const String logoutConfirmMessage = 'Tem certeza que deseja sair?';
  static const String logoutButtonText = 'Sair';
  static const String cancelButtonText = 'Cancelar';

  // User Messages
  static const String authorErrorMessage = 'Erro ao carregar autor';
  static const String userFallbackPrefix = 'Usuário ';
  static const String postIdPrefix = 'Post #';

  // Profile Messages
  static const String createProfileTitle = 'Criar Perfil';
  static const String editProfileTitle = 'Editar Perfil';
  static const String profileDetailTitle = 'Perfil do Usuário';
  static const String createProfileSubtitle = 'Preencha suas informações básicas';
  static const String editProfileSubtitle = 'Atualize suas informações pessoais';
  static const String profileNotFoundTitle = 'Perfil não encontrado';
  static const String profileNotFoundMessage = 'Este usuário ainda não possui um perfil criado.';
  static const String profileSuccessTitle = 'Perfil criado com sucesso!';
  static const String profileSuccessMessage = 'Seu novo perfil já está disponível.';
  static const String loadingProfileMessage = 'Carregando perfil...';
  static const String creatingProfileMessage = 'Criando...';
  static const String savingProfileMessage = 'Salvando...';
  static const String createProfileButtonText = 'Criar perfil';
  static const String saveProfileButtonText = 'Salvar alterações';
  static const String memberSinceText = 'Membro há ';
  static const String ageUnitText = ' anos';
  static const String noInterestsText = 'Nenhum interesse informado';

  // Form Labels
  static const String nameFieldLabel = 'Nome completo';
  static const String nameFieldHint = 'Digite seu nome completo';
  static const String ageFieldLabel = 'Idade (opcional)';
  static const String ageFieldHint = 'Digite sua idade';
  static const String interestsFieldLabel = 'Interesses (opcional)';
  static const String interestsFieldHint = 'Ex: tecnologia, música, esportes';
  static const String interestsFieldHelper = 'Separe os interesses por vírgula';

  // Validation Messages
  static const String nameRequiredMessage = 'Nome é obrigatório';
  static const String invalidAgeMessage = 'Digite uma idade válida (1-120)';

  // Stats Labels
  static const String postsStatsLabel = 'Posts';
  static const String ageStatsLabel = 'Idade';
  static const String interestsStatsLabel = 'Interesses';
  static const String ageNotAvailable = 'N/A';

  // Profile Specific Dimensions
  static const double profileImageSize = 120;
  static const double profileImageRadius = 60;
  static const double statsContainerHeight = 40;
  static const double statsDividerWidth = 1;

  // Authentication Messages
  static const String appTitle = 'Magnum Posts';
  static const String appSubtitle = 'Seu app de posts favorito';
  static const String loginTitle = 'Magnum Posts';
  static const String loginSubtitle = 'Entre com seu email e senha';
  static const String registerTitle = 'Criar Conta';
  static const String registerSubtitle = 'Preencha os dados para se cadastrar';
  static const String loginButtonText = 'Entrar';
  static const String registerButtonText = 'Criar Conta';
  static const String loginFooterText = 'Não tem uma conta?';
  static const String loginFooterButtonText = 'Criar conta';
  static const String registerFooterText = 'Já tem uma conta?';
  static const String registerFooterButtonText = 'Fazer login';
  static const String loggingInMessage = 'Realizando login...';
  static const String creatingAccountMessage = 'Criando conta...';
  static const String verifyingAuthMessage = 'Verificando autenticação...';

  // Form Labels - Authentication
  static const String emailFieldLabel = 'Email';
  static const String emailFieldHint = 'Digite seu email';
  static const String passwordFieldLabel = 'Senha';
  static const String passwordFieldHint = 'Digite sua senha';
  static const String confirmPasswordFieldLabel = 'Confirmar Senha';
  static const String confirmPasswordFieldHint = 'Confirme sua senha';
  static const String nameFieldOptionalLabel = 'Nome completo (opcional)';

  // Validation Messages - Authentication
  static const String emailRequiredMessage = 'Email é obrigatório';
  static const String emailInvalidMessage = 'Por favor, insira um email válido';
  static const String passwordRequiredMessage = 'Senha é obrigatória';
  static const String passwordMinLengthMessage = 'Senha deve ter pelo menos 6 caracteres';
  static const String confirmPasswordRequiredMessage = 'Confirmação de senha é obrigatória';
  static const String passwordMismatchMessage = 'Senhas não coincidem';
  static const String allFieldsRequiredMessage = 'Todos os campos são obrigatórios';

  // Success Messages - Authentication
  static const String accountCreatedMessage = 'Conta criada com sucesso! Faça login para continuar.';
  static const String redirectingMessage = 'Redirecionando para login...';

  // Splash Messages
  static const String splashTitle = 'Magnum Posts';
  static const String splashSubtitle = 'Seu app de posts favorito';

  // Authentication Specific Dimensions
  static const double authIconSize = 100;
  static const double authHeaderIconSize = 80;
  static const double authHeaderIconRadius = 20;
  static const double authCardElevation = 0;
  static const double authInputBorderWidth = 1;
  static const double authInputFocusedBorderWidth = 2;
}