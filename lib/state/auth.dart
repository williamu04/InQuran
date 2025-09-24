sealed class AuthState {}

class AuthInitial extends AuthState {
  @override
  String toString() => "Auth Initialization";
}

class AuthLoading extends AuthState {
  @override
  String toString() => "Auth Loading";
}

class AuthLoggingOut extends AuthState {
  @override
  String toString() => "Auth Logging Out";
}

class AuthAuthenticatedOffline extends AuthState {
  @override
  String toString() => "Auth Offline";
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

class AuthSessionExpired extends AuthState {
  @override
  String toString() => "Auth Session Expired";
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  String toString() => "Auth error: $message";
}