import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/dio_client.dart';

class NotificationsApiService {
  const NotificationsApiService({required DioClient dioClient})
    : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<List<dynamic>> getNotifications() async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.notifications,
      );
      return ApiResponseReader.asList(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dioClient.instance.post<Object?>(ApiPaths.notificationsReadAll);
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<void> markRead(String notificationId) async {
    try {
      await _dioClient.instance.post<Object?>(
        ApiPaths.notificationRead(notificationId),
      );
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }
}
