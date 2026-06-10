import '../../../../core/utils/app_result.dart';
import '../repositories/dashboard_repository.dart';

class ExportAttendanceCsvUseCase {
  const ExportAttendanceCsvUseCase(this._repository);

  final DashboardRepository _repository;

  Future<AppResult<List<int>>> call() {
    return _repository.exportAttendanceCsv();
  }
}

class ExportAuditLogsCsvUseCase {
  const ExportAuditLogsCsvUseCase(this._repository);

  final DashboardRepository _repository;

  Future<AppResult<List<int>>> call() {
    return _repository.exportAuditLogsCsv();
  }
}
