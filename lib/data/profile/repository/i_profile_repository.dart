import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../models/profile_model.dart';
import '../models/params/create_profile_params.dart';
import '../models/params/update_profile_params.dart';

abstract class IProfileRepository {
  Future<ResultData<Failure, ProfileModel?>> getProfile(String userId);
  Future<ResultData<Failure, void>> createProfile(CreateProfileParams params);
  Future<ResultData<Failure, void>> updateProfile(UpdateProfileParams params);
}