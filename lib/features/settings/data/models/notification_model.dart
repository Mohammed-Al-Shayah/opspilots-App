import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    super.createdAt,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title:
          json['title']?.toString() ??
          json['type']?.toString() ??
          'Notification',
      message:
          json['message']?.toString() ??
          json['body']?.toString() ??
          json['data']?.toString() ??
          '',
      createdAt: json['created_at']?.toString(),
      isRead: json['read_at'] != null || json['is_read'] == true,
    );
  }
}
