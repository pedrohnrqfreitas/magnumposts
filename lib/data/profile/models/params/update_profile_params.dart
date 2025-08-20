class UpdateProfileParams {
  final String userId;
  final String? name;
  final String? imageUrl;
  final int? postsCount;
  final int? age;
  final List<String>? interests;

  UpdateProfileParams({
    required this.userId,
    this.name,
    this.imageUrl,
    this.postsCount,
    this.age,
    this.interests,
  });
}