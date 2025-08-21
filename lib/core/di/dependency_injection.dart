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

  static FirebaseAuthServiceImpl? _authService;
  static FirestoreServiceImpl? _firestoreService;
  static AuthLocalDatasource? _authLocalDatasource;
  static AuthRemoteDatasource? _authRemoteDatasource;
  static ProfileFirestoreDatasource? _profileFirestoreDatasource;
  static PostsRemoteDatasource? _postsRemoteDatasource;
  static DioHttpService? _dioHttpService;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    // Crie todas as instâncias de serviços e datasources aqui
    _authService = FirebaseAuthServiceImpl();
    _firestoreService = FirestoreServiceImpl();
    _authLocalDatasource = AuthLocalDatasource(sharedPreferences: _sharedPreferences!);
    _authRemoteDatasource = AuthRemoteDatasource(firebaseAuthService: _authService!);
    _profileFirestoreDatasource = ProfileFirestoreDatasource(firestoreService: _firestoreService!);
    _dioHttpService = DioHttpService();
    _postsRemoteDatasource = PostsRemoteDatasource(httpService: _dioHttpService!);

    // Crie as instâncias de repositórios usando as dependências criadas
    _authRepository = AuthRepository(
      remoteDatasource: _authRemoteDatasource!,
      localDatasource: _authLocalDatasource!,
    );

    _postsRepository = PostsRepository(
      remoteDatasource: _postsRemoteDatasource!,
    );

    _profileRepository = ProfileRepository(
      datasource: _profileFirestoreDatasource!,
    );
  }

  static List<Provider> get providers => [
    Provider<GetUserByIdUseCase>(
      create: (context) => GetUserByIdUseCase(repository: _postsRepository!),
    ),
    Provider<GetProfileUseCase>(
      create: (context) => GetProfileUseCase(repository: _profileRepository!),
    ),
    Provider<CreateProfileUseCase>(
      create: (context) => CreateProfileUseCase(repository: _profileRepository!),
    ),
    Provider<UpdateProfileUseCase>(
      create: (context) => UpdateProfileUseCase(repository: _profileRepository!),
    ),
  ];

  static List<BlocProvider> get blocProviders => [
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        loginUseCase: LoginUseCase(repository: _authRepository!),
        registerUseCase: RegisterUseCase(repository: _authRepository!),
        logoutUseCase: LogoutUseCase(repository: _authRepository!),
        getCurrentUserUseCase: GetCurrentUserUseCase(repository: _authRepository!),
        checkAuthStatusUseCase: CheckAuthStatusUseCase(repository: _authRepository!),
      ),
    ),

    BlocProvider<PostsBloc>(
      create: (context) => PostsBloc(
        getPostsUseCase: GetPostsUseCase(repository: _postsRepository!),
      ),
    ),

    BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        getProfileUseCase: GetProfileUseCase(repository: _profileRepository!),
        createProfileUseCase: CreateProfileUseCase(repository: _profileRepository!),
        updateProfileUseCase: UpdateProfileUseCase(repository: _profileRepository!),
        profileRepository: _profileRepository!,
      ),
    ),
  ];

}