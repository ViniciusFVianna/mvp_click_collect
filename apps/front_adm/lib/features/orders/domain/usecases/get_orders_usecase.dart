import '../../../../share/util/result.dart';
import '../error/order_failure.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

typedef GetOrdersResult = Result<List<OrderResponseModel>, OrderFailure>;

abstract interface class GetOrdersUsecase {
  Future<GetOrdersResult> call();
}

class GetOrdersUsecaseImpl implements GetOrdersUsecase {
  final OrderRepository repository;

  const GetOrdersUsecaseImpl({required this.repository});

  @override
  Future<GetOrdersResult> call() => repository.getOrders();
}
