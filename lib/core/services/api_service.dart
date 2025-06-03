import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> authenticateWithProvider({
    required String provider,
    required String tokenKey,
    required String tokenValue,
  }) async {
    final url = Uri.parse('${Urls.baseUrl}/auth/login'); 
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'provider': provider,
        tokenKey: tokenValue,
      }),
    );
    return response;
  }
}
