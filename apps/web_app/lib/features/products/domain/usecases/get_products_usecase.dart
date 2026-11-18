import '../../../../share/util/result.dart';
import '../error/product_failure.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

typedef GetProductsResult = Result<List<ProductModel>, ProductFailure>;

abstract interface class GetProductsUsecase {
  Future<GetProductsResult> call();
}

class GetProductsUsecaseImpl implements GetProductsUsecase {
  final ProductRepository repository;

  const GetProductsUsecaseImpl({required this.repository});

  @override
  Future<GetProductsResult> call() => repository.getProducts();
}
