import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/authentication/models/auth_result_model.dart';
import '../../../data/authentication/models/params/register_params.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class RegisterUseCase implements Usecase<AuthResultModel, RegisterParams> {
  final IAuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<ResultData<Failure, AuthResultModel>> call(RegisterParams params) async {
    // Validações básicas
    if (params.email.isEmpty || params.password.isEmpty || params.confirmPassword.isEmpty) {
      return ResultData.error(
        Failure(message: 'Todos os campos são obrigatórios'),
      );
    }

    // Validação de email básica
    if (!_isValidEmail(params.email)) {
      return ResultData.error(
        Failure(message: 'Por favor, insira um email válido'),
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}