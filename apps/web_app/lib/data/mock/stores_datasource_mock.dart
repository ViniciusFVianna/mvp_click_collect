import '../../features/stores/data/datasource/stores_datasource.dart';
import '../../share/util/result.dart';
import 'mock_data.dart';

class StoresDatasourceMock implements StoresDatasource {
  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getStores({
    String? cep,
    String? produtoId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final result = MockData.stores.map((s) {
      final map = s.toJson();
      if (produtoId != null && MockData.stockByStore.containsKey(produtoId)) {
        final stockForStore = MockData.stockByStore[produtoId]?[s.id] ?? 0;
        map['quantity'] = stockForStore;
        map['stock'] = stockForStore;
      }
      return map;
    }).toList();

    return Success(result);
  }
}
