import '../../../../core/utils/app_result.dart';
import '../../../tasks/domain/entities/task_item.dart';
import '../../domain/entities/field_home_summary_entity.dart';
import '../../domain/repositories/field_home_repository.dart';

class FieldHomeRepositoryImpl implements FieldHomeRepository {
  const FieldHomeRepositoryImpl();

  @override
  Future<AppResult<FieldHomeSummaryEntity>> getSummary() async {
    return AppResult.success(
      FieldHomeSummaryEntity(
        employeeName: 'أحمد محمد',
        roleLabel: 'Field Employee',
        todayCount: 2,
        pendingCount: 1,
        activeCount: 1,
        completedCount: 1,
        completionRate: 0.33,
        todayTasks: demoTasks.take(2).toList(),
      ),
    );
  }
}
