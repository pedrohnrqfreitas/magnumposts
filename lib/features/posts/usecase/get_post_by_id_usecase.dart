import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/posts/models/post_model.dart';
import '../../../data/posts/repository/i_posts_repository.dart';

class GetPostByIdUseCase implements Usecase<PostModel, int> {
  final IPostsRepository repository;

  GetPostByIdUseCase({required this.repository});

  @override
  Future<ResultData<Failure, PostModel>> call(int postId) async {
    return await repository.getPostById(postId);
  }
}