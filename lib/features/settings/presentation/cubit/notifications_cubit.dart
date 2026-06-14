import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notifications_read_usecase.dart';

enum NotificationsStatus { initial, loading, loaded, empty, failure, updating }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.errorMessage,
  });

  final NotificationsStatus status;
  final List<NotificationEntity> notifications;
  final String? errorMessage;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAllNotificationsReadUseCase markAllReadUseCase,
    required MarkNotificationReadUseCase markReadUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _markAllReadUseCase = markAllReadUseCase,
       _markReadUseCase = markReadUseCase,
       super(const NotificationsState());

  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAllNotificationsReadUseCase _markAllReadUseCase;
  final MarkNotificationReadUseCase _markReadUseCase;

  Future<void> loadNotifications() async {
    emit(
      state.copyWith(status: NotificationsStatus.loading, errorMessage: null),
    );

    final result = await _getNotificationsUseCase();
    result.when(
      success: (notifications) => emit(
        state.copyWith(
          status: notifications.isEmpty
              ? NotificationsStatus.empty
              : NotificationsStatus.loaded,
          notifications: notifications,
          errorMessage: null,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          notifications: const [],
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> markAllRead() async {
    if (state.notifications.isEmpty) {
      return;
    }

    final previousStatus = state.status;
    emit(state.copyWith(status: NotificationsStatus.updating));
    final result = await _markAllReadUseCase();
    result.when(
      success: (_) {
        emit(
          state.copyWith(
            status: NotificationsStatus.loaded,
            notifications: state.notifications.map(_readCopy).toList(),
            errorMessage: null,
          ),
        );
      },
      failure: (failure) => emit(
        state.copyWith(
          status: _restoreStatus(previousStatus),
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> markRead(String notificationId) async {
    if (notificationId.isEmpty) {
      return;
    }

    NotificationEntity? notification;
    for (final item in state.notifications) {
      if (item.id == notificationId) {
        notification = item;
        break;
      }
    }
    if (notification == null || notification.isRead) {
      return;
    }

    final previousStatus = state.status;
    emit(state.copyWith(status: NotificationsStatus.updating));
    final result = await _markReadUseCase(notificationId);
    result.when(
      success: (_) {
        emit(
          state.copyWith(
            status: NotificationsStatus.loaded,
            notifications: state.notifications.map((item) {
              return item.id == notificationId ? _readCopy(item) : item;
            }).toList(),
            errorMessage: null,
          ),
        );
      },
      failure: (failure) => emit(
        state.copyWith(
          status: _restoreStatus(previousStatus),
          errorMessage: failure.message,
        ),
      ),
    );
  }

  NotificationEntity _readCopy(NotificationEntity notification) {
    return NotificationEntity(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      createdAt: notification.createdAt,
      isRead: true,
    );
  }

  NotificationsStatus _restoreStatus(NotificationsStatus previousStatus) {
    if (previousStatus == NotificationsStatus.loading ||
        previousStatus == NotificationsStatus.initial ||
        previousStatus == NotificationsStatus.updating) {
      return state.notifications.isEmpty
          ? NotificationsStatus.empty
          : NotificationsStatus.loaded;
    }
    return previousStatus;
  }
}
