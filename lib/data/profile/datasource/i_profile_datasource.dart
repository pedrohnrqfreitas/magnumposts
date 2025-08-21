import '../dto/profile_dto.dart';
import '../models/params/create_profile_params.dart';
import '../models/params/update_profile_params.dart';

abstract class IProfileDatasource {
  Future<ProfileDTO?> getProfile(String userId);
  Future<void> createProfile(CreateProfileParams params);
  Future<void> updateProfile(UpdateProfileParams params);
}