import '../../../../share/util/result.dart';
import '../error/store_failure.dart';
import '../model/store_model.dart';
import '../repository/store_repository.dart';

typedef GetStoresResult = Result<List<StoreModel>, StoreFailure>;

abstract interface class GetStoresUsecase {
  Future<GetStoresResult> call({String? cep, String? produtoId});
}

class GetStoresUsecaseImpl implements GetStoresUsecase {
  final StoreRepository repository;

  const GetStoresUsecaseImpl({required this.repository});

  @override
  Future<GetStoresResult> call({String? cep, String? produtoId}) =>
      repository.getStores(cep: cep, produtoId: produtoId);
}
