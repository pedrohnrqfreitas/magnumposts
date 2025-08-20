import '../../../data/authentication/models/user_model.dart';
import '../../../data/authentication/repositories/i_auth_repository.dart';

class CheckAuthStatusUseCase {
  final IAuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  Stream<UserModel?> execute() {
    return repository.authStateChanges;
  }

  bool isUserLoggedIn() {
    return repository.currentUser != null;
  }
}