import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/authentication/models/auth_result_model.dart';
import '../../../data/authentication/models/params/login_params.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class LoginUseCase implements Usecase<AuthResultModel, LoginParams> {
  final IAuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<ResultData<Failure, AuthResultModel>> call(LoginParams params) async {
    return await repository.login(params);
  }
}