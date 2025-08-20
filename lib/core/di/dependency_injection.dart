import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Services
import '../../data/posts/repository/implementation/posts_repository.dart';
import '../../data/profile/repository/implementation/profile_repository.dart';
import '../../features/profile/usecases/create_profile_usecase.dart';
import '../../features/profile/usecases/get_profile_usecase.dart';
import '../../features/profile/usecases/update_profile_usecase.dart';
import '../services/http/implementation/dio_http_service.dart';
import '../services/firebase/implementation/firebase_auth_service_impl.dart';
import '../services/firestore/implementation/firestore_service_impl.dart';

// Authentication
import '../../data/authentication/datasource/implementation/auth_local_datasource.dart';
import '../../data/authentication/datasource/implementation/auth_remote_datasource.dart';
import '../../data/authentication/repositories/implementation/auth_repository.dart';
import '../../features/authentication/usercase/login_usecase.dart';
import '../../features/authentication/usercase/register_usecase.dart';
import '../../features/authentication/usercase/logout_usecase.dart';
import '../../features/authentication/usercase/get_current_user_usecase.dart';
import '../../features/authentication/usercase/check_auth_status_usecase.dart';
import '../../features/authentication/ui/bloc/auth_bloc.dart';

// Posts
import '../../data/posts/datasource/implementation/posts_remote_datasource.dart';
import '../../features/posts/usecase/get_posts_usecase.dart';
import '../../features/posts/usecase/get_user_by_id_usecase.dart';
import '../../features/posts/ui/bloc/posts_bloc.dart';

// Profile
import '../../data/profile/datasource/implementation/profile_firestore_datasource.dart';
import '../../features/profile/ui/bloc/profile_bloc.dart';

class DependencyInjection {
  static SharedPreferences? _sharedPreferences;
  static AuthRepository? _authRepository;
  static PostsRepository? _postsRepository;
  static ProfileRepository? _profileRepository;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static List<Provider> get providers => [
    // Use Cases que podem ser acessados diretamente
    Provider<GetUserByIdUseCase>(
      create: (context) => GetUserByIdUseCase(repository: _getPostsRepository()),
    ),
    Provider<GetProfileUseCase>(
      create: (context) => GetProfileUseCase(repository: _getProfileRepository()),
    ),
    Provider<CreateProfileUseCase>(
      create: (context) => CreateProfileUseCase(repository: _getProfileRepository()),
    ),
    Provider<UpdateProfileUseCase>(
      create: (context) => UpdateProfileUseCase(repository: _getProfileRepository()),
    ),
  ];

  static List<BlocProvider> get blocProviders => [
    // Auth BLoC
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        loginUseCase: LoginUseCase(repository: _getAuthRepository()),
        registerUseCase: RegisterUseCase(repository: _getAuthRepository()),
        logoutUseCase: LogoutUseCase(repository: _getAuthRepository()),
        getCurrentUserUseCase: GetCurrentUserUseCase(repository: _getAuthRepository()),
        checkAuthStatusUseCase: CheckAuthStatusUseCase(repository: _getAuthRepository()),
      ),
    ),

    // Posts BLoC
    BlocProvider<PostsBloc>(
      create: (context) => PostsBloc(
        getPostsUseCase: GetPostsUseCase(repository: _getPostsRepository()),
      ),
    ),

    // Profile BLoC
    BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        getProfileUseCase: GetProfileUseCase(repository: _getProfileRepository()),
        createProfileUseCase: CreateProfileUseCase(repository: _getProfileRepository()),
        updateProfileUseCase: UpdateProfileUseCase(repository: _getProfileRepository()),
        profileRepository: _getProfileRepository(),
      ),
    ),
  ];

  // Singleton Repositories
  static AuthRepository _getAuthRepository() {
    _authRepository ??= AuthRepository(
      remoteDatasource: AuthRemoteDatasource(
        firebaseAuthService: FirebaseAuthServiceImpl(),
      ),
      localDatasource: AuthLocalDatasource(
        sharedPreferences: _sharedPreferences!,
      ),
    );
    return _authRepository!;
  }

  static PostsRepository _getPostsRepository() {
    _postsRepository ??= PostsRepository(
      remoteDatasource: PostsRemoteDatasource(
        httpService: DioHttpService(),
      ),
    );
    return _postsRepository!;
  }

  static ProfileRepository _getProfileRepository() {
    _profileRepository ??= ProfileRepository(
      datasource: ProfileFirestoreDatasource(
        firestoreService: FirestoreServiceImpl(),
      ),
    );
    return _profileRepository!;
  }
}
