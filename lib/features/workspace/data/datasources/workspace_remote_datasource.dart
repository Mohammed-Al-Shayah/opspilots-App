import '../workspace_api_service.dart';

abstract class WorkspaceRemoteDataSource {
  Future<List<dynamic>> getWorkspaces();

  Future<Map<String, dynamic>> selectWorkspace({
    required int companyId,
    int? branchId,
    required int roleId,
  });

  Future<Map<String, dynamic>> getCurrentWorkspace();
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  const WorkspaceRemoteDataSourceImpl({required WorkspaceApiService apiService})
    : _apiService = apiService;

  final WorkspaceApiService _apiService;

  @override
  Future<List<dynamic>> getWorkspaces() => _apiService.getWorkspaces();

  @override
  Future<Map<String, dynamic>> selectWorkspace({
    required int companyId,
    int? branchId,
    required int roleId,
  }) {
    return _apiService.selectWorkspace(
      companyId: companyId,
      branchId: branchId,
      roleId: roleId,
    );
  }

  @override
  Future<Map<String, dynamic>> getCurrentWorkspace() {
    return _apiService.getCurrentWorkspace();
  }
}
