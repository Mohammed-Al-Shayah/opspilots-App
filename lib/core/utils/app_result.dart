import '../errors/app_failure.dart';

class AppResult<T> {
  const AppResult._({this.data, this.failure});

  final T? data;
  final AppFailure? failure;

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    final currentFailure = this.failure;
    if (currentFailure != null) {
      return failure(currentFailure);
    }

    return success(data as T);
  }

  factory AppResult.success(T data) => AppResult._(data: data);

  factory AppResult.failure(AppFailure failure) {
    return AppResult._(failure: failure);
  }
}
