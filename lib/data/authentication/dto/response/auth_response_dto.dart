import 'user_response_dto.dart';

class AuthResponseDTO {
  final UserResponseDTO? user;
  final String? accessToken;
  final String? refreshToken;
  final bool success;
  final String? message;

  AuthResponseDTO({
    this.user,
    this.accessToken,
    this.refreshToken,
    required this.success,
    this.message,
  });

  factory AuthResponseDTO.fromMap(Map<String, dynamic> map) {
    return AuthResponseDTO(
      user: map['user'] != null ? UserResponseDTO.fromMap(map['user']) : null,
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      success: map['success'] ?? false,
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'success': success,
      'message': message,
    };
  }
}