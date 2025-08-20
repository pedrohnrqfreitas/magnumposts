import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/posts/models/post_model.dart';
import '../../../data/posts/repository/i_posts_repository.dart';

class GetPostsParams {
  final int page;
  final int limit;

  GetPostsParams({
    this.page = 1,
    this.limit = 10,
  });
}

class GetPostsUseCase implements Usecase<List<PostModel>, GetPostsParams> {
  final IPostsRepository repository;

  GetPostsUseCase({required this.repository});

  @override
  Future<ResultData<Failure, List<PostModel>>> call(GetPostsParams params) async {
    return await repository.getPosts(page: params.page, limit: params.limit);
  }
}