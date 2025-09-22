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

class InternalServerError extends AppError {
  InternalServerError(super.message);
}

class TimeoutError extends AppError {
  TimeoutError(super.message);
}