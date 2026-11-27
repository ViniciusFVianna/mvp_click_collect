import '../../../../share/util/log_util.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/products_failure.dart';
import '../../domain/repository/products_repository.dart';
import '../datasource/products_datasource.dart';
import '../../../../data/models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsDatasource _datasource;

  ProductsRepositoryImpl({required ProductsDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Result<List<ProductModel>, ProductsFailure>> getProducts() async {
    final response = await _datasource.getProducts();
    return response.when(
      success: (items) {
        try {
          return Success(items.map(ProductModel.fromJson).toList());
        } catch (error) {
          errorLog(error.toString(), tag: 'ProductsRepositoryImpl.getProducts');
          return Failure(
            ProductsFailure(message: 'Resposta inválida de produtos: $error'),
          );
        }
      },
      exception: (error) => Failure(ProductsFailure(message: error.toString())),
    );
  }

  @override
  Future<Result<ProductModel, ProductsFailure>> getProductById(
    String id,
  ) async {
    final response = await _datasource.getProductById(id);
    return response.when(
      success: (item) {
        try {
          return Success(ProductModel.fromJson(item));
        } catch (error) {
          errorLog(
            error.toString(),
            tag: 'ProductsRepositoryImpl.getProductById',
          );
          return Failure(
            ProductsFailure(message: 'Resposta inválida do produto: $error'),
          );
        }
      },
      exception: (error) => Failure(ProductsFailure(message: error.toString())),
    );
  }
}
