import '../model/order_model.dart';
import '../../../../share/util/result.dart';
import '../error/orders_failure.dart';

abstract class OrdersRepository {
  Future<Result<OrderResponseModel, OrdersFailure>> createOrder(
    CreateOrderParams params,
  );
}
