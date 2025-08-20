import '../dto/response/auth_response_dto.dart';
import 'user_model.dart';

class AuthResultModel {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final bool success;
  final String? message;

  AuthResultModel({
    this.user,
    this.accessToken,
    this.refreshToken,
    required this.success,
    this.message,
  });

  factory AuthResultModel.fromDTO(AuthResponseDTO? dto) {
    return AuthResultModel(
      user: dto?.user != null ? UserModel.fromDTO(dto!.user) : null,
      accessToken: dto?.accessToken,
      refreshToken: dto?.refreshToken,
      success: dto?.success ?? false,
      message: dto?.message,
    );
  }

  factory AuthResultModel.success(UserModel user) {
    return AuthResultModel(
      user: user,
      success: true,
    );
  }

  factory AuthResultModel.error(String message) {
    return AuthResultModel(
      success: false,
      message: message,
    );
  }
}