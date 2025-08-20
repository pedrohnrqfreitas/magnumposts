class CreateProfileParams {
  final String userId;
  final String name;
  final String? imageUrl;
  final int? age;
  final List<String> interests;

  CreateProfileParams({
    required this.userId,
    required this.name,
    this.imageUrl,
    this.age,
    this.interests = const [],
  });
}
