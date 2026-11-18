import 'package:web_app/app/settings/app_settings.dart';
import 'package:web_app/share/network/custom_client_http.dart';
import 'package:web_app/share/network/http_response_parser.dart';
import 'package:web_app/share/util/log_util.dart';
import 'package:web_app/share/util/result.dart';

import '../../domain/model/order_model.dart';
import 'order_datasource.dart';

class OrderDatasourceImpl implements OrderDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  OrderDatasourceImpl({
    required CustomClientHttp http,
    Uri? baseUri,
  })  : _http = http,
        _baseUri = baseUri ?? AppSettings.apiBaseUri;

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
