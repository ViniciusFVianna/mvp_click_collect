import '../model/store_model.dart';
import '../../../../share/util/result.dart';
import '../error/stores_failure.dart';
import '../repository/stores_repository.dart';

abstract class GetStoresUseCase {
  Future<Result<List<StoreModel>, StoresFailure>> call({
    String? cep,
    String? produtoId,
  });
}

class GetStoresUseCaseImpl implements GetStoresUseCase {
  final StoresRepository _repository;

  GetStoresUseCaseImpl({required StoresRepository repository})
    : _repository = repository;

  @override
  Future<Result<List<StoreModel>, StoresFailure>> call({
    String? cep,
    String? produtoId,
  }) {
    return _repository.getStores(cep: cep, produtoId: produtoId);
  }
}
