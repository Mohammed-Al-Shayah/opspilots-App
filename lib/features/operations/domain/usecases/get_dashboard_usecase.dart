import '../../../../core/utils/app_result.dart';
import '../entities/dashboard_summary_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  const GetDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  Future<AppResult<DashboardSummaryEntity>> call() {
    return _repository.getDashboard();
  }
}
