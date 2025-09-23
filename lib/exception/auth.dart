import 'package:flutter/material.dart';

class AppError implements Exception {
  final String message;

  AppError(this.message) {
    _logError(); 
  }

  void _logError() {
    debugPrint('[AppError] $runtimeType: $message');
  }

  @override
  String toString() => message;
}


class DataParsingError extends AppError {
  DataParsingError(super.message);
}

class NoConnectionError extends AppError {
  NoConnectionError(super.message);
}

class ServerUnreachableError extends AppError {
  ServerUnreachableError(super.message);
}

class ClientError extends AppError {
  ClientError(super.message);
}

class RefreshTokenInvalidError extends AppError {
  RefreshTokenInvalidError(super.message);
}

class AuthenticationError extends AppError {
  AuthenticationError(super.message);
}

class ApiKeyError extends AppError {
  ApiKeyError(super.message);
}

class JwtError extends AppError {
  JwtError(super.message);
}

class InternalServerError extends AppError {
  InternalServerError(super.message);
}

class TimeoutError extends AppError {
  TimeoutError(super.message);
}