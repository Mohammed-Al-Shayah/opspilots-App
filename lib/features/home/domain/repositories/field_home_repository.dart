import '../../../../core/utils/app_result.dart';
import '../entities/field_home_summary_entity.dart';

abstract class FieldHomeRepository {
  Future<AppResult<FieldHomeSummaryEntity>> getSummary();
}
