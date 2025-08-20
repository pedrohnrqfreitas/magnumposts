import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/profile/models/params/update_profile_params.dart';
import '../../../data/profile/repository/i_profile_repository.dart';

class UpdateProfileUseCase implements Usecase<void, UpdateProfileParams> {
  final IProfileRepository repository;

  UpdateProfileUseCase({required this.repository});

  @override
  Future<ResultData<Failure, void>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params);
  }
}