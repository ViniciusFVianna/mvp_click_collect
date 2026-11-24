import '../../../../data/models/store_model.dart';
import '../../../../share/util/result.dart';
import '../error/stores_failure.dart';

abstract class StoresRepository {
  Future<Result<List<StoreModel>, StoresFailure>> getStores({String? cep, String? produtoId});
}
