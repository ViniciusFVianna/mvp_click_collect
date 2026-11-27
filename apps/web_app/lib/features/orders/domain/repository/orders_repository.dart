import '../../../../data/models/order_model.dart';
import '../../../../share/util/result.dart';
import '../error/orders_failure.dart';

abstract class OrdersRepository {
  Future<Result<List<OrderResponseModel>, OrdersFailure>> getOrders();
  Future<Result<OrderResponseModel, OrdersFailure>> createOrder(CreateOrderParams params);
}
