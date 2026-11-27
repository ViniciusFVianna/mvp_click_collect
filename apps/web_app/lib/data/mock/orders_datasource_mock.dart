import '../../features/orders/data/datasource/orders_datasource.dart';
import '../../share/util/result.dart';

class OrdersDatasourceMock implements OrdersDatasource {
  final List<Map<String, dynamic>> _orders = [];

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(List.from(_orders));
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> createOrder(
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final newOrder = {
      'id': 'order_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'PENDENTE',
      'cliente_nome': body['cliente_nome'] ?? 'Cliente Mock',
      'cliente_cpf': body['cliente_cpf'] ?? '12345678901',
      'produto_id': body['produto_id'] ?? 'prod_01',
      'loja_id': body['loja_id'] ?? 'store_sapucaia_01',
      'modalidade_entrega': body['modalidade_entrega'] ?? 'CLICK_COLLECT',
      'terceiro_autorizado_nome': body['terceiro_autorizado_nome'],
      'terceiro_autorizado_cpf': body['terceiro_autorizado_cpf'],
      'created_at': DateTime.now().toIso8601String(),
    };

    _orders.add(newOrder);
    return Success(newOrder);
  }
}
