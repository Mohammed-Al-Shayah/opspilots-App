import '../../../../core/utils/app_result.dart';
import '../entities/task_item.dart';
import '../entities/task_transition.dart';

abstract class TasksRepository {
  Future<AppResult<List<TaskItem>>> getMyTasks();

  Future<AppResult<TaskItem>> getTaskDetails(String taskId);

  Future<AppResult<TaskItem>> transitionTask(
    String taskId,
    TaskTransition transition, {
    TaskItem? fallbackTask,
    String? note,
    String? reason,
    double? latitude,
    double? longitude,
  });
}
