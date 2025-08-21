import '../dto/profile_dto.dart';

class ProfileModel {
  final String userId;
  final String name;
  final String? imageUrl;
  final int postsCount;
  final int? age;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.userId,
    required this.name,
    this.imageUrl,
    required this.postsCount,
    this.age,
    required this.interests,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromDTO(ProfileDTO dto) {
    return ProfileModel(
      userId: dto.userId ?? '',
      name: dto.name ?? '',
      imageUrl: dto.imageUrl,
      postsCount: dto.postsCount ?? 0,
      age: dto.age,
      interests: dto.interests ?? [],
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt ?? DateTime.now(),
    );
  }

  ProfileDTO toDTO() {
    return ProfileDTO(
      userId: userId,
      name: name,
      imageUrl: imageUrl,
      postsCount: postsCount,
      age: age,
      interests: interests,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ProfileModel copyWith({
    String? userId,
    String? name,
    String? imageUrl,
    int? postsCount,
    int? age,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      postsCount: postsCount ?? this.postsCount,
      age: age ?? this.age,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get avatarUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    // Avatar sempre de uma pessoa real, fixo para cada id
    return 'https://randomuser.me/api/portraits/men/$userId.jpg';
  }

  String get formattedInterests {
    if (interests.isEmpty) return 'Nenhum interesse informado';
    return interests.join(', ');
  }

  String get memberSince {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ano${years > 1 ? 's' : ''}';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months mês${months > 1 ? 'es' : ''}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Hoje';
    }
  }
}