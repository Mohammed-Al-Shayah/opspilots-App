import '../attendance_api_service.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<dynamic>> getMyAttendance();

  Future<List<dynamic>> getCompanyAttendance();

  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  });

  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  const AttendanceRemoteDataSourceImpl({
    required AttendanceApiService apiService,
  }) : _apiService = apiService;

  final AttendanceApiService _apiService;

  @override
  Future<List<dynamic>> getMyAttendance() => _apiService.getMyAttendance();

  @override
  Future<List<dynamic>> getCompanyAttendance() {
    return _apiService.getCompanyAttendance();
  }

  @override
  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _apiService.checkIn(
      latitude: latitude,
      longitude: longitude,
      notes: notes,
    );
  }

  @override
  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _apiService.checkOut(
      latitude: latitude,
      longitude: longitude,
      notes: notes,
    );
  }
}
