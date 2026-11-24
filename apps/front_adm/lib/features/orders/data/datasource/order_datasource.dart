import '../../../../share/util/result.dart';
import '../../domain/model/order_model.dart';

abstract interface class OrderDatasource {
  Future<Result<Map<String, dynamic>, Exception>> createOrder(
    CreateOrderParams params,
  );
}
