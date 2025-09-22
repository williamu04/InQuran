
  import 'package:dio/dio.dart';
import 'package:mtqmnuns/exception/auth.dart';

Never dioExceptionHandler(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw TimeoutError('Request timed out: ${e.message}');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      if (statusCode == 400 || statusCode == 401) {
        throw ClientError('Invalid parameters: $data');
      } else if (statusCode != null && statusCode >= 500) {
        throw InternalServerError('Server error ($statusCode)');
      } else {
        throw ClientError('Request failed: $data');
      }
    case DioExceptionType.connectionError:
      throw ServerUnreachableError('Tidak ada koneksi: ${e.error}');

    default:
      throw ServerUnreachableError('Server tidak dapat dijangkau: ${e.error}');
  }
}