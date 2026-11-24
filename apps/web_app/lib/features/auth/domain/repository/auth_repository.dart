import '../../../../share/util/result.dart';
import '../error/auth_failure.dart';

abstract class AuthRepository {
  Future<Result<String, AuthFailure>> login(String email, String password);
  Future<Result<void, AuthFailure>> logout();
  Future<String?> getToken();
}
