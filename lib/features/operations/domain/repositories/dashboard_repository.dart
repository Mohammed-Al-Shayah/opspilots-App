import '../../../../core/utils/app_result.dart';
import '../entities/dashboard_summary_entity.dart';

abstract class DashboardRepository {
  Future<AppResult<DashboardSummaryEntity>> getDashboard();

  Future<AppResult<DashboardSummaryEntity>> getReportsOverview();

  Future<AppResult<List<int>>> exportAttendanceCsv();

  Future<AppResult<List<int>>> exportAuditLogsCsv();
}
