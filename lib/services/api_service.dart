import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  // ─── Base URL (iOS Simulator → localhost works directly) ───
  static const String baseUrl = 'http://localhost:5001/api';

  // ─── Build headers with optional auth token ───────────────
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (auth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ─── GET ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool auth = true,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(auth: auth),
    );
    return _handleResponse(response);
  }

  // ─── POST ─────────────────────────────────────────────────
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(auth: auth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  // ─── PUT ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(auth: auth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  // ─── DELETE ───────────────────────────────────────────────
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool auth = true,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(auth: auth),
    );
    return _handleResponse(response);
  }

  // ─── Response handler ─────────────────────────────────────
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {'data': body};
    } else {
      final message = body is Map && body.containsKey('message')
          ? body['message']
          : 'Something went wrong';
      throw ApiException(message, response.statusCode);
    }
  }
}

// ─── Custom exception ───────────────────────────────────────
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
