import '../../../../core/utils/app_result.dart';
import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class GetWorkspacesUseCase {
  const GetWorkspacesUseCase(this._repository);

  final WorkspaceRepository _repository;

  Future<AppResult<List<WorkspaceEntity>>> call() {
    return _repository.getWorkspaces();
  }
}
