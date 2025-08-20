import '../dto/response/post_response_dto.dart';

class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostModel.fromDTO(PostResponseDTO dto) {
    return PostModel(
      id: dto.id ?? 0,
      userId: dto.userId ?? 0,
      title: dto.title ?? '',
      body: dto.body ?? '',
    );
  }

  PostResponseDTO toDTO() {
    return PostResponseDTO(
      id: id,
      userId: userId,
      title: title,
      body: body,
    );
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  /// Trunca o corpo do post para exibição na lista
  String get truncatedBody {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }

  /// Verifica se o corpo foi truncado
  bool get isBodyTruncated => body.length > 100;
}