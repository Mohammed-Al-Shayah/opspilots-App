import '../../../../core/utils/app_result.dart';
import '../entities/task_item.dart';
import '../entities/task_transition.dart';
import '../repositories/tasks_repository.dart';

class TransitionTaskParams {
  const TransitionTaskParams({
    required this.taskId,
    required this.transition,
    this.fallbackTask,
    this.note,
    this.reason,
    this.latitude,
    this.longitude,
  });

  final String taskId;
  final TaskTransition transition;
  final TaskItem? fallbackTask;
  final String? note;
  final String? reason;
  final double? latitude;
  final double? longitude;
}

class TransitionTaskUseCase {
  const TransitionTaskUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<TaskItem>> call(TransitionTaskParams params) {
    return _repository.transitionTask(
      params.taskId,
      params.transition,
      fallbackTask: params.fallbackTask,
      note: params.note,
      reason: params.reason,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
