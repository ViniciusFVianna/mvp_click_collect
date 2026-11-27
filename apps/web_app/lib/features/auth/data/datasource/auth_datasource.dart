import '../../../../share/util/result.dart';

abstract class AuthDatasource {
  Future<Result<Map<String, dynamic>, Exception>> login(String email, String password);
}
