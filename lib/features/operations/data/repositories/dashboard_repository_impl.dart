import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../dashboard_api_service.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({required DashboardApiService apiService})
    : _apiService = apiService;

  final DashboardApiService _apiService;

  @override
  Future<AppResult<DashboardSummaryEntity>> getDashboard() {
    return _getSummary(_apiService.getDashboard);
  }

  @override
  Future<AppResult<DashboardSummaryEntity>> getReportsOverview() {
    return _getSummary(_apiService.getReportsOverview);
  }

  @override
  Future<AppResult<List<int>>> exportAttendanceCsv() {
    return _download(_apiService.exportAttendanceCsv);
  }

  @override
  Future<AppResult<List<int>>> exportAuditLogsCsv() {
    return _download(_apiService.exportAuditLogsCsv);
  }

  Future<AppResult<DashboardSummaryEntity>> _getSummary(
    Future<Map<String, dynamic>> Function() request,
  ) async {
    try {
      return AppResult.success(DashboardSummaryModel.fromJson(await request()));
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  Future<AppResult<List<int>>> _download(
    Future<List<int>> Function() request,
  ) async {
    try {
      return AppResult.success(await request());
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(UnknownFailure(error.toString()));
    }
  }
}
