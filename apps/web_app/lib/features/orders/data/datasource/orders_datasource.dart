import '../../../../share/util/result.dart';

abstract class OrdersDatasource {
  Future<Result<List<Map<String, dynamic>>, Exception>> getOrders();
  Future<Result<Map<String, dynamic>, Exception>> createOrder(
    Map<String, dynamic> body,
  );
}
