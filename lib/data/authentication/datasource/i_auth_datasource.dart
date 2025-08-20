import '../dto/request/login_request_dto.dart';
import '../dto/request/register_request_dto.dart';
import '../dto/request/update_profile_request_dto.dart';
import '../dto/response/auth_response_dto.dart';
import '../dto/response/user_response_dto.dart';

abstract class IAuthDatasource {
  Stream<UserResponseDTO?> get authStateChanges;
  UserResponseDTO? get currentUser;
  Future<AuthResponseDTO> login(LoginRequestDTO request);
  Future<AuthResponseDTO> register(RegisterRequestDTO request);
  Future<void> logout();
  Future<UserResponseDTO> updateProfile(UpdateProfileRequestDTO request);
  Future<UserResponseDTO?> getCachedUser();
  Future<void> cacheUser(UserResponseDTO user);
  Future<void> clearCache();
}