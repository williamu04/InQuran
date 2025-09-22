sealed class AuthState {}

class AuthInitial extends AuthState {
  @override
  String toString() => "Auth Initialization";
}

class AuthLoading extends AuthState {
  @override
  String toString() => "Auth Loading";
}

class AuthAuthenticated extends AuthState {
  final String jwt;
  AuthAuthenticated(this.jwt);
  @override
  String toString() => "Auth Authenticated";
}

class AuthUnauthenticated extends AuthState {
  @override
  String toString() => "Auth Unauthenticated";
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  String toString() => "Auth error: $message";
}