import 'dart:convert';
import 'dart:developer';
import 'dart:io' show HttpClient;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiClient {
  static const String _defaultBaseUrl = 'http://localhost:3000';
  static const String _androidBaseUrl = 'http://localhost:3000';

  final http.Client _client;
  final String baseUrl;

  ApiClient._({http.Client? client, String? customBaseUrl})
      : _client = client ?? _createClient(),
        baseUrl = customBaseUrl ?? _resolveBaseUrl();

  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();

  static String _resolveBaseUrl() {
    if (kIsWeb) {
      return _defaultBaseUrl;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidBaseUrl;
    }
    return _defaultBaseUrl;
  }

  static http.Client _createClient() {
    if (kIsWeb) {
      return http.Client();
    }
    final ioHttpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    return IOClient(ioHttpClient);
  }

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      return _processResponse(response);
    } catch (e) {
      if (baseUrl.startsWith('https://')) {
        final httpUrl = baseUrl.replaceFirst('https://', 'http://');
        final httpUri = Uri.parse('$httpUrl$path');
        final response = await _client.get(
          httpUri,
          headers: {'Content-Type': 'application/json'},
        );
        return _processResponse(response);
      }
      rethrow;
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final bodyJson = jsonEncode(body);
    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: bodyJson,
      );
      return _processResponse(response);
    } catch (e) {
      if (baseUrl.startsWith('https://')) {
        final httpUrl = baseUrl.replaceFirst('https://', 'http://');
        final httpUri = Uri.parse('$httpUrl$path');
        final response = await _client.post(
          httpUri,
          headers: {'Content-Type': 'application/json'},
          body: bodyJson,
        );
        return _processResponse(response);
      }
      rethrow;
    }
  }

   dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String message = 'Erro de comunicação (${response.statusCode})';
      try {
        _log(
          response.request!.url.toString(),
          response.request!.headers,
          response.body,
        );
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          message = decoded['message'].toString();
        } else if (decoded is Map && decoded.containsKey('error')) {
          message = decoded['error'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    }
  }

  void _log(String url, Map<String, String> headers, String body) {
    log('URL: $url');
    log('Headers: $headers');
    log('Body: $body');
  }

}
