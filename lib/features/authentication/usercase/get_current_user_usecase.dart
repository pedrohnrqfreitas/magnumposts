import 'package:magnumposts/core/usecase.dart';

import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../data/authentication/models/user_model.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class GetCurrentUserUseCase implements Usecase<UserModel?, NoParams> {
  final IAuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  UserModel? execute() {
    return repository.currentUser;
  }

  @override
  Future<ResultData<Failure, UserModel?>> call(NoParams params) async {
    return await repository.getCachedUser();
  }
}