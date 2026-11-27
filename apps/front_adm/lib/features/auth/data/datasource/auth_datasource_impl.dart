import '../../../../app/settings/app_settings.dart';
import '../../../../share/network/custom_client_http.dart';
import '../../../../share/network/http_response_parser.dart';
import '../../../../share/util/result.dart';
import '../../../../share/util/log_util.dart';
import 'auth_datasource.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final CustomClientHttp _http;
  final Uri _baseUri;

  AuthDatasourceImpl({required CustomClientHttp http, Uri? baseUri})
    : _http = http,
      _baseUri = baseUri ?? AppSettings.apiBaseUri;

  @override
  Future<Result<Map<String, dynamic>, Exception>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _http.post(
        _baseUri.resolve('/api/auth/login'),
        body: {'email': email, 'password': password},
      );
      return HttpResponseParser.asObject(response);
    } catch (e) {
      errorLog(e.toString(), tag: 'AuthDatasourceImpl');
      return Failure(Exception(e.toString()));
    }
  }
}
