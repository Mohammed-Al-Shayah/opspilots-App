import '../../../../core/utils/app_result.dart';
import '../entities/attendance_record_entity.dart';
import '../repositories/attendance_repository.dart';

class GetMyAttendanceUseCase {
  const GetMyAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<AppResult<List<AttendanceRecordEntity>>> call() {
    return _repository.getMyAttendance();
  }
}
