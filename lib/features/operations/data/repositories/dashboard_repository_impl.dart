import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required DashboardRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<DashboardSummaryEntity>> getDashboard() {
    return _getSummary(_remoteDataSource.getDashboard);
  }

  @override
  Future<AppResult<DashboardSummaryEntity>> getReportsOverview() {
    return _getSummary(_remoteDataSource.getReportsOverview);
  }

  @override
  Future<AppResult<List<int>>> exportAttendanceCsv() {
    return _download(_remoteDataSource.exportAttendanceCsv);
  }

  @override
  Future<AppResult<List<int>>> exportAuditLogsCsv() {
    return _download(_remoteDataSource.exportAuditLogsCsv);
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
