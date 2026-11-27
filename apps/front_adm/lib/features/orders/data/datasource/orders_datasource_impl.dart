import '../../../../app/settings/app_settings.dart';
import '../../../../share/network/custom_client_http.dart';
import '../../../../share/network/http_response_parser.dart';
import '../../../../share/util/result.dart';
import '../../../../share/util/log_util.dart';
import 'orders_datasource.dart';

class OrdersDatasourceImpl implements OrdersDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  OrdersDatasourceImpl({required CustomClientHttp http, Uri? baseUri})
    : _http = http,
      _baseUri = baseUri ?? AppSettings.apiBaseUri;

  @override
  Future<Result<Map<String, dynamic>, Exception>> createOrder(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _http.post(
        _baseUri.resolve('/api/orders'),
        body: body,
      );
      return HttpResponseParser.asObject(response);
    } catch (e) {
      errorLog(e.toString(), tag: 'OrdersDatasourceImpl');
      return Failure(Exception(e.toString()));
    }
  }
}
