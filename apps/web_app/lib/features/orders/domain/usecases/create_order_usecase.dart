import '../../../../share/util/result.dart';
import '../error/order_failure.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

typedef CreateOrderResult = Result<OrderResponseModel, OrderFailure>;

abstract interface class CreateOrderUsecase {
  Future<CreateOrderResult> call(CreateOrderParams params);
}

class CreateOrderUsecaseImpl implements CreateOrderUsecase {
  final OrderRepository repository;

  const CreateOrderUsecaseImpl({required this.repository});

  @override
  Future<CreateOrderResult> call(CreateOrderParams params) =>
      repository.createOrder(params);
}
