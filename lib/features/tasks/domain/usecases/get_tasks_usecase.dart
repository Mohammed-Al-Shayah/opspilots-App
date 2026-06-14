import '../../../../core/utils/app_result.dart';
import '../entities/task_item.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  const GetTasksUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<List<TaskItem>>> call() {
    return _repository.getTasks();
  }
}
