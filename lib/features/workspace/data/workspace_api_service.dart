import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/api_token_store.dart';
import '../../../core/network/dio_client.dart';
import '../../role/domain/user_role.dart';

class WorkspaceApiService {
  const WorkspaceApiService({
    required DioClient dioClient,
    required ApiTokenStore tokenStore,
  }) : _dioClient = dioClient,
       _tokenStore = tokenStore;

  final DioClient _dioClient;
  final ApiTokenStore _tokenStore;

  Future<List<dynamic>> getWorkspaces() async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.workspaces,
      );
      final data = ApiResponseReader.data(response.data);
      final directList = ApiResponseReader.asList(data);
      if (directList.isNotEmpty) {
        return directList;
      }

      final dataMap = ApiResponseReader.asMap(data);
      return ApiResponseReader.asList(
        dataMap['workspaces'] ??
            dataMap['companies'] ??
            dataMap['items'] ??
            dataMap['rows'] ??
            dataMap['data'],
      );
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> selectWorkspace({
    required int companyId,
    int? branchId,
    required UserRole role,
    int? roleId,
  }) async {
    try {
      await _tokenStore.clearWorkspace();
      final response = await _dioClient.instance.post<Object?>(
        ApiPaths.selectWorkspace,
        data: {
          'company_id': companyId,
          'branch_id': branchId,
          // ignore: use_null_aware_elements
          if (roleId case final value?) 'role_id': value,
          'role': role.apiValue,
          'role_key': role.apiValue,
        },
      );
      final root = ApiResponseReader.asMap(response.data);
      final data = ApiResponseReader.asMap(root['data'] ?? root);
      final token =
          ApiResponseReader.stringAt(root, const [
            'token',
            'access_token',
            'workspace_token',
          ]) ??
          ApiResponseReader.stringAt(data, const [
            'token',
            'access_token',
            'workspace_token',
          ]);

      if (token != null) {
        await _tokenStore.saveWorkspaceToken(token);
      }
      await _tokenStore.saveWorkspaceId(companyId.toString());
      return data;
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> getCurrentWorkspace() async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.currentWorkspace,
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }
}
