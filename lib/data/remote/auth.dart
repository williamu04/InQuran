import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mtqmnuns/config/env.dart';
import 'package:mtqmnuns/exception/invalid_token.dart';

class TokenRemoteDataSource {
  final http.Client client;

  TokenRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchTokenRaw(String refreshToken, String sessionId) async {
    try {
      final response = await client.post(
        Uri.parse('${Env.baseUrl}/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Env.apiKey,
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
          'sessionId' : sessionId
          
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        throw InvalidRefreshTokenException('Sesi invalid atau expored');
      } else if (response.statusCode >= 500) {
        throw HttpException('Server error (${response.statusCode})');
      } else {
        throw HttpException('Unexpected error (${response.statusCode})');}
    } on http.ClientException catch (e) {
      throw HttpException('Kesalahan jaringan: ${e.message}');
    } on FormatException catch (e) {
      throw HttpException('Format respons tidak valid: ${e.message}');
    } catch (e) {
      throw HttpException('Kesalahan tidak terduga: ${e.toString()}');
    }
  }
}

