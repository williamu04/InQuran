
import 'package:flutter/material.dart';

class AuthError implements Exception {
  final String message;

  AuthError(this.message) {
    _logError(); 
  }

  void _logError() {
    debugPrint('[AuthError] $runtimeType: $message');
  }

  @override
  String toString() => message;
}

class TokenRefreshException extends AuthError {
  TokenRefreshException(super.message);
}

class UnauthenticatedException extends AuthError {
  UnauthenticatedException(super.message);
}