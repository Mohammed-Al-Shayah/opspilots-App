import '../../../tasks/domain/entities/task_item.dart';

class SupervisorSummaryEntity {
  const SupervisorSummaryEntity({
    required this.supervisorName,
    required this.activeTeamCount,
    required this.pendingReviewsCount,
    required this.completedTodayCount,
    required this.delayedCount,
    required this.teamTasks,
  });

  final String supervisorName;
  final int activeTeamCount;
  final int pendingReviewsCount;
  final int completedTodayCount;
  final int delayedCount;
  final List<TaskItem> teamTasks;
}
