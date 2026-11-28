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
  Future<Result<List<Map<String, dynamic>>, Exception>> getOrders() async {
    try {
      return HttpResponseParser.asList(
        await _http.get(_baseUri.resolve('/api/orders')),
      );
    } catch (e) {
      errorLog(e.toString(), tag: 'OrdersDatasourceImpl.getOrders');
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> createOrder(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _http.post(
        _baseUri.resolve('/api/orders'),
        body: body,
      );
      debugLog('${response.body}');
      return HttpResponseParser.asObject(response);
    } catch (e) {
      errorLog(e.toString(), tag: 'OrdersDatasourceImpl');
      return Failure(Exception(e.toString()));
    }
  }
}
