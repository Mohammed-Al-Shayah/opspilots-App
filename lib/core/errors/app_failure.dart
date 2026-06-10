sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure(super.message);
}

class CancellationFailure extends AppFailure {
  const CancellationFailure(super.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure(super.message);
}

class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure(super.message);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class ParsingFailure extends AppFailure {
  const ParsingFailure(super.message);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message);
}

class ConflictFailure extends AppFailure {
  const ConflictFailure(super.message);
}

class PermissionFailure extends AppFailure {
  const PermissionFailure(super.message);
}

class LocationFailure extends AppFailure {
  const LocationFailure(super.message);
}

class UploadFailure extends AppFailure {
  const UploadFailure(super.message);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message);
}
