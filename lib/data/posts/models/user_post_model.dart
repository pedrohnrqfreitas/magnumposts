import '../dto/response/user_post_response_dto.dart';

class UserPostModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;

  UserPostModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
  });

  factory UserPostModel.fromDTO(UserPostResponseDTO dto) {
    return UserPostModel(
      id: dto.id ?? 0,
      name: dto.name ?? '',
      username: dto.username ?? '',
      email: dto.email ?? '',
      phone: dto.phone,
      website: dto.website,
    );
  }

  UserPostResponseDTO toDTO() {
    return UserPostResponseDTO(
      id: id,
      name: name,
      username: username,
      email: email,
      phone: phone,
      website: website,
    );
  }
}