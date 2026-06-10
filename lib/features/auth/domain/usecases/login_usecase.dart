import '../../../../core/utils/app_result.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({
    required this.emailOrPhone,
    required this.password,
    this.deviceName = 'mobile-app',
    this.fcmToken,
  });

  final String emailOrPhone;
  final String password;
  final String deviceName;
  final String? fcmToken;
}

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<AuthSessionEntity>> call(LoginParams params) {
    return _repository.login(
      emailOrPhone: params.emailOrPhone,
      password: params.password,
      deviceName: params.deviceName,
      fcmToken: params.fcmToken,
    );
  }
}
