
import 'package:dio/dio.dart';
import 'package:mtqmnuns/exception/http.dart';

Never dioExceptionHandler(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw TimeoutError('Servis tidak aktif atau tidak dapat dijangkau tolong hubungi: mtqmnuns@gmail.com');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;
      final contentType = e.response?.headers.value('content-type');
      final data = e.response?.data;

      final message = parseErrorMessage(contentType, data);

      if (statusCode == 401) {
        throw AuthenticationError(message);
      } else if (statusCode == 400) {
        throw ClientError(message);
      } else if (statusCode >= 402 && statusCode <= 499) {
        throw ClientError(message);
      } else if (statusCode >= 500) {
        throw InternalServerError(message);
      } else {
        throw InternalServerError(message);
      }

    case DioExceptionType.connectionError:
      throw ServerUnreachableError('Tidak ada koneksi Internet');

    default:
      throw ServerUnreachableError('Server tidak dapat dijangkau, hubungi: mtqmnuns@gmail.com');
  }
}

String parseErrorMessage(String? contentType, dynamic data, {int? statusCode}) {
  contentType = contentType ?? '';
  List<String> messages = [];

  try {
    if (contentType.contains('application/json')) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message') && data['message'] != null) {
          messages.add(data['message'].toString());
        }
        if (data.containsKey('error') && data['error'] != null) {
          messages.add(data['error'].toString());
        }
        if (messages.isEmpty) {
          messages.add('No Error Message Provided');
        }
      } else {
        messages.add('JSON Parsing Error');
      }
    } 
    else if (contentType.contains('text/html')) {
      if (data is String) {
        final regex = RegExp(r'>([^<>]+)<');
        final matches = regex.allMatches(data);
        messages = matches
            .map((m) => m.group(1)?.trim())
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .toSet() 
            .toList();
        if (messages.isEmpty) messages.add('Unknown error');
      } else {
        messages.add('HTML Parsing error');
      }
    } 
    else if (data is String && data.isNotEmpty) {
      messages.add(data);
    } 
    else {
      messages.add('Unknown error');
    }
  } catch (e) {
    messages.add('Parsing error: ${e.toString()}');
  }

  // Combine messages and append status code
  final combined = messages.join(', ');
  return statusCode != null ? '$combined ($statusCode)' : combined;
}
