class ApiResponseReader {
  const ApiResponseReader._();

  static Map<String, dynamic> asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return <String, dynamic>{};
  }

  static List<dynamic> asList(Object? value) {
    if (value is List) {
      return value;
    }
    return const [];
  }

  static Object? data(Object? value) {
    final map = asMap(value);
    return map['data'] ?? value;
  }

  static String? stringAt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
