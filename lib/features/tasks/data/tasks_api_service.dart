import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entities/task_transition.dart';

class TasksApiService {
  const TasksApiService({required DioClient dioClient})
    : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<List<dynamic>> getMyTasks() => _getList(ApiPaths.tasksMy);

  Future<Map<String, dynamic>> getMyTask(String taskId) {
    return _getMap(ApiPaths.taskMy(taskId));
  }

  Future<List<dynamic>> getTasks() => _getList(ApiPaths.tasks);

  Future<Map<String, dynamic>> getTask(String taskId) {
    return _getMap(ApiPaths.task(taskId));
  }

  Future<Map<String, dynamic>> getTaskDetails(String taskId) {
    return _getMap(ApiPaths.taskDetails(taskId));
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> payload) {
    return _postMap(ApiPaths.tasks, payload);
  }

  Future<Map<String, dynamic>> updateTask(
    String taskId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dioClient.instance.patch<Object?>(
        ApiPaths.task(taskId),
        data: payload,
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _dioClient.instance.delete<Object?>(ApiPaths.task(taskId));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> transition(
    String taskId,
    TaskTransition transition, {
    String? note,
    String? reason,
    double? latitude,
    double? longitude,
  }) {
    final payload = <String, dynamic>{
      if (note != null && note.isNotEmpty) 'note': note,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
    };
    if (latitude != null) {
      payload['latitude'] = latitude;
    }
    if (longitude != null) {
      payload['longitude'] = longitude;
    }
    return _postMap(_transitionPath(taskId, transition), payload);
  }

  Future<Map<String, dynamic>> addNote(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _postMap(ApiPaths.taskNotes(taskId), payload);
  }

  Future<Map<String, dynamic>> addMaterial(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _postMap(ApiPaths.taskMaterials(taskId), payload);
  }

  Future<Map<String, dynamic>> addExpense(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _postMap(ApiPaths.taskExpenses(taskId), payload);
  }

  Future<Map<String, dynamic>> addRating(
    String taskId,
    Map<String, dynamic> payload,
  ) {
    return _postMap(ApiPaths.taskRating(taskId), payload);
  }

  Future<Map<String, dynamic>> uploadPhoto({
    required String taskId,
    required String filePath,
    required String type,
  }) async {
    try {
      final formData = FormData.fromMap({
        'type': type,
        'photo': await MultipartFile.fromFile(filePath),
      });
      final response = await _dioClient.instance.post<Object?>(
        ApiPaths.taskPhotosUpload(taskId),
        data: formData,
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<void> deletePhoto(String taskId, String photoId) async {
    try {
      await _dioClient.instance.delete<Object?>(
        ApiPaths.taskPhoto(taskId, photoId),
      );
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> uploadSignature({
    required String taskId,
    required List<int> bytes,
    required String clientName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'client_name': clientName,
        'signature': MultipartFile.fromBytes(bytes, filename: 'signature.png'),
      });
      final response = await _dioClient.instance.post<Object?>(
        ApiPaths.taskSignatureUpload(taskId),
        data: formData,
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<List<dynamic>> _getList(String path) async {
    try {
      final response = await _dioClient.instance.get<Object?>(path);
      return ApiResponseReader.asList(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> _getMap(String path) async {
    try {
      final response = await _dioClient.instance.get<Object?>(path);
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> _postMap(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dioClient.instance.post<Object?>(
        path,
        data: payload,
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  String _transitionPath(String taskId, TaskTransition transition) {
    switch (transition) {
      case TaskTransition.accept:
        return ApiPaths.taskAccept(taskId);
      case TaskTransition.reject:
        return ApiPaths.taskReject(taskId);
      case TaskTransition.onTheWay:
        return ApiPaths.taskOnTheWay(taskId);
      case TaskTransition.arrived:
        return ApiPaths.taskArrived(taskId);
      case TaskTransition.checkIn:
        return ApiPaths.taskCheckIn(taskId);
      case TaskTransition.start:
        return ApiPaths.taskStart(taskId);
      case TaskTransition.submitForReview:
        return ApiPaths.taskSubmitForReview(taskId);
      case TaskTransition.approve:
        return ApiPaths.taskApprove(taskId);
      case TaskTransition.reviewReject:
        return ApiPaths.taskReviewReject(taskId);
      case TaskTransition.reopen:
        return ApiPaths.taskReopen(taskId);
    }
  }
}
