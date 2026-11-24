import '../model/product_model.dart';
import '../../../../share/util/result.dart';
import '../error/products_failure.dart';
import '../repository/products_repository.dart';

abstract class GetProductsUseCase {
  Future<Result<List<ProductModel>, ProductsFailure>> call();
}

class GetProductsUseCaseImpl implements GetProductsUseCase {
  final ProductsRepository _repository;

  GetProductsUseCaseImpl({required ProductsRepository repository}) : _repository = repository;

  @override
  Future<Result<List<ProductModel>, ProductsFailure>> call() {
    return _repository.getProducts();
  }
}
