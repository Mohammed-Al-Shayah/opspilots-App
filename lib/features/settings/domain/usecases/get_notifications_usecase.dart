import '../../../../core/utils/app_result.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<AppResult<List<NotificationEntity>>> call() {
    return _repository.getNotifications();
  }
}
