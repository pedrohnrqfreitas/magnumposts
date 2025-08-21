import '../../../../core/errors/failure.dart';
import '../../../../core/result_data.dart';
import '../../datasource/i_posts_datasource.dart';
import '../../models/post_model.dart';
import '../../models/user_post_model.dart';
import '../i_posts_repository.dart';

class PostsRepository implements IPostsRepository {
  final IPostsDatasource remoteDatasource;

  PostsRepository({required this.remoteDatasource});

  @override
  Future<ResultData<Failure, List<PostModel>>> getPosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final postsDTO = await remoteDatasource.getPosts(page: page, limit: limit);
      final posts = postsDTO.map((dto) => PostModel.fromDTO(dto)).toList();
      return ResultData.success(posts);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: '$e'),
      );
    }
  }

  @override
  Future<ResultData<Failure, PostModel>> getPostById(int id) async {
    try {
      final postDTO = await remoteDatasource.getPostById(id);
      final post = PostModel.fromDTO(postDTO);
      return ResultData.success(post);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: 'Erro inesperado ao buscar post: $e'),
      );
    }
  }

  @override
  Future<ResultData<Failure, UserPostModel>> getUserById(int id) async {
    try {
      final userDTO = await remoteDatasource.getUserById(id);
      final user = UserPostModel.fromDTO(userDTO);
      return ResultData.success(user);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: 'Erro inesperado ao buscar usuário: $e'),
      );
    }
  }
}