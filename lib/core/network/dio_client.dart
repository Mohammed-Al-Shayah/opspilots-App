import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../errors/app_failure.dart';
import 'api_constants.dart';
import 'api_token_store.dart';
import 'dio_failure_mapper.dart';

class DioClient {
  DioClient({
    ApiTokenStore? tokenStore,
    String languageCode = ApiConstants.defaultLanguageCode,
  }) : _tokenStore = tokenStore ?? ApiTokenStore() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.putIfAbsent('X-Language', () => languageCode);
          final workspaceId = await _tokenStore.readWorkspaceId();
          if (workspaceId != null && workspaceId.isNotEmpty) {
            options.headers.putIfAbsent('X-Workspace-Id', () => workspaceId);
          }
          final token = await _tokenStore.readActiveToken();
          if (token != null && token.isNotEmpty) {
            options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
          }
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }
  }

  final ApiTokenStore _tokenStore;
  late final Dio _dio;

  Dio get instance => _dio;

  AppFailure mapFailure(DioException exception) {
    return DioFailureMapper.map(exception);
  }
}
