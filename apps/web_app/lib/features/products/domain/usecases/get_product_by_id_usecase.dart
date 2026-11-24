import '../../../../data/models/product_model.dart';
import '../../../../share/util/result.dart';
import '../error/products_failure.dart';
import '../repository/products_repository.dart';

abstract class GetProductByIdUseCase {
  Future<Result<ProductModel, ProductsFailure>> call(String id);
}

class GetProductByIdUseCaseImpl implements GetProductByIdUseCase {
  final ProductsRepository _repository;

  GetProductByIdUseCaseImpl({required ProductsRepository repository}) : _repository = repository;

  @override
  Future<Result<ProductModel, ProductsFailure>> call(String id) {
    return _repository.getProductById(id);
  }
}
