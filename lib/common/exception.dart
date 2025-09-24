
  import 'package:dio/dio.dart';
import 'package:mtqmnuns/exception/http.dart';

Never dioExceptionHandler(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw TimeoutError('Request timed out: ${e.message}');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data['data'];
      if (statusCode == 401) {
        throw AuthenticationError(data['message']);
      } else if (statusCode == 400) {
        throw ClientError('Invalid parameters: ${data['message']}');
      } 
      else if (statusCode != null && statusCode >= 500) {
        throw InternalServerError('Server error ($statusCode)');
      } else {
        throw ClientError('Request Gagal: ${data['message']}');
      }
    case DioExceptionType.connectionError:
      throw ServerUnreachableError('Tidak ada koneksi: ${e.error}');

    default:
      throw ServerUnreachableError('Server tidak dapat dijangkau: ${e.error}');
  }
}