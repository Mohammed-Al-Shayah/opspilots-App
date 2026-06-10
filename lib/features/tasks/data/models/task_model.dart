import '../../../../core/network/api_response_reader.dart';
import '../../domain/entities/task_item.dart';

class TaskModel extends TaskItem {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.client,
    required super.location,
    required super.time,
    required super.status,
    required super.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final client = ApiResponseReader.asMap(json['client']);
    final clientLocation = ApiResponseReader.asMap(
      json['client_location'] ?? json['location'],
    );
    final scheduledAt = json['scheduled_at'] ?? json['scheduled_time'];

    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled task',
      description: json['description']?.toString() ?? '',
      client:
          client['name']?.toString() ??
          json['client_name']?.toString() ??
          json['customer_name']?.toString() ??
          '',
      location:
          json['address']?.toString() ??
          clientLocation['address']?.toString() ??
          clientLocation['name']?.toString() ??
          '',
      time: _formatScheduledTime(scheduledAt),
      status: _statusFromApi(json['status']),
      priority: _priorityFromApi(json['priority']),
    );
  }

  static TaskStatus _statusFromApi(Object? value) {
    final status = value.toString().toLowerCase().replaceAll('-', '_');
    switch (status) {
      case 'accepted':
        return TaskStatus.accepted;
      case 'on_the_way':
        return TaskStatus.onTheWay;
      case 'arrived':
        return TaskStatus.arrived;
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'waiting_client':
        return TaskStatus.waitingClient;
      case 'need_materials':
        return TaskStatus.needMaterials;
      case 'completed':
        return TaskStatus.completed;
      case 'failed':
        return TaskStatus.failed;
      case 'reopened':
        return TaskStatus.reopened;
      case 'delayed':
        return TaskStatus.delayed;
      case 'pending':
      default:
        return TaskStatus.pending;
    }
  }

  static TaskPriority _priorityFromApi(Object? value) {
    final priority = value.toString().toLowerCase();
    switch (priority) {
      case 'critical':
      case 'urgent':
        return TaskPriority.urgent;
      case 'high':
        return TaskPriority.high;
      case 'low':
        return TaskPriority.low;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }

  static String _formatScheduledTime(Object? value) {
    final raw = value?.toString();
    if (raw == null || raw.isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return raw;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '${parsed.year}-$month-$day - $hour:$minute';
  }
}
