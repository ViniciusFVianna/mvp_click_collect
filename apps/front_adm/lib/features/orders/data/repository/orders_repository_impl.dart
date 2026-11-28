import '../../../../share/util/log_util.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/orders_failure.dart';
import '../../domain/model/order_model.dart';
import '../../domain/repository/orders_repository.dart';
import '../datasource/orders_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersDatasource _datasource;

  OrdersRepositoryImpl({required OrdersDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Result<List<OrderResponseModel>, OrdersFailure>> getOrders() async {
    final response = await _datasource.getOrders();
    return response.when(
      success: (items) {
        try {
          return Success(items.map(OrderResponseModel.fromJson).toList());
        } catch (error) {
          errorLog(error.toString(), tag: 'OrdersRepositoryImpl.getOrders');
          return Failure(
            OrdersFailure(message: 'Resposta inválida de pedidos: $error'),
          );
        }
      },
      exception: (error) => Failure(OrdersFailure(message: error.toString())),
    );
  }

  @override
  Future<Result<OrderResponseModel, OrdersFailure>> createOrder(
    CreateOrderParams params,
  ) async {
    final response = await _datasource.createOrder(params.toJson());
    return response.when(
      success: (data) {
        try {
          return Success(
            OrderResponseModel.fromJson({...params.toJson(), ...data}),
          );
        } catch (error) {
          errorLog(error.toString(), tag: 'OrdersRepositoryImpl.createOrder');
          return Failure(
            OrdersFailure(message: 'Resposta inválida do pedido: $error'),
          );
        }
      },
      exception: (error) => Failure(OrdersFailure(message: error.toString())),
    );
  }
}
