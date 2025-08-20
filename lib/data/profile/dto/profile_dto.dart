class ProfileDTO {
  final String? userId;
  final String? name;
  final String? imageUrl;
  final int? postsCount;
  final int? age;
  final List<String>? interests;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileDTO({
    this.userId,
    this.name,
    this.imageUrl,
    this.postsCount,
    this.age,
    this.interests,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileDTO.fromMap(Map<String, dynamic> map) {
    return ProfileDTO(
      userId: map['userId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      postsCount: map['postsCount'],
      age: map['age'],
      interests: map['interests'] != null ? List<String>.from(map['interests']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'postsCount': postsCount,
      'age': age,
      'interests': interests,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}