import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../data/authentication/models/auth_result_model.dart';
import '../../../data/authentication/models/params/register_params.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<ResultData<Failure, AuthResultModel>> execute(RegisterParams params) async {
    // Validações
    if (params.email.isEmpty || params.password.isEmpty || params.confirmPassword.isEmpty) {
      return ResultData.error(
        Failure(message: 'Todos os campos são obrigatórios'),
      );
    }

    

    if (params.password.length < 6) {
      return ResultData.error(
        Failure(message: 'Senha deve ter pelo menos 6 caracteres'),
      );
    }

    if (params.password != params.confirmPassword) {
      return ResultData.error(
        Failure(message: 'Senhas não coincidem'),
      );
    }

    return await repository.register(params);
  }

}