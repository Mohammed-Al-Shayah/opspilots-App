import '../../../../core/utils/app_result.dart';
import '../entities/field_home_summary_entity.dart';
import '../repositories/field_home_repository.dart';

class GetFieldHomeSummaryUseCase {
  const GetFieldHomeSummaryUseCase(this._repository);

  final FieldHomeRepository _repository;

  Future<AppResult<FieldHomeSummaryEntity>> call() {
    return _repository.getSummary();
  }
}
