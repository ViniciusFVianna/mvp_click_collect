import '../../../../share/util/result.dart';

abstract class ProductsDatasource {
  Future<Result<List<Map<String, dynamic>>, Exception>> getProducts();
  Future<Result<Map<String, dynamic>, Exception>> getProductById(String id);
}
