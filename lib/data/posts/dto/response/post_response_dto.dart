class PostResponseDTO {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  PostResponseDTO({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory PostResponseDTO.fromMap(Map<String, dynamic> map) {
    return PostResponseDTO(
      userId: map['userId'],
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}