import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../dto/request/login_request_dto.dart';
import '../../dto/request/register_request_dto.dart';
import '../../dto/request/update_profile_request_dto.dart';
import '../../dto/response/auth_response_dto.dart';
import '../../dto/response/user_response_dto.dart';
import '../i_auth_datasource.dart';

class AuthLocalDatasource implements IAuthDatasource {
  final SharedPreferences sharedPreferences;

  AuthLocalDatasource({required this.sharedPreferences});

  @override
  Future<UserResponseDTO?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(FirebaseConstants.userDataKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return UserResponseDTO.fromMap(json);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao recuperar usuário do cache: $e');
    }
  }

  @override
  Future<void> cacheUser(UserResponseDTO user) async {
    try {
      final jsonString = jsonEncode(user.toMap());
      await sharedPreferences.setString(FirebaseConstants.userDataKey, jsonString);
    } catch (e) {
      throw Exception('Erro ao salvar usuário no cache: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(FirebaseConstants.userDataKey);
      await sharedPreferences.remove(FirebaseConstants.userTokenKey);
    } catch (e) {
      throw Exception('Erro ao limpar cache: $e');
    }
  }

  @override
  Stream<UserResponseDTO?> get authStateChanges {
    throw UnimplementedError('Use AuthRemoteDatasource para operações remotas');
  }

  @override
  UserResponseDTO? get currentUser {
    throw UnimplementedError('Use AuthRemoteDatasource para operações remotas');
  }

  @override
  Future<AuthResponseDTO> login(LoginRequestDTO request) async {
    throw UnimplementedError('Use AuthRemoteDatasource para operações remotas');
  }

  @override
  Future<AuthResponseDTO> register(RegisterRequestDTO request) async {
    throw UnimplementedError('Use AuthRemoteDatasource para operações remotas');
  }

  @override
  Future<void> logout() async {
    await clearCache();
  }

  @override
  Future<UserResponseDTO> updateProfile(UpdateProfileRequestDTO request) async {
    throw UnimplementedError('Use AuthRemoteDatasource para operações remotas');
  }
}