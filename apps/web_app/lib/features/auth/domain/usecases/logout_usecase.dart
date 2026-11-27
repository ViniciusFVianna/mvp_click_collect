import '../../../../share/util/result.dart';
import '../error/auth_failure.dart';
import '../repository/auth_repository.dart';

abstract class LogoutUseCase {
  Future<Result<void, AuthFailure>> call();
}

class LogoutUseCaseImpl implements LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCaseImpl({required AuthRepository repository}) : _repository = repository;

  @override
  Future<Result<void, AuthFailure>> call() {
    return _repository.logout();
  }
}
