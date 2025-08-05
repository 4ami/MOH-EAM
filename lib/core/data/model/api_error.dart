enum ApiExceptionType {
  network('network'),
  timeout('timeout'),
  server('server'),
  cancel('cancel'),
  validation('validation'),
  unauthorized('unauthorized'),
  forbidden('forbidden'),
  notFound('notfound'),
  unknown('unknown');

  const ApiExceptionType(this.alias);
  final String alias;
}

class ApiException implements Exception {
  final String message, key;
  final int statusCode;
  final ApiExceptionType type;
  final dynamic data;

  const ApiException({
    this.key = 'general_error_message',
    required this.message,
    required this.statusCode,
    required this.type,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Type: $type, Key: $key)';
  }
}
