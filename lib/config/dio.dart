import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioConfig {
  Dio init() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
    ));

    dio.interceptors.addAll([
      LoggingInterceptor(),
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          if (e.error is HttpException) {
            debugPrint('Caught HttpException: ${e.error}');
          } else if (e.error is SocketException) {
            debugPrint('No internet: ${e.error}');
          }
          return handler.next(e);
        },
      ),
    ]);

    return dio;
  }
}


class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️ Request: ${options.method} ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ Response [${response.statusCode}]: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ Dio Error: ${err.message}');
    if (err.response != null) {
      debugPrint('Status: ${err.response?.statusCode}');
      debugPrint('Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
