import '../../../../core/utils/app_result.dart';
import '../repositories/tasks_repository.dart';

enum TaskWorkflowAction { note, material, expense, rating }

class SubmitTaskWorkflowParams {
  const SubmitTaskWorkflowParams({
    required this.taskId,
    required this.action,
    required this.payload,
  });

  final String taskId;
  final TaskWorkflowAction action;
  final Map<String, dynamic> payload;
}

class SubmitTaskWorkflowUseCase {
  const SubmitTaskWorkflowUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<void>> call(SubmitTaskWorkflowParams params) {
    switch (params.action) {
      case TaskWorkflowAction.note:
        return _repository.addNote(params.taskId, params.payload);
      case TaskWorkflowAction.material:
        return _repository.addMaterial(params.taskId, params.payload);
      case TaskWorkflowAction.expense:
        return _repository.addExpense(params.taskId, params.payload);
      case TaskWorkflowAction.rating:
        return _repository.addRating(params.taskId, params.payload);
    }
  }
}
