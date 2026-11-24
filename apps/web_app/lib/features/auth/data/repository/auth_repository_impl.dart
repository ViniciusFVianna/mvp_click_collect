import '../../../../share/boundaries/secure_storage_facade.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/auth_failure.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;
  final SecureStorageFacade _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthRepositoryImpl({
    required AuthDatasource datasource,
    required SecureStorageFacade secureStorage,
  }) : _datasource = datasource,
       _secureStorage = secureStorage;

  @override
  Future<Result<String, AuthFailure>> login(
    String email,
    String password,
  ) async {
    final response = await _datasource.login(email, password);

    if (response.isSuccess) {
      final map = response.result;
      final token = map['idToken']?.toString();
      if (token == null || token.isEmpty) {
        return Failure(
          AuthFailure.serverError(
            'A resposta de autenticação não contém idToken.',
          ),
        );
      }

      try {
        await _secureStorage.write(_tokenKey, token);
        final refreshToken = map['refreshToken']?.toString();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await _secureStorage.write(_refreshTokenKey, refreshToken);
        }
      } catch (error) {
        return Failure(
          AuthFailure.serverError('Falha ao armazenar a sessão: $error'),
        );
      }
      return Success(token);
    } else {
      final msg = response.exception.toString().replaceAll('Exception: ', '');
      if (msg.contains('inválid') || msg.contains('401')) {
        return Failure(AuthFailure.invalidCredentials());
      }
      return Failure(AuthFailure.serverError(msg));
    }
  }

  @override
  Future<Result<void, AuthFailure>> logout() async {
    await _secureStorage.delete(_tokenKey);
    await _secureStorage.delete(_refreshTokenKey);
    return const Success(null);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(_tokenKey);
  }
}
