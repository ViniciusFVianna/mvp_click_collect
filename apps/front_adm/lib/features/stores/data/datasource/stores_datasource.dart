import '../../../../share/util/result.dart';

abstract class StoresDatasource {
  Future<Result<List<Map<String, dynamic>>, Exception>> getStores({
    String? cep,
    String? produtoId,
  });
}
