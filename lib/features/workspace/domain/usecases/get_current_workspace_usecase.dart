import '../../../../core/utils/app_result.dart';
import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class GetCurrentWorkspaceUseCase {
  const GetCurrentWorkspaceUseCase(this._repository);

  final WorkspaceRepository _repository;

  Future<AppResult<WorkspaceEntity?>> call() {
    return _repository.getCurrentWorkspace();
  }
}
