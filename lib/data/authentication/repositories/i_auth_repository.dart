import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../models/params/login_params.dart';
import '../models/params/register_params.dart';
import '../models/params/update_profile_params.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

abstract class IAuthRepository {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<ResultData<Failure, AuthResultModel>> login(LoginParams params);
  Future<ResultData<Failure, AuthResultModel>> register(RegisterParams params);
  Future<ResultData<Failure, void>> logout();
  Future<ResultData<Failure, UserModel>> updateProfile(UpdateProfileParams params);
  Future<ResultData<Failure, UserModel?>> getCachedUser();
}