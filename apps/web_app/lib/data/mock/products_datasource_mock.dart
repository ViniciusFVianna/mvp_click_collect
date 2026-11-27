import '../../features/products/data/datasource/products_datasource.dart';
import '../../share/util/result.dart';
import 'mock_data.dart';

class ProductsDatasourceMock implements ProductsDatasource {
  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = MockData.products.map((p) => p.toJson()).toList();
    return Success(list);
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final p = MockData.products.firstWhere(
      (prod) => prod.id == id,
      orElse: () => MockData.products.first,
    );
    return Success(p.toJson());
  }
}
