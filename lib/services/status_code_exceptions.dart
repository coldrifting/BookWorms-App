class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);

  @override
  String toString() => message;
}

Exception getStatusCodeException(int statusCode, String body) {
  switch (statusCode) {
    case 401:
      return UnauthorizedException(body);
    default:
      return UnknownException(body);
  }
}