class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final String? createdAt;
  final bool isRead;
}
