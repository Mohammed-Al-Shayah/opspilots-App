import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/dio_client.dart';

class DashboardApiService {
  const DashboardApiService({required DioClient dioClient})
    : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<Map<String, dynamic>> getDashboard() => _getMap(ApiPaths.dashboard);

  Future<Map<String, dynamic>> getReportsOverview() {
    return _getMap(ApiPaths.reportsOverview);
  }

  Future<List<int>> exportAttendanceCsv() => _download(ApiPaths.attendanceCsv);

  Future<List<int>> exportAuditLogsCsv() => _download(ApiPaths.auditLogsCsv);

  Future<Map<String, dynamic>> _getMap(String path) async {
    try {
      final response = await _dioClient.instance.get<Object?>(path);
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<List<int>> _download(String path) async {
    try {
      final response = await _dioClient.instance.get<List<int>>(
        path,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? const [];
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }
}
