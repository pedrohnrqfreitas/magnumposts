import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../core/usecase.dart';
import '../../../data/authentication/models/auth_result_model.dart';
import '../../../data/authentication/models/params/register_params.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class RegisterUseCase implements Usecase<AuthResultModel, RegisterParams> {
  final IAuthRepository _repository;

  RegisterUseCase({required IAuthRepository repository}) : _repository = repository;

  @override
  Future<ResultData<Failure, AuthResultModel>> call(RegisterParams params) async {
    final validationResult = _validateRegistrationParams(params);
    if (validationResult != null) {
      return ResultData.error(validationResult);
    }

    return await _repository.register(params);
  }

  /// Validações de negócio centralizadas
  Failure? _validateRegistrationParams(RegisterParams params) {
    if (_hasEmptyFields(params)) {
      return Failure(message: 'Todos os campos são obrigatórios');
    }

    if (!_isValidEmail(params.email)) {
      return Failure(message: 'Por favor, insira um email válido');
    }

    if (!_isValidPassword(params.password)) {
      return Failure(message: 'Senha deve ter pelo menos 6 caracteres');
    }

    if (!_passwordsMatch(params.password, params.confirmPassword)) {
      return Failure(message: 'Senhas não coincidem');
    }

    return null;
  }

  bool _hasEmptyFields(RegisterParams params) =>
      params.email.isEmpty ||
          params.password.isEmpty ||
          params.confirmPassword.isEmpty;

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  bool _isValidPassword(String password) => password.length >= 6;

  bool _passwordsMatch(String password, String confirmPassword) =>
      password == confirmPassword;
}