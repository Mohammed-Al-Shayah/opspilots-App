import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthApiService apiService})
    : _apiService = apiService;

  final AuthApiService _apiService;

  @override
  Future<AppResult<AuthSessionEntity>> login({
    required String emailOrPhone,
    required String password,
    String deviceName = 'mobile-app',
    String? fcmToken,
  }) async {
    try {
      final result = await _apiService.login(
        emailOrPhone: emailOrPhone,
        password: password,
        deviceName: deviceName,
        fcmToken: fcmToken,
      );
      return AppResult.success(
        AuthSessionEntity(user: result.user, token: result.token),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on FormatException catch (error) {
      return AppResult.failure(ParsingFailure(error.message));
    } on Object catch (error) {
      return AppResult.failure(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<void>> logout() async {
    try {
      await _apiService.logout();
      return AppResult.success(null);
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<void>> setPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _apiService.setPassword(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return AppResult.success(null);
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(UnknownFailure(error.toString()));
    }
  }
}
