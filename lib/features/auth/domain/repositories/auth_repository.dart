import '../../../../core/utils/app_result.dart';
import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Future<AppResult<AuthSessionEntity>> login({
    required String emailOrPhone,
    required String password,
    String deviceName,
    String? fcmToken,
  });

  Future<AppResult<void>> logout();

  Future<AppResult<void>> setPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
}
