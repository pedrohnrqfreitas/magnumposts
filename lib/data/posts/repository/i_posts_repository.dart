import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../models/post_model.dart';
import '../models/user_post_model.dart';

abstract class IPostsRepository {
  Future<ResultData<Failure, List<PostModel>>> getPosts({int page = 1, int limit = 10});
  Future<ResultData<Failure, PostModel>> getPostById(int id);
  Future<ResultData<Failure, UserPostModel>> getUserById(int id);
}