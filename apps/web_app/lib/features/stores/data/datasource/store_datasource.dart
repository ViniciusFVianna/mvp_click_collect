import '../../../../share/util/result.dart';

abstract interface class StoreDatasource {
  Future<Result<List<Map<String, dynamic>>, Exception>> getStores({
    String? cep,
    String? produtoId,
  });
}
