import '../../../../core/utils/app_result.dart';
import '../../../role/domain/user_role.dart';
import '../entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<AppResult<List<WorkspaceEntity>>> getWorkspaces();

  Future<AppResult<WorkspaceEntity?>> selectWorkspace({
    required WorkspaceEntity workspace,
    required UserRole role,
    int? roleId,
  });

  Future<AppResult<WorkspaceEntity?>> getCurrentWorkspace();
}
