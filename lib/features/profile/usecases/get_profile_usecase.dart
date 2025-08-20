import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/profile/models/profile_model.dart';
import '../../../data/profile/repository/i_profile_repository.dart';

class GetProfileUseCase implements Usecase<ProfileModel?, String> {
  final IProfileRepository repository;

  GetProfileUseCase({required this.repository});

  @override
  Future<ResultData<Failure, ProfileModel?>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}