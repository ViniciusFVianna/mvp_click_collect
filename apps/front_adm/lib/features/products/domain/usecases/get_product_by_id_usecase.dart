import '../../../../share/util/result.dart';
import '../error/product_failure.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

typedef GetProductByIdResult = Result<ProductModel, ProductFailure>;

abstract interface class GetProductByIdUsecase {
  Future<GetProductByIdResult> call(String id);
}

class GetProductByIdUsecaseImpl implements GetProductByIdUsecase {
  final ProductRepository repository;

  const GetProductByIdUsecaseImpl({required this.repository});

  @override
  Future<GetProductByIdResult> call(String id) =>
      repository.getProductById(id);
}
