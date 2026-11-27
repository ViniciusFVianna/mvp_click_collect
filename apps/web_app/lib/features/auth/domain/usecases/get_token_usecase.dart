import '../repository/auth_repository.dart';

abstract class GetTokenUseCase {
  Future<String?> call();
}

class GetTokenUseCaseImpl implements GetTokenUseCase {
  final AuthRepository _repository;

  GetTokenUseCaseImpl({required AuthRepository repository}) : _repository = repository;

  @override
  Future<String?> call() {
    return _repository.getToken();
  }
}
