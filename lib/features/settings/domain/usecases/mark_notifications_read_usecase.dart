import '../../../../core/utils/app_result.dart';
import '../repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<AppResult<void>> call() {
    return _repository.markAllRead();
  }
}

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<AppResult<void>> call(String notificationId) {
    return _repository.markRead(notificationId);
  }
}
