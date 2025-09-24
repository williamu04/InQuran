import 'package:flutter/material.dart';

class HttpError implements Exception {
  final String message;

  HttpError(this.message) {
    _logError(); 
  }

  void _logError() {
    debugPrint('[HttpError] $runtimeType: $message');
  }

  @override
  String toString() => message;
}


class DataParsingError extends HttpError {
  DataParsingError(super.message);
}

class NoConnectionError extends HttpError {
  NoConnectionError(super.message);
}

class ServerUnreachableError extends HttpError {
  ServerUnreachableError(super.message);
}

class ClientError extends HttpError {
  ClientError(super.message);
}

class RefreshTokenInvalidError extends HttpError {
  RefreshTokenInvalidError(super.message);
}

class AuthenticationError extends HttpError {
  AuthenticationError(super.message);
}

class ApiKeyError extends HttpError {
  ApiKeyError(super.message);
}

class JwtError extends HttpError {
  JwtError(super.message);
}

class InternalServerError extends HttpError {
  InternalServerError(super.message);
}

class TimeoutError extends HttpError {
  TimeoutError(super.message);
}