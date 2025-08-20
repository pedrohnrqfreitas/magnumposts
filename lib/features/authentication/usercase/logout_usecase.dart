import 'package:magnumposts/core/usecase.dart';

import '../../../core/errors/failure.dart';
import '../../../core/result_data.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class LogoutUseCase implements Usecase<void, NoParams>{
  final IAuthRepository repository;

  LogoutUseCase({required this.repository});

  @override
  Future<ResultData<Failure, void>> call(NoParams params) async{
    return await repository.logout();
  }
}