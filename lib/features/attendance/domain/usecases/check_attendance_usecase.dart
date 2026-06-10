import '../../../../core/utils/app_result.dart';
import '../entities/attendance_record_entity.dart';
import '../repositories/attendance_repository.dart';

class AttendanceLocationParams {
  const AttendanceLocationParams({
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  final double latitude;
  final double longitude;
  final String? notes;
}

class CheckInUseCase {
  const CheckInUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<AppResult<AttendanceRecordEntity?>> call(
    AttendanceLocationParams params,
  ) {
    return _repository.checkIn(
      latitude: params.latitude,
      longitude: params.longitude,
      notes: params.notes,
    );
  }
}

class CheckOutUseCase {
  const CheckOutUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<AppResult<AttendanceRecordEntity?>> call(
    AttendanceLocationParams params,
  ) {
    return _repository.checkOut(
      latitude: params.latitude,
      longitude: params.longitude,
      notes: params.notes,
    );
  }
}
