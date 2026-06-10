import 'package:dio/dio.dart';

import '../errors/app_failure.dart';

class DioFailureMapper {
  const DioFailureMapper._();

  static AppFailure map(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(_message(exception, 'Request timed out.'));
      case DioExceptionType.cancel:
        return CancellationFailure(
          _message(exception, 'Request was cancelled.'),
        );
      case DioExceptionType.connectionError:
        return NetworkFailure(
          _message(exception, 'No internet connection. Please try again.'),
        );
      case DioExceptionType.badCertificate:
        return NetworkFailure(
          _message(exception, 'Could not establish a secure connection.'),
        );
      case DioExceptionType.badResponse:
        return _mapStatusCode(exception);
      case DioExceptionType.unknown:
        return UnknownFailure(
          _message(exception, 'Unexpected network error occurred.'),
        );
    }
  }

  static AppFailure _mapStatusCode(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final message = _message(exception, _defaultStatusMessage(statusCode));

    switch (statusCode) {
      case 400:
      case 422:
        return ValidationFailure(message);
      case 401:
        return UnauthorizedFailure(message);
      case 403:
        return ForbiddenFailure(message);
      case 404:
        return NotFoundFailure(message);
      case 409:
        return ConflictFailure(message);
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerFailure(message);
    }

    return UnknownFailure(message);
  }

  static String _message(DioException exception, String fallback) {
    final responseData = exception.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      final error = responseData['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }
    }

    final exceptionMessage = exception.message;
    if (exceptionMessage != null && exceptionMessage.trim().isNotEmpty) {
      return exceptionMessage;
    }

    return fallback;
  }

  static String _defaultStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
      case 422:
        return 'Submitted data is invalid.';
      case 401:
        return 'Your session has expired. Please sign in again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'This request conflicts with the current resource state.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Server error occurred. Please try again later.';
    }

    return 'Unexpected network error occurred.';
  }
}
