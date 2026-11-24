import '../../../../share/util/result.dart';
import '../error/product_failure.dart';
import '../model/product_model.dart';

abstract interface class ProductRepository {
  Future<Result<List<ProductModel>, ProductFailure>> getProducts();
  Future<Result<ProductModel, ProductFailure>> getProductById(String id);
}
