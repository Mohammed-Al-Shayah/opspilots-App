import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_response_reader.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/attendance_record_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  const AttendanceRepositoryImpl({
    required AttendanceRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AttendanceRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<AttendanceRecordEntity>>> getMyAttendance() async {
    return _loadList(_remoteDataSource.getMyAttendance);
  }

  @override
  Future<AppResult<List<AttendanceRecordEntity>>> getCompanyAttendance() async {
    return _loadList(_remoteDataSource.getCompanyAttendance);
  }

  @override
  Future<AppResult<AttendanceRecordEntity?>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _postRecord(
      () => _remoteDataSource.checkIn(
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      ),
    );
  }

  @override
  Future<AppResult<AttendanceRecordEntity?>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _postRecord(
      () => _remoteDataSource.checkOut(
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      ),
    );
  }

  Future<AppResult<List<AttendanceRecordEntity>>> _loadList(
    Future<List<dynamic>> Function() request,
  ) async {
    try {
      final rows = await request();
      return AppResult.success(
        rows
            .map(ApiResponseReader.asMap)
            .map(AttendanceRecordModel.fromJson)
            .toList(),
      );
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }

  Future<AppResult<AttendanceRecordEntity?>> _postRecord(
    Future<Map<String, dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      if (response.isEmpty) {
        return AppResult.success(null);
      }
      return AppResult.success(AttendanceRecordModel.fromJson(response));
    } on AppFailure catch (failure) {
      return AppResult.failure(failure);
    } on Object catch (error) {
      return AppResult.failure(ParsingFailure(error.toString()));
    }
  }
}
