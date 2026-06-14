import '../../domain/entities/task_transition.dart';
import '../tasks_api_service.dart';

abstract class TasksRemoteDataSource {
  Future<List<dynamic>> getMyTasks();

  Future<Map<String, dynamic>> getMyTask(String taskId);

  Future<List<dynamic>> getTasks();

  Future<Map<String, dynamic>> getTask(String taskId);

  Future<Map<String, dynamic>> getTaskDetails(String taskId);

  Future<Map<String, dynamic>> transition(
    String taskId,
    TaskTransition transition, {
    String? note,
    String? reason,
    double? latitude,
    double? longitude,
  });

  Future<Map<String, dynamic>> addNote(
    String taskId,
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> addMaterial(
    String taskId,
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> addExpense(
    String taskId,
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> addRating(
    String taskId,
    Map<String, dynamic> payload,
  );
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  const TasksRemoteDataSourceImpl({required TasksApiService apiService})
    : _apiService = apiService;

  final TasksApiService _apiService;

  @override
  Future<List<dynamic>> getMyTasks() => _apiService.getMyTasks();

  @override
  Future<Map<String, dynamic>> getMyTask(String taskId) {
    return _apiService.getMyTask(taskId);
  }

  @override
  Future<List<dynamic>> getTasks() => _apiService.getTasks();

  @override
  Future<Map<String, dynamic>> getTask(String taskId) {
    return _apiService.getTask(taskId);
  }

  @override
  Future<Map<String, dynamic>> getTaskDetails(String taskId) {
    return _apiService.getTaskDetails(taskId);
  }

  @override
  Future<Map<String, dynamic>> transition(
    String taskId,
    TaskTransition transition, {
    String? note,
    String? reason,
    double? latitude,
    double? longitude,
  }) {
    return _apiService.transition(
      taskId,
      transition,
      note: note,
      reason: reason,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<Map<String, dynamic>> addNote(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _apiService.addNote(taskId, payload);
  }

  @override
  Future<Map<String, dynamic>> addMaterial(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _apiService.addMaterial(taskId, payload);
  }

  @override
  Future<Map<String, dynamic>> addExpense(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _apiService.addExpense(taskId, payload);
  }

  @override
  Future<Map<String, dynamic>> addRating(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _apiService.addRating(taskId, payload);
  }
}
