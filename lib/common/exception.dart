
import 'package:dio/dio.dart';
import 'package:mtqmnuns/exception/http.dart';

Never dioExceptionHandler(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw TimeoutError('Servis tidak aktif atau tidak dapat dijangkau tolong hubungi: mtqmnuns@gmail.com');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      if (statusCode == 401) {
        throw AuthenticationError(data['message']);
      } else if (statusCode == 400) {
        throw ClientError('${data['message']}');
      } 
      else if (statusCode != null && statusCode >= 500) {
        throw InternalServerError('terdapat kesalahan tak terduga pada server. tolong hubungi mtqmnuns@gmail.com');
      } else {
        throw InternalServerError('terdapat kesalahan tak terduga pada server. tolong hubungi mtqmnuns@gmail.com');
      }
    case DioExceptionType.connectionError:
      throw ServerUnreachableError('Tidak ada koneksi Internet');

    default:
      throw ServerUnreachableError('Server tidak dapat dijangkau, hubungi: mtqmnuns@gmail.com');
  }
}