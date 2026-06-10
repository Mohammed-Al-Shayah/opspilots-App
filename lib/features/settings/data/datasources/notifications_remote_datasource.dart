import '../notifications_api_service.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<dynamic>> getNotifications();

  Future<void> markAllRead();

  Future<void> markRead(String notificationId);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl({
    required NotificationsApiService apiService,
  }) : _apiService = apiService;

  final NotificationsApiService _apiService;

  @override
  Future<List<dynamic>> getNotifications() => _apiService.getNotifications();

  @override
  Future<void> markAllRead() => _apiService.markAllRead();

  @override
  Future<void> markRead(String notificationId) {
    return _apiService.markRead(notificationId);
  }
}
