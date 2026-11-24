import '../../../../app/settings/app_settings.dart';
import '../../../../share/network/custom_client_http.dart';
import '../../../../share/network/http_response_parser.dart';
import '../../../../share/util/result.dart';
import '../../../../share/util/log_util.dart';
import 'stores_datasource.dart';

class StoresDatasourceImpl implements StoresDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  StoresDatasourceImpl({required CustomClientHttp http, Uri? baseUri})
    : _http = http,
      _baseUri = baseUri ?? AppSettings.apiBaseUri;

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getStores({
    String? cep,
    String? produtoId,
  }) async {
    try {
      final uri = _baseUri.resolve('/api/stores');
      final requestUri = cep != null && produtoId != null
          ? uri.replace(queryParameters: {'cep': cep, 'produto_id': produtoId})
          : uri;
      return HttpResponseParser.asList(await _http.get(requestUri));
    } catch (e) {
      errorLog(e.toString(), tag: 'StoresDatasourceImpl');
      return Failure(Exception(e.toString()));
    }
  }
}
