import '../../../../share/util/result.dart';
import '../error/order_failure.dart';
import '../model/order_model.dart';

abstract interface class OrderRepository {
  Future<Result<List<OrderResponseModel>, OrderFailure>> getOrders();
  Future<Result<OrderResponseModel, OrderFailure>> createOrder(
    CreateOrderParams params,
  );
}
