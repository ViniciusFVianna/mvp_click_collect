import '../../../../data/models/product_model.dart';
import '../../../../share/util/result.dart';
import '../error/products_failure.dart';

abstract class ProductsRepository {
  Future<Result<List<ProductModel>, ProductsFailure>> getProducts();
  Future<Result<ProductModel, ProductsFailure>> getProductById(String id);
}
