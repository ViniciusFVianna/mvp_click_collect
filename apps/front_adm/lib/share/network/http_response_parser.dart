import '../util/result.dart';
import 'custom_http_response.dart';

class HttpResponseParser {
  HttpResponseParser._();

  static Result<Map<String, dynamic>, Exception> asObject(
    CustomHttpResponse response,
  ) {
    final error = _errorMessage(response);
    if (error != null) return Failure(Exception(error));

    final payload = response.body.containsKey('data')
        ? response.body['data']
        : response.body;
    if (payload is Map<String, dynamic>) return Success(payload);
    if (payload is Map) return Success(Map<String, dynamic>.from(payload));
    return Failure(FormatException('A API retornou um objeto inválido.'));
  }

  static Result<List<Map<String, dynamic>>, Exception> asList(
    CustomHttpResponse response,
  ) {
    final error = _errorMessage(response);
    if (error != null) return Failure(Exception(error));

    final payload = response.body.containsKey('data')
        ? response.body['data']
        : response.body['products'];
    if (payload is! List) {
      return Failure(FormatException('A API retornou uma lista inválida.'));
    }

    final records = <Map<String, dynamic>>[];
    for (final item in payload) {
      if (item is Map<String, dynamic>) {
        records.add(item);
      } else if (item is Map) {
        records.add(Map<String, dynamic>.from(item));
      } else {
        return Failure(FormatException('A API retornou um item inválido.'));
      }
    }
    return Success(records);
  }

  static String? _errorMessage(CustomHttpResponse response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return null;
    return response.body['message']?.toString() ??
        'Falha na requisição HTTP (${response.statusCode}).';
  }
}
