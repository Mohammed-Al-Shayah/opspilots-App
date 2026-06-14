import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl({
    required NotificationsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<NotificationEntity>>> getNotifications() async {
    try {
      final rows = await _remoteDataSource.getNotifications();
      return AppResult.success(
        rows
            .map(ApiResponseReader.asMap)
            .map(NotificationModel.fromJson)
            .toList(),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<void>> markAllRead() async {
    try {
      await _remoteDataSource.markAllRead();
      return AppResult.success(null);
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<void>> markRead(String notificationId) async {
    try {
      await _remoteDataSource.markRead(notificationId);
      return AppResult.success(null);
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(UnknownFailure(error.toString()));
    }
  }
}
