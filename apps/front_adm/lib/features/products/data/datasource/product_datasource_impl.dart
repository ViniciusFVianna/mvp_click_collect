import 'package:front_adm/app/settings/app_settings.dart';
import 'package:front_adm/share/network/custom_client_http.dart';
import 'package:front_adm/share/network/http_response_parser.dart';
import 'package:front_adm/share/util/log_util.dart';
import 'package:front_adm/share/util/result.dart';

import 'product_datasource.dart';

class ProductDatasourceImpl implements ProductDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  ProductDatasourceImpl({
    required CustomClientHttp http,
    Uri? baseUri,
  })  : _http = http,
        _baseUri = baseUri ?? AppSettings.apiBaseUri;

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getProducts() async {
    try {
      return HttpResponseParser.asList(
        await _http.get(_baseUri.resolve('/api/products')),
      );
    } catch (error) {
      errorLog(error.toString(), tag: 'ProductDatasourceImpl.getProducts');
      return Failure(Exception(error.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> getProductById(
    String id,
  ) async {
    try {
      final uri = _baseUri.resolve('/api/products/${Uri.encodeComponent(id)}');
      return HttpResponseParser.asObject(await _http.get(uri));
    } catch (error) {
      errorLog(error.toString(), tag: 'ProductDatasourceImpl.getProductById');
      return Failure(Exception(error.toString()));
    }
  }
}
