import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../../role/domain/user_role.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/workspace_remote_datasource.dart';
import '../models/workspace_model.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  const WorkspaceRepositoryImpl({
    required WorkspaceRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final WorkspaceRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<WorkspaceEntity>>> getWorkspaces() async {
    try {
      final rawWorkspaces = await _remoteDataSource.getWorkspaces();
      final workspaces = rawWorkspaces
          .map(ApiResponseReader.asMap)
          .map(WorkspaceModel.fromJson)
          .toList();
      return AppResult.success(workspaces);
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on FormatException catch (error) {
      return AppResult.failure(ParsingFailure(error.message));
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<WorkspaceEntity?>> selectWorkspace({
    required WorkspaceEntity workspace,
    required UserRole role,
    int? roleId,
  }) async {
    try {
      final response = await _remoteDataSource.selectWorkspace(
        companyId: workspace.companyId,
        branchId: workspace.branchId,
        role: role,
        roleId: roleId,
      );
      if (response.isEmpty) {
        return AppResult.success(null);
      }
      return AppResult.success(WorkspaceModel.fromJson(response));
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on FormatException {
      return AppResult.success(null);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  @override
  Future<AppResult<WorkspaceEntity?>> getCurrentWorkspace() async {
    try {
      final response = await _remoteDataSource.getCurrentWorkspace();
      if (response.isEmpty) {
        return AppResult.success(null);
      }
      return AppResult.success(WorkspaceModel.fromJson(response));
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on FormatException {
      return AppResult.success(null);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }
}
