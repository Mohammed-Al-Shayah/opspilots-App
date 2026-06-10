import '../../../../core/utils/app_result.dart';
import '../entities/supervisor_summary_entity.dart';
import '../repositories/supervisor_repository.dart';

class GetSupervisorSummaryUseCase {
  const GetSupervisorSummaryUseCase(this._repository);

  final SupervisorRepository _repository;

  Future<AppResult<SupervisorSummaryEntity>> call() {
    return _repository.getSummary();
  }
}
