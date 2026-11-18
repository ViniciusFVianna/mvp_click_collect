import 'package:front_adm/app/settings/app_settings.dart';
import 'package:front_adm/share/network/custom_client_http.dart';
import 'package:front_adm/share/network/http_response_parser.dart';
import 'package:front_adm/share/util/log_util.dart';
import 'package:front_adm/share/util/result.dart';

import 'store_datasource.dart';

class StoreDatasourceImpl implements StoreDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  StoreDatasourceImpl({
    required CustomClientHttp http,
    Uri? baseUri,
  })  : _http = http,
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
    } catch (error) {
      errorLog(error.toString(), tag: 'StoreDatasourceImpl.getStores');
      return Failure(Exception(error.toString()));
    }
  }
}
