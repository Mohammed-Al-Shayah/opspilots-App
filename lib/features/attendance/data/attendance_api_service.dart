import 'package:dio/dio.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/api_response_reader.dart';
import '../../../core/network/dio_client.dart';

class AttendanceApiService {
  const AttendanceApiService({required DioClient dioClient})
    : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<List<dynamic>> getMyAttendance() async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.attendanceMy,
      );
      return ApiResponseReader.asList(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<List<dynamic>> getCompanyAttendance() async {
    try {
      final response = await _dioClient.instance.get<Object?>(
        ApiPaths.attendance,
      );
      return ApiResponseReader.asList(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }

  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _postAttendance(ApiPaths.attendanceCheckIn, {
      'latitude': latitude,
      'longitude': longitude,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
  }

  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _postAttendance(ApiPaths.attendanceCheckOut, {
      'latitude': latitude,
      'longitude': longitude,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
  }

  Future<Map<String, dynamic>> _postAttendance(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dioClient.instance.post<Object?>(
        path,
        data: payload,
      );
      return ApiResponseReader.asMap(ApiResponseReader.data(response.data));
    } on DioException catch (exception) {
      throw _dioClient.mapFailure(exception);
    }
  }
}
