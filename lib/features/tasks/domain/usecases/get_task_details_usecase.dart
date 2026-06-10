import '../../../../core/utils/app_result.dart';
import '../entities/task_item.dart';
import '../repositories/tasks_repository.dart';

class GetTaskDetailsUseCase {
  const GetTaskDetailsUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<TaskItem>> call(String taskId) {
    return _repository.getTaskDetails(taskId);
  }
}
