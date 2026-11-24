import '../model/order_model.dart';
import '../../../../share/util/result.dart';
import '../error/orders_failure.dart';
import '../repository/orders_repository.dart';

abstract class CreateOrderUseCase {
  Future<Result<OrderResponseModel, OrdersFailure>> call(
    CreateOrderParams params,
  );
}

class CreateOrderUseCaseImpl implements CreateOrderUseCase {
  final OrdersRepository _repository;

  CreateOrderUseCaseImpl({required OrdersRepository repository})
    : _repository = repository;

  @override
  Future<Result<OrderResponseModel, OrdersFailure>> call(
    CreateOrderParams params,
  ) {
    return _repository.createOrder(params);
  }
}
