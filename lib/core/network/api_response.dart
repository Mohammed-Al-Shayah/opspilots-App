class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors = const {},
  });

  final bool success;
  final String? message;
  final T? data;
  final Map<String, List<String>> errors;
}
