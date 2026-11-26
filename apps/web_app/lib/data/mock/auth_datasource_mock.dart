import '../../features/auth/data/datasource/auth_datasource.dart';
import '../../share/util/result.dart';

class AuthDatasourceMock implements AuthDatasource {
  @override
  Future<Result<Map<String, dynamic>, Exception>> login(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (password.length < 6) {
      return Failure(Exception('Senha inválida (mínimo 6 caracteres).'));
    }

    return Success({
      'idToken': 'mock-firebase-id-token-${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'mock-firebase-refresh-token',
      'expiresIn': '3600',
      'user': {
        'email': email,
        'name': email.split('@').first,
      },
    });
  }
}
