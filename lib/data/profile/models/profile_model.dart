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

  /// Gera uma URL de avatar mock baseada no nome
  String get avatarUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    // Gerar avatar mock usando serviço como UI Avatars
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=667eea&color=ffffff&size=200&rounded=true';
  }

  /// Obtém as iniciais do nome
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '?';
  }

  /// Formata os interesses como texto
  String get formattedInterests {
    if (interests.isEmpty) return 'Nenhum interesse informado';
    return interests.join(', ');
  }

  /// Calcula tempo desde criação
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