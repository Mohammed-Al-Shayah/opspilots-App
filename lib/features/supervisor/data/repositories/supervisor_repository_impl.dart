import '../../../../core/utils/app_result.dart';
import '../../../tasks/domain/entities/task_item.dart';
import '../../domain/entities/supervisor_summary_entity.dart';
import '../../domain/repositories/supervisor_repository.dart';

class SupervisorRepositoryImpl implements SupervisorRepository {
  const SupervisorRepositoryImpl();

  @override
  Future<AppResult<SupervisorSummaryEntity>> getSummary() async {
    return AppResult.success(
      SupervisorSummaryEntity(
        supervisorName: 'خالد العلي',
        activeTeamCount: 8,
        pendingReviewsCount: 0,
        completedTodayCount: 1,
        delayedCount: 2,
        teamTasks: demoTasks,
      ),
    );
  }
}
