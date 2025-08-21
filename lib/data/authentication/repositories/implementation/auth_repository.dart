import '../../../../core/errors/failure.dart';
import '../../../../core/result_data.dart';
import '../../datasource/implementation/auth_local_datasource.dart';
import '../../datasource/implementation/auth_remote_datasource.dart';
import '../../dto/request/login_request_dto.dart';
import '../../dto/request/register_request_dto.dart';
import '../../dto/request/update_profile_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/params/login_params.dart';
import '../../models/params/register_params.dart';
import '../../models/params/update_profile_params.dart';
import '../../models/user_model.dart';
import '../i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
  }) : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Stream<UserModel?> get authStateChanges {
    return _remoteDatasource.authStateChanges.map((userDTO) {
      if (userDTO != null) {
        _cacheUser(userDTO);
        return UserModel.fromDTO(userDTO);
      } else {
        _clearCache();
        return null;
      }
    });
  }

  @override
  UserModel? get currentUser {
    final userDTO = _remoteDatasource.currentUser;
    return userDTO != null ? UserModel.fromDTO(userDTO) : null;
  }

  @override
  Future<ResultData<Failure, AuthResultModel>> login(LoginParams params) async {
    try {
      final request = _createLoginRequest(params);
      final authResponse = await _remoteDatasource.login(request);
      final result = AuthResultModel.fromDTO(authResponse);

      if (_isSuccessfulAuth(result)) {
        await _cacheUser(result.user!.toDTO());
        return ResultData.success(result);
      }

      return ResultData.error(Failure(message: result.message ?? 'Erro no login'));
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(Failure(message: 'Erro inesperado no login: $e'));
    }
  }

  @override
  Future<ResultData<Failure, AuthResultModel>> register(RegisterParams params) async {
    try {
      final request = _createRegisterRequest(params);
      final authResponse = await _remoteDatasource.register(request);
      final result = AuthResultModel.fromDTO(authResponse);

      if (_isSuccessfulAuth(result)) {
        await _cacheUser(result.user!.toDTO());
        return ResultData.success(result);
      }

      return ResultData.error(Failure(message: result.message ?? 'Erro no cadastro'));
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(Failure(message: 'Erro inesperado no cadastro: $e'));
    }
  }

  @override
  Future<ResultData<Failure, void>> logout() async {
    try {
      await _remoteDatasource.logout();
      await _localDatasource.logout();
      return ResultData.success(null);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(Failure(message: 'Erro no logout: $e'));
    }
  }

  @override
  Future<ResultData<Failure, UserModel>> updateProfile(UpdateProfileParams params) async {
    try {
      final request = _createUpdateProfileRequest(params);
      final userResponse = await _remoteDatasource.updateProfile(request);
      final user = UserModel.fromDTO(userResponse);

      await _cacheUser(userResponse);
      return ResultData.success(user);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(Failure(message: 'Erro ao atualizar perfil: $e'));
    }
  }

  @override
  Future<ResultData<Failure, UserModel?>> getCachedUser() async {
    try {
      final userDTO = await _localDatasource.getCachedUser();
      final user = userDTO != null ? UserModel.fromDTO(userDTO) : null;
      return ResultData.success(user);
    } on Failure catch (e) {
      return ResultData.error(e);
    } catch (e) {
      return ResultData.error(Failure(message: 'Erro ao buscar usuário do cache: $e'));
    }
  }

  LoginRequestDTO _createLoginRequest(LoginParams params) =>
      LoginRequestDTO(email: params.email, password: params.password);

  RegisterRequestDTO _createRegisterRequest(RegisterParams params) =>
      RegisterRequestDTO(
        email: params.email,
        password: params.password,
        displayName: params.displayName,
      );

  UpdateProfileRequestDTO _createUpdateProfileRequest(UpdateProfileParams params) =>
      UpdateProfileRequestDTO(
        displayName: params.displayName,
        photoURL: params.photoURL,
      );

  bool _isSuccessfulAuth(AuthResultModel result) =>
      result.success && result.user != null;

  Future<void> _cacheUser(dynamic userDTO) =>
      _localDatasource.cacheUser(userDTO);

  Future<void> _clearCache() =>
      _localDatasource.clearCache();
}