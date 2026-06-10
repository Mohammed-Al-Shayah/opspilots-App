class ApiConstants {
  const ApiConstants._();

  static const baseUrl = String.fromEnvironment(
    'OPS_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api/v1',
  );
  static const connectTimeout = Duration(seconds: 20);
  static const sendTimeout = Duration(seconds: 20);
  static const receiveTimeout = Duration(seconds: 20);
  static const defaultLanguageCode = 'en';
}
