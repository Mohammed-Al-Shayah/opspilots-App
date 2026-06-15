import '../../../../core/utils/app_result.dart';
import '../repositories/tasks_repository.dart';

class UploadTaskPhotoParams {
  const UploadTaskPhotoParams({
    required this.taskId,
    required this.filePath,
    required this.type,
  });

  final String taskId;
  final String filePath;
  final String type;
}

class UploadTaskPhotoUseCase {
  const UploadTaskPhotoUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<void>> call(UploadTaskPhotoParams params) {
    return _repository.uploadPhoto(
      taskId: params.taskId,
      filePath: params.filePath,
      type: params.type,
    );
  }
}

class DeleteTaskPhotoUseCase {
  const DeleteTaskPhotoUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<void>> call({
    required String taskId,
    required String photoId,
  }) {
    return _repository.deletePhoto(taskId, photoId);
  }
}

class UploadTaskSignatureParams {
  const UploadTaskSignatureParams({
    required this.taskId,
    required this.bytes,
    required this.clientName,
  });

  final String taskId;
  final List<int> bytes;
  final String clientName;
}

class UploadTaskSignatureUseCase {
  const UploadTaskSignatureUseCase(this._repository);

  final TasksRepository _repository;

  Future<AppResult<void>> call(UploadTaskSignatureParams params) {
    return _repository.uploadSignature(
      taskId: params.taskId,
      bytes: params.bytes,
      clientName: params.clientName,
    );
  }
}
