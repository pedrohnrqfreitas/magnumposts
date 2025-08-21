import '../../../../core/errors/failure.dart';
import '../../../../core/result_data.dart';
import '../../datasource/i_profile_datasource.dart';
import '../../models/profile_model.dart';
import '../../models/params/create_profile_params.dart';
import '../../models/params/update_profile_params.dart';
import '../i_profile_repository.dart';

class ProfileRepository implements IProfileRepository {
  final IProfileDatasource datasource;

  ProfileRepository({required this.datasource});

  @override
  Future<ResultData<Failure, ProfileModel?>> getProfile(String userId) async {
    try {
      final profileDTO = await datasource.getProfile(userId);

      if (profileDTO == null) {
        return ResultData.success(null);
      }

      final profile = ProfileModel.fromDTO(profileDTO);
      return ResultData.success(profile);

    } catch (e) {
      if (e is Exception) {
        return ResultData.error(
          Failure(message: e.toString().replaceAll('Exception: ', '')),
        );
      } else {
        return ResultData.error(
          Failure(message: 'Erro inesperado ao buscar perfil'),
        );
      }
    }
  }

  @override
  Future<ResultData<Failure, void>> createProfile(CreateProfileParams params) async {
    try {
      await datasource.createProfile(params);
      return ResultData.success(null);
    } catch (e) {
      if (e is Exception) {
        return ResultData.error(
          Failure(message: e.toString().replaceAll('Exception: ', '')),
        );
      } else {
        return ResultData.error(
          Failure(message: 'Erro inesperado ao criar perfil'),
        );
      }
    }
  }

  @override
  Future<ResultData<Failure, void>> updateProfile(UpdateProfileParams params) async {
    try {
      await datasource.updateProfile(params);
      return ResultData.success(null);
    } catch (e) {
      if (e is Exception) {
        return ResultData.error(
          Failure(message: e.toString().replaceAll('Exception: ', '')),
        );
      } else {
        return ResultData.error(
          Failure(message: 'Erro inesperado ao atualizar perfil'),
        );
      }
    }
  }

}