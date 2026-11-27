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
