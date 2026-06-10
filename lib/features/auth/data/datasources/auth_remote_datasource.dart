import '../auth_api_service.dart';

abstract class AuthRemoteDataSource {
  Future<AuthLoginResult> login({
    required String emailOrPhone,
    required String password,
    String deviceName,
    String? fcmToken,
  });

  Future<Map<String, dynamic>> me();

  Future<void> logout();

  Future<void> setPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required AuthApiService apiService})
    : _apiService = apiService;

  final AuthApiService _apiService;

  @override
  Future<AuthLoginResult> login({
    required String emailOrPhone,
    required String password,
    String deviceName = 'mobile-app',
    String? fcmToken,
  }) {
    return _apiService.login(
      emailOrPhone: emailOrPhone,
      password: password,
      deviceName: deviceName,
      fcmToken: fcmToken,
    );
  }

  @override
  Future<Map<String, dynamic>> me() => _apiService.me();

  @override
  Future<void> logout() => _apiService.logout();

  @override
  Future<void> setPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) {
    return _apiService.setPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
