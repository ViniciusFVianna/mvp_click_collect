import '../../../../share/util/result.dart';
import '../error/orders_failure.dart';
import '../model/order_model.dart';
import '../repository/orders_repository.dart';

abstract class GetOrdersUseCase {
  Future<Result<List<OrderResponseModel>, OrdersFailure>> call();
}

class GetOrdersUseCaseImpl implements GetOrdersUseCase {
  final OrdersRepository _repository;

  GetOrdersUseCaseImpl({required OrdersRepository repository})
    : _repository = repository;

  @override
  Future<Result<List<OrderResponseModel>, OrdersFailure>> call() {
    return _repository.getOrders();
  }
}
