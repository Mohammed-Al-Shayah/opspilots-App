import '../../../../core/utils/app_result.dart';
import '../entities/supervisor_summary_entity.dart';

abstract class SupervisorRepository {
  Future<AppResult<SupervisorSummaryEntity>> getSummary();
}
