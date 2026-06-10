import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/task_transition.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../domain/entities/task_item.dart';
import '../models/task_model.dart';
import '../tasks_api_service.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl({required TasksApiService apiService})
    : _apiService = apiService;

  final TasksApiService _apiService;

  @override
  Future<AppResult<List<TaskItem>>> getMyTasks() async {
    try {
      final rawTasks = await _apiService.getMyTasks();
      final tasks = rawTasks
          .map(ApiResponseReader.asMap)
          .map(TaskModel.fromJson)
          .toList();
      return AppResult.success(tasks);
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<TaskItem>> getTaskDetails(String taskId) async {
    try {
      final data = await _apiService.getTaskDetails(taskId);
      final taskMap = ApiResponseReader.asMap(data['task'] ?? data);
      return AppResult.success(TaskModel.fromJson(taskMap));
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<TaskItem>> transitionTask(
    String taskId,
    TaskTransition transition, {
    TaskItem? fallbackTask,
    String? note,
    String? reason,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _apiService.transition(
        taskId,
        transition,
        note: note,
        reason: reason,
        latitude: latitude,
        longitude: longitude,
      );
      final taskMap = ApiResponseReader.asMap(response['task'] ?? response);
      if (taskMap.isNotEmpty && taskMap['title'] != null) {
        return AppResult.success(TaskModel.fromJson(taskMap));
      }
      final fallback = fallbackTask;
      if (fallback == null) {
        return AppResult.failure(
          const ParsingFailure(
            'Task transition response did not include task.',
          ),
        );
      }
      return AppResult.success(
        fallback.copyWith(status: _statusForTransition(transition)),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  TaskStatus _statusForTransition(TaskTransition transition) {
    switch (transition) {
      case TaskTransition.accept:
        return TaskStatus.accepted;
      case TaskTransition.onTheWay:
        return TaskStatus.onTheWay;
      case TaskTransition.arrived:
        return TaskStatus.arrived;
      case TaskTransition.checkIn:
      case TaskTransition.start:
        return TaskStatus.inProgress;
      case TaskTransition.submitForReview:
      case TaskTransition.approve:
        return TaskStatus.completed;
      case TaskTransition.reject:
      case TaskTransition.reviewReject:
        return TaskStatus.failed;
      case TaskTransition.reopen:
        return TaskStatus.reopened;
    }
  }
}
