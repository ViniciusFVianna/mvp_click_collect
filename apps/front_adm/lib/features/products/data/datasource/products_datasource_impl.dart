import '../../../../app/settings/app_settings.dart';
import '../../../../share/network/custom_client_http.dart';
import '../../../../share/network/http_response_parser.dart';
import '../../../../share/util/result.dart';
import '../../../../share/util/log_util.dart';
import 'products_datasource.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  ProductsDatasourceImpl({required CustomClientHttp http, Uri? baseUri})
    : _http = http,
      _baseUri = baseUri ?? AppSettings.apiBaseUri;

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getProducts() async {
    try {
      return HttpResponseParser.asList(
        await _http.get(_baseUri.resolve('/api/products')),
      );
    } catch (e) {
      errorLog(e.toString(), tag: 'ProductsDatasourceImpl');
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> getProductById(
    String id,
  ) async {
    try {
      final uri = _baseUri.resolve('/api/products/${Uri.encodeComponent(id)}');
      return HttpResponseParser.asObject(await _http.get(uri));
    } catch (e) {
      errorLog(e.toString(), tag: 'ProductsDatasourceImpl');
      return Failure(Exception(e.toString()));
    }
  }
}
