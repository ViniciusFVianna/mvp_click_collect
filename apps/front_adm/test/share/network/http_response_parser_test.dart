import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/share/network/custom_http_response.dart';
import 'package:front_adm/share/network/http_response_parser.dart';

void main() {
  group('HttpResponseParser', () {
    test('lê registros do envelope data da API', () {
      final response = CustomHttpResponse(
        uri: Uri.parse('http://localhost/api/products'),
        statusCode: 200,
        body: {
          'data': [
            {'id': 'prod-001'},
          ],
        },
        headers: const {},
      );

      final result = HttpResponseParser.asList(response);

      expect(result.isSuccess, isTrue);
      expect(result.result.single['id'], 'prod-001');
    });

    test('retorna falha para status HTTP de erro', () {
      final response = CustomHttpResponse(
        uri: Uri.parse('http://localhost/api/orders'),
        statusCode: 404,
        body: const {'message': 'Rota não encontrada'},
        headers: const {},
      );

      final result = HttpResponseParser.asList(response);

      expect(result.isFailure, isTrue);
      expect(result.exception.toString(), 'Exception: Rota não encontrada');
    });

    test('não aceita envelope 2xx com data nulo como sucesso', () {
      final response = CustomHttpResponse(
        uri: Uri.parse('http://localhost/api/orders'),
        statusCode: 200,
        body: const {'data': null},
        headers: const {},
      );

      final result = HttpResponseParser.asList(response);

      expect(result.isFailure, isTrue);
    });
  });
}
