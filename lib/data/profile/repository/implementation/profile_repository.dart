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
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: 'Erro inesperado ao buscar perfil: $e'),
      );
    }
  }

  @override
  Future<ResultData<Failure, void>> createProfile(CreateProfileParams params) async {
    try {
      await datasource.createProfile(params);
      return ResultData.success(null);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: 'Erro inesperado ao criar perfil: $e'),
      );
    }
  }

  @override
  Future<ResultData<Failure, void>> updateProfile(UpdateProfileParams params) async {
    try {
      await datasource.updateProfile(params);
      return ResultData.success(null);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: 'Erro inesperado ao atualizar perfil: $e'),
      );
    }
  }

  @override
  Future<ResultData<Failure, void>> deleteProfile(String userId) async {
    try {
      await datasource.deleteProfile(userId);
      return ResultData.success(null);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(
        Failure(message: 'Erro inesperado ao deletar perfil: $e'),
      );
    }
  }

  @override
  Stream<ProfileModel?> watchProfile(String userId) {
    return datasource.watchProfile(userId).map((dto) {
      if (dto == null) return null;
      return ProfileModel.fromDTO(dto);
    });
  }
}
