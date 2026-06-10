import '../../../../core/utils/app_result.dart';
import '../entities/attendance_record_entity.dart';

abstract class AttendanceRepository {
  Future<AppResult<List<AttendanceRecordEntity>>> getMyAttendance();

  Future<AppResult<List<AttendanceRecordEntity>>> getCompanyAttendance();

  Future<AppResult<AttendanceRecordEntity?>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  });

  Future<AppResult<AttendanceRecordEntity?>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  });
}
