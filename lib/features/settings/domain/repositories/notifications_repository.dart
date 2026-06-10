import '../../../../core/utils/app_result.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<AppResult<List<NotificationEntity>>> getNotifications();

  Future<AppResult<void>> markAllRead();

  Future<AppResult<void>> markRead(String notificationId);
}
