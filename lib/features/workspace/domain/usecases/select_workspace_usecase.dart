import '../../../../core/utils/app_result.dart';
import '../../../role/domain/user_role.dart';
import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class SelectWorkspaceParams {
  const SelectWorkspaceParams({
    required this.workspace,
    required this.role,
    this.roleId,
  });

  final WorkspaceEntity workspace;
  final int? roleId;
  final UserRole role;
}

class SelectWorkspaceUseCase {
  const SelectWorkspaceUseCase(this._repository);

  final WorkspaceRepository _repository;

  Future<AppResult<WorkspaceEntity?>> call(SelectWorkspaceParams params) {
    return _repository.selectWorkspace(
      workspace: params.workspace,
      role: params.role,
      roleId: params.roleId,
    );
  }
}
