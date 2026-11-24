import 'custom_http_response.dart';

abstract class CustomClientHttp {
  Future<CustomHttpResponse> get(Uri url, {Map<String, String>? headers});
  Future<CustomHttpResponse> post(Uri url, {Map<String, String>? headers, Object? body});
  Future<CustomHttpResponse> put(Uri url, {Map<String, String>? headers, Object? body});
  Future<CustomHttpResponse> delete(Uri url, {Map<String, String>? headers});
}
