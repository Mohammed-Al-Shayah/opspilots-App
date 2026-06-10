import '../../../../core/utils/app_result.dart';
import '../repositories/auth_repository.dart';

class SetPasswordParams {
  const SetPasswordParams({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;
}

class SetPasswordUseCase {
  const SetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<void>> call(SetPasswordParams params) {
    return _repository.setPassword(
      email: params.email,
      token: params.token,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}
