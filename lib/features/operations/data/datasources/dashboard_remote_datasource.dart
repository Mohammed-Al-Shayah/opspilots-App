import '../dashboard_api_service.dart';

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboard();

  Future<Map<String, dynamic>> getReportsOverview();

  Future<List<int>> exportAttendanceCsv();

  Future<List<int>> exportAuditLogsCsv();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl({required DashboardApiService apiService})
    : _apiService = apiService;

  final DashboardApiService _apiService;

  @override
  Future<Map<String, dynamic>> getDashboard() => _apiService.getDashboard();

  @override
  Future<Map<String, dynamic>> getReportsOverview() {
    return _apiService.getReportsOverview();
  }

  @override
  Future<List<int>> exportAttendanceCsv() {
    return _apiService.exportAttendanceCsv();
  }

  @override
  Future<List<int>> exportAuditLogsCsv() {
    return _apiService.exportAuditLogsCsv();
  }
}
