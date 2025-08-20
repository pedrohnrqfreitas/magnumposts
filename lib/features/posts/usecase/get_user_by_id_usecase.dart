import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/posts/models/user_post_model.dart';
import '../../../data/posts/repository/i_posts_repository.dart';

class GetUserByIdUseCase implements Usecase<UserPostModel, int> {
  final IPostsRepository repository;

  GetUserByIdUseCase({required this.repository});

  @override
  Future<ResultData<Failure, UserPostModel>> call(int userId) async {
    return await repository.getUserById(userId);
  }
}