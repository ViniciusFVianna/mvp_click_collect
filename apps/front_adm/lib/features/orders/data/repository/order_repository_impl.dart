import '../../../../share/util/log_util.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/order_failure.dart';
import '../../domain/model/order_model.dart';
import '../../domain/repository/order_repository.dart';
import '../datasource/order_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDatasource _datasource;

  const OrderRepositoryImpl({required OrderDatasource dataSource})
      : _datasource = dataSource;

  @override
  Future<Result<List<OrderResponseModel>, OrderFailure>> getOrders() async {
    final response = await _datasource.getOrders();
    return response.when(
      success: (records) {
        try {
          return Success<List<OrderResponseModel>, OrderFailure>(
            records.map(OrderResponseModel.fromMap).toList(),
          );
        } catch (error) {
          errorLog(error.toString(), tag: 'OrderRepositoryImpl.getOrders');
          return Failure<List<OrderResponseModel>, OrderFailure>(
            OrderFailure(error.toString()),
          );
        }
      },
      exception: (exception) => Failure(OrderFailure.fromException(exception)),
    );
  }

  @override
  Future<Result<OrderResponseModel, OrderFailure>> createOrder(
    CreateOrderParams params,
  ) async {
    final response = await _datasource.createOrder(params);
    return response.when(
      success: (record) {
        try {
          return Success<OrderResponseModel, OrderFailure>(
            OrderResponseModel.fromMap(record),
          );
        } catch (error) {
          errorLog(error.toString(), tag: 'OrderRepositoryImpl.createOrder');
          return Failure<OrderResponseModel, OrderFailure>(
            OrderFailure(error.toString()),
          );
        }
      },
      exception: (exception) => Failure(OrderFailure.fromException(exception)),
    );
  }
}
