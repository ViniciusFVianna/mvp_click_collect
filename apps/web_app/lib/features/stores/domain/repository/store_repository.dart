import '../../../../share/util/result.dart';
import '../error/store_failure.dart';
import '../model/store_model.dart';

abstract interface class StoreRepository {
  Future<Result<List<StoreModel>, StoreFailure>> getStores({
    String? cep,
    String? produtoId,
  });
}
