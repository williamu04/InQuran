class InvalidRefreshTokenException implements Exception {
  final String message;
  InvalidRefreshTokenException(this.message);

  @override
  String toString() => 'InvalidRefreshTokenException: $message';
}