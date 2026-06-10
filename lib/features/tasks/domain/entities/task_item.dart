import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

enum TaskStatus {
  pending('Pending', AppColors.orange),
  accepted('Accepted', Color(0xFF2563EB)),
  onTheWay('On the Way', Color(0xFF7C3AED)),
  arrived('Arrived', Color(0xFF0891B2)),
  inProgress('In Progress', Color(0xFF06B6D4)),
  waitingClient('Waiting Client', Color(0xFFF59E0B)),
  needMaterials('Need Materials', Color(0xFF9333EA)),
  completed('Completed', Color(0xFF00B050)),
  failed('Failed', AppColors.danger),
  reopened('Reopened', Color(0xFF64748B)),
  delayed('Delayed', AppColors.danger);

  const TaskStatus(this.label, this.color);

  final String label;
  final Color color;
}

enum TaskPriority {
  urgent('Urgent', AppColors.danger, Icons.priority_high),
  high('High', AppColors.orange, Icons.arrow_upward),
  medium('Medium', Color(0xFFEAB308), Icons.remove),
  low('Low', Color(0xFF64748B), Icons.arrow_downward);

  const TaskPriority(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.client,
    required this.location,
    required this.time,
    required this.status,
    required this.priority,
  });

  final String id;
  final String title;
  final String description;
  final String client;
  final String location;
  final String time;
  final TaskStatus status;
  final TaskPriority priority;

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    String? client,
    String? location,
    String? time,
    TaskStatus? status,
    TaskPriority? priority,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      client: client ?? this.client,
      location: location ?? this.location,
      time: time ?? this.time,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }
}

const demoTasks = [
  TaskItem(
    id: 'T-001',
    title: 'صيانة نظام التكييف',
    description: 'فحص وصيانة نظام التكييف المركزي في مبنى الإدارة',
    client: 'شركة النجاح التجارية',
    location: 'شارع الملك فهد، الرياض',
    time: '2026-06-01 - 09:00',
    status: TaskStatus.pending,
    priority: TaskPriority.high,
  ),
  TaskItem(
    id: 'T-002',
    title: 'تركيب كاميرات مراقبة',
    description: 'تركيب 4 كاميرات مراقبة في المواقع المحددة',
    client: 'مركز التسوق الكبير',
    location: 'حي العليا، الرياض',
    time: '2026-06-01 - 11:00',
    status: TaskStatus.inProgress,
    priority: TaskPriority.medium,
  ),
  TaskItem(
    id: 'T-003',
    title: 'فحص أنظمة الإنذار',
    description: 'فحص دوري لأنظمة الإنذار والإطفاء',
    client: 'مستشفى الملك فيصل',
    location: 'شارع العروبة، الرياض',
    time: '2026-05-31 - 08:00',
    status: TaskStatus.completed,
    priority: TaskPriority.low,
  ),
];
