import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/profile/models/params/create_profile_params.dart';
import '../../../data/profile/repository/i_profile_repository.dart';

class CreateProfileUseCase implements Usecase<void, CreateProfileParams> {
  final IProfileRepository repository;

  CreateProfileUseCase({required this.repository});

  @override
  Future<ResultData<Failure, void>> call(CreateProfileParams params) async {
    return await repository.createProfile(params);
  }
}