import '../../../../share/util/log_util.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/product_failure.dart';
import '../../domain/model/product_model.dart';
import '../../domain/repository/product_repository.dart';
import '../datasource/product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource _datasource;

  const ProductRepositoryImpl({required ProductDatasource dataSource})
      : _datasource = dataSource;

  @override
  Future<Result<List<ProductModel>, ProductFailure>> getProducts() async {
    final response = await _datasource.getProducts();
    return response.when(
      success: (records) {
        try {
          return Success<List<ProductModel>, ProductFailure>(
            records.map(ProductModel.fromMap).toList(),
          );
        } catch (error) {
          errorLog(error.toString(), tag: 'ProductRepositoryImpl.getProducts');
          return Failure<List<ProductModel>, ProductFailure>(
            ProductFailure(error.toString()),
          );
        }
      },
      exception: (exception) =>
          Failure(ProductFailure.fromException(exception)),
    );
  }

  @override
  Future<Result<ProductModel, ProductFailure>> getProductById(
    String id,
  ) async {
    final response = await _datasource.getProductById(id);
    return response.when(
      success: (record) {
        try {
          return Success<ProductModel, ProductFailure>(
            ProductModel.fromMap(record),
          );
        } catch (error) {
          errorLog(
            error.toString(),
            tag: 'ProductRepositoryImpl.getProductById',
          );
          return Failure<ProductModel, ProductFailure>(
            ProductFailure(error.toString()),
          );
        }
      },
      exception: (exception) =>
          Failure(ProductFailure.fromException(exception)),
    );
  }
}
