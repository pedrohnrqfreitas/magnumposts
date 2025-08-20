import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/firebase/firebase_auth_service.dart';
import '../../dto/request/login_request_dto.dart';
import '../../dto/request/register_request_dto.dart';
import '../../dto/request/update_profile_request_dto.dart';
import '../../dto/response/auth_response_dto.dart';
import '../../dto/response/user_response_dto.dart';
import '../i_auth_datasource.dart';

class AuthRemoteDatasource implements IAuthDatasource {
  final FirebaseAuthService firebaseAuthService;

  AuthRemoteDatasource({required this.firebaseAuthService});

  @override
  Stream<UserResponseDTO?> get authStateChanges {
    return firebaseAuthService.authStateChanges.map((user) {
      return user != null ? _userToDTO(user) : null;
    });
  }

  @override
  UserResponseDTO? get currentUser {
    final user = firebaseAuthService.currentUser;
    return user != null ? _userToDTO(user) : null;
  }

  @override
  Future<AuthResponseDTO> login(LoginRequestDTO request) async {
    try {
      final userCredential = await firebaseAuthService.signInWithEmailAndPassword(
        request.email,
        request.password,
      );

      if (userCredential.user == null) {
        return AuthResponseDTO(
          success: false,
          message: 'Falha na autenticação',
        );
      }

      return AuthResponseDTO(
        user: _userToDTO(userCredential.user!),
        success: true,
        message: 'Login realizado com sucesso',
      );
    } catch (e) {
      return AuthResponseDTO(
        success: false,
        //TODO tratar error
        message: e.toString(),
      );
    }
  }

  @override
  Future<AuthResponseDTO> register(RegisterRequestDTO request) async {
    try {
      final userCredential = await firebaseAuthService.createUserWithEmailAndPassword(
        request.email,
        request.password,
      );

      if (userCredential.user == null) {
        return AuthResponseDTO(
          success: false,
          message: 'Falha no cadastro',
        );
      }

      // Atualizar displayName se fornecido
      if (request.displayName != null) {
        await firebaseAuthService.updateDisplayName(request.displayName!);
      }

      return AuthResponseDTO(
        user: _userToDTO(userCredential.user!),
        success: true,
        message: 'Cadastro realizado com sucesso',
      );
    } catch (e) {
      return AuthResponseDTO(
        success: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuthService.signOut();
  }

  @override
  Future<UserResponseDTO> updateProfile(UpdateProfileRequestDTO request) async {
    try {
      if (request.displayName != null) {
        await firebaseAuthService.updateDisplayName(request.displayName!);
      }

      if (request.photoURL != null) {
        await firebaseAuthService.updatePhotoURL(request.photoURL!);
      }

      final user = firebaseAuthService.currentUser;
      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      return _userToDTO(user);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  UserResponseDTO _userToDTO(User user) {
    return UserResponseDTO(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      lastSignInTime: user.metadata.lastSignInTime?.toIso8601String(),
      creationTime: user.metadata.creationTime?.toIso8601String(),
    );
  }

  @override
  Future<UserResponseDTO?> getCachedUser() async {
    // Remote datasource não implementa cache
    throw UnimplementedError('Use AuthLocalDatasource para cache');
  }

  @override
  Future<void> cacheUser(UserResponseDTO user) async {
    // Remote datasource não implementa cache
    throw UnimplementedError('Use AuthLocalDatasource para cache');
  }

  @override
  Future<void> clearCache() async {
    // Remote datasource não implementa cache
    throw UnimplementedError('Use AuthLocalDatasource para cache');
  }
}