import '../dto/response/post_response_dto.dart';
import '../dto/response/user_post_response_dto.dart';

abstract class IPostsDatasource {
  Future<List<PostResponseDTO>> getPosts({int page = 1, int limit = 10});
  Future<PostResponseDTO> getPostById(int id);
  Future<UserPostResponseDTO> getUserById(int id);
}