import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/features/orders/domain/error/order_failure.dart';
import 'package:front_adm/features/orders/domain/model/order_model.dart';
import 'package:front_adm/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:front_adm/presenter/home/page/home_controller.dart';
import 'package:front_adm/share/util/result.dart';

class _GetOrdersUsecase implements GetOrdersUsecase {
  Result<List<OrderResponseModel>, OrderFailure> response;

  _GetOrdersUsecase(this.response);

  @override
  Future<GetOrdersResult> call() async => response;
}

void main() {
  final sampleOrders = [
    const OrderResponseModel(
      id: 'ORD-9021',
      clienteNome: 'João Silva',
      clienteCpf: '11122233344',
      produtoId: 'prod-001',
      lojaId: 'store-01',
      modalidadeEntrega: 'CLICK_COLLECT',
      status: 'PENDENTE',
    ),
    const OrderResponseModel(
      id: 'ORD-9022',
      clienteNome: 'Ana Souza',
      clienteCpf: '55566677788',
      produtoId: 'prod-002',
      lojaId: 'store-02',
      modalidadeEntrega: 'CLICK_COLLECT',
      status: 'ENTREGUE',
    ),
  ];

  group('HomeController', () {
    test('carrega e filtra pedidos recebidos pelo usecase', () async {
      final controller = HomeController(
        getOrders: _GetOrdersUsecase(Success(sampleOrders)),
      );

      await controller.fetchOrders();
      expect(controller.orders.data, hasLength(2));
      expect(controller.orders.isLoading, isFalse);

      controller.filterByStatus('PENDENTE');
      expect(controller.filteredOrders.map((order) => order.id), ['ORD-9021']);

      controller.filterByStatus('TODOS');
      controller.setSearchQuery('João');
      expect(controller.filteredOrders.map((order) => order.id), ['ORD-9021']);
    });

    test('expõe erro quando o carregamento de pedidos falha', () async {
      final controller = HomeController(
        getOrders: _GetOrdersUsecase(
          Failure(const OrderFailure('GET /api/orders não disponível')),
        ),
      );

      await controller.fetchOrders();

      expect(controller.orders.error, contains('não disponível'));
      expect(controller.orders.isLoading, isFalse);
    });

    test('expõe a lista de status suportados para filtro', () {
      final controller = HomeController(
        getOrders: _GetOrdersUsecase(Success(sampleOrders)),
      );

      expect(
        controller.statusFilters,
        containsAll([
          'TODOS',
          'PENDENTE',
          'EM_SEPARACAO',
          'PRONTO_PARA_RETIRADA',
          'ENTREGUE',
        ]),
      );
    });
  });
}
