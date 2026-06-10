import '../../../tasks/domain/entities/task_item.dart';

class FieldHomeSummaryEntity {
  const FieldHomeSummaryEntity({
    required this.employeeName,
    required this.roleLabel,
    required this.todayCount,
    required this.pendingCount,
    required this.activeCount,
    required this.completedCount,
    required this.completionRate,
    required this.todayTasks,
  });

  final String employeeName;
  final String roleLabel;
  final int todayCount;
  final int pendingCount;
  final int activeCount;
  final int completedCount;
  final double completionRate;
  final List<TaskItem> todayTasks;
}
