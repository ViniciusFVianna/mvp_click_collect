import '../../../../share/util/result.dart';
import '../error/auth_failure.dart';
import '../repository/auth_repository.dart';

abstract class LoginUseCase {
  Future<Result<String, AuthFailure>> call(String email, String password);
}

class LoginUseCaseImpl implements LoginUseCase {
  final AuthRepository _repository;

  LoginUseCaseImpl({required AuthRepository repository}) : _repository = repository;

  @override
  Future<Result<String, AuthFailure>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
