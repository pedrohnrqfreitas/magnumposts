import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/http/http_service.dart';
import '../../dto/response/post_response_dto.dart';
import '../../dto/response/user_post_response_dto.dart';
import '../i_posts_datasource.dart';

class PostsRemoteDatasource implements IPostsDatasource {
  final HttpService httpService;

  PostsRemoteDatasource({required this.httpService});

  @override
  Future<List<PostResponseDTO>> getPosts({int page = 1, int limit = 10}) async {
    try {
      final response = await httpService.get(
        ApiConstants.postsEndpoint,
        queryParameters: {
          '_page': page,
          '_limit': limit,
        },
      );

      final List<dynamic> postsJson = response.data;
      return postsJson.map((json) => PostResponseDTO.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar posts: $e');
    }
  }

  @override
  Future<PostResponseDTO> getPostById(int id) async {
    try {
      final response = await httpService.get('${ApiConstants.postsEndpoint}/$id');
      return PostResponseDTO.fromMap(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar post: $e');
    }
  }

  @override
  Future<UserPostResponseDTO> getUserById(int id) async {
    try {
      final response = await httpService.get('${ApiConstants.usersEndpoint}/$id');
      return UserPostResponseDTO.fromMap(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }
}