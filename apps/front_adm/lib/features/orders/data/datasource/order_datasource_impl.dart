import 'package:front_adm/app/settings/app_settings.dart';
import 'package:front_adm/share/network/custom_client_http.dart';
import 'package:front_adm/share/network/http_response_parser.dart';
import 'package:front_adm/share/util/log_util.dart';
import 'package:front_adm/share/util/result.dart';

import '../../domain/model/order_model.dart';
import 'order_datasource.dart';

class OrderDatasourceImpl implements OrderDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  OrderDatasourceImpl({
    required this._http,
    Uri? baseUri,
  })  : _baseUri = baseUri ?? AppSettings.apiBaseUri;

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getOrders() async {
    try {
      return HttpResponseParser.asList(
        await _http.get(_baseUri.resolve('/api/orders')),
      );
    } catch (error) {
      errorLog(error.toString(), tag: 'OrderDatasourceImpl.getOrders');
      return Failure(Exception(error.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> createOrder(
    CreateOrderParams params,
  ) async {
    late final Result<Map<String, dynamic>, Exception> result;
    try {
      final response = await _http.post(
        _baseUri.resolve('/api/orders'),
        body: params.toMap(),
      );
      final parsed = HttpResponseParser.asObject(response);
      result = parsed.when(
        success: (data) => Success({...params.toMap(), ...data}),
        exception: Failure.new,
      );
    } catch (error) {
      errorLog(error.toString(), tag: 'OrderDatasourceImpl.createOrder');
      return Failure(Exception(error.toString()));
    }
    return result;
  }
}
