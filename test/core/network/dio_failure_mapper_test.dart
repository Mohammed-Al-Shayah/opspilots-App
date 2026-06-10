import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opspilots/core/errors/app_failure.dart';
import 'package:opspilots/core/network/dio_failure_mapper.dart';

void main() {
  group('DioFailureMapper', () {
    test('maps timeout errors to TimeoutFailure', () {
      final failure = DioFailureMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(failure, isA<TimeoutFailure>());
    });

    test('maps validation responses to ValidationFailure', () {
      final failure = DioFailureMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/tasks'),
            statusCode: 422,
            data: const {'message': 'Invalid task status.'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Invalid task status.');
    });

    test('maps forbidden responses to ForbiddenFailure', () {
      final failure = DioFailureMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/tasks'),
            statusCode: 403,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ForbiddenFailure>());
    });

    test('maps server responses to ServerFailure', () {
      final failure = DioFailureMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/tasks'),
            statusCode: 503,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ServerFailure>());
    });
  });
}
