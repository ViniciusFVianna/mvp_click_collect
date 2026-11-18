import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'custom_client_http.dart';
import 'custom_http_response.dart';

class HttpImpl implements CustomClientHttp {
  final http.Client httpClient;

  HttpImpl({required this.httpClient});

  @override
  Future<CustomHttpResponse> get(Uri uri, {Map<String, String>? headers}) async {
    final response = await httpClient.get(uri, headers: await _header(headers));
    return CustomHttpResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      body: _toMap(response.bodyBytes),
      uri: uri,
    );
  }

  @override
  Future<CustomHttpResponse> post(Uri uri, {Map<String, String>? headers, Object? body}) async {
    final response = await httpClient.post(
      uri,
      headers: await _header(headers),
      body: body is String ? body : jsonEncode(body),
    );
    return CustomHttpResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      body: _toMap(response.bodyBytes),
      uri: uri,
      request: body is Map<String, dynamic> ? body : null,
    );
  }

  @override
  Future<CustomHttpResponse> put(Uri uri, {Map<String, String>? headers, Object? body}) async {
    final response = await httpClient.put(
      uri,
      headers: await _header(headers),
      body: body is String ? body : jsonEncode(body),
    );
    return CustomHttpResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      body: _toMap(response.bodyBytes),
      uri: uri,
    );
  }

  @override
  Future<CustomHttpResponse> delete(Uri uri, {Map<String, String>? headers}) async {
    final response = await httpClient.delete(uri, headers: await _header(headers));
    return CustomHttpResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      body: _toMap(response.bodyBytes),
      uri: uri,
    );
  }

  Future<Map<String, String>> _header(Map<String, String>? headers) async {
    return headers ?? {'Content-Type': 'application/json'};
  }

  Map<String, dynamic> _toMap(Uint8List bodyBytes) {
    try {
      if (bodyBytes.isEmpty) return {};
      final decoded = jsonDecode(utf8.decode(bodyBytes));
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } catch (_) {
      return {'result': utf8.decode(bodyBytes)};
    }
  }
}
