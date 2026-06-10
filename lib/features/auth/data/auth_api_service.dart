import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/api_token_store.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entities/auth_user_entity.dart';
import 'models/auth_user_model.dart';

class AuthLoginResult {
  const AuthLoginResult({required this.user, required this.token});

  final AuthUserEntity user;
  final String token;
}

class AuthApiService {
  const AuthApiService({
    required DioClient dioClient,
    required ApiTokenStore tokenStore,
  }) : _dioClient = dioClient,
       _tokenStore = tokenStore;

  final DioClient _dioClient;
  final ApiTokenStore _tokenStore;

  Future<AuthLoginResult> login({
    required String emailOrPhone,
    required String password,
    String deviceName = 'mobile-app',
    String? fcmToken,
  }) async {
    try {
      final response = await _dioClient.instance.post<Object?>(
        ApiPaths.login,
        data: {
          'email_or_phone': emailOrPhone,
          'password': password,
          'device_name': deviceName,
          if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
        },
      );
      final result = _parseLogin(response.data, emailOrPhone);
      await _tokenStore.saveAuthToken(result.token);
      await _tokenStore.clearWorkspace();
      return result;
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> me() async {
    try {
      final response = await _dioClient.instance.get<Object?>(ApiPaths.me);
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<void> logout() async {
    try {
      await _dioClient.instance.post<Object?>(ApiPaths.logout);
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    } finally {
      await _tokenStore.clearAll();
    }
  }

  Future<void> setPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dioClient.instance.post<Object?>(
        ApiPaths.setPassword,
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  AuthLoginResult _parseLogin(Object? body, String fallbackEmail) {
    final root = ApiResponseReader.asMap(body);
    final data = ApiResponseReader.asMap(root['data']);
    final token =
        ApiResponseReader.stringAt(root, const [
          'token',
          'access_token',
          'plain_text_token',
        ]) ??
        ApiResponseReader.stringAt(data, const [
          'token',
          'access_token',
          'plain_text_token',
        ]);

    if (token == null) {
      throw const FormatException('Login response did not include a token.');
    }

    final userMap = ApiResponseReader.asMap(
      data['user'] ?? root['user'] ?? data,
    );
    final id = userMap['id']?.toString() ?? '';
    final email = userMap['email']?.toString() ?? fallbackEmail;
    final name = userMap['name']?.toString() ?? email;

    return AuthLoginResult(
      token: token,
      user: AuthUserModel.fromJson({
        ...userMap,
        'id': id,
        'name': name,
        'email': email,
      }, fallbackEmail: fallbackEmail),
    );
  }
}
