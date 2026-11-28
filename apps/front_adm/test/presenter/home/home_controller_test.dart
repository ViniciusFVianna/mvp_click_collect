import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/features/orders/domain/error/orders_failure.dart';
import 'package:front_adm/features/orders/domain/model/order_model.dart';
import 'package:front_adm/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:front_adm/features/stores/domain/error/stores_failure.dart';
import 'package:front_adm/features/stores/domain/model/store_model.dart';
import 'package:front_adm/features/stores/domain/usecases/get_stores_usecase.dart';
import 'package:front_adm/presenter/home/page/home_controller.dart';
import 'package:front_adm/share/util/result.dart';

void main() {
  group('HomeController Test', () {
    late HomeController controller;

    setUp(
      () => controller = HomeController(
        getStores: _FakeGetStoresUseCase(),
        getOrders: _FakeGetOrdersUseCase(),
      ),
    );

    test('deve inicializar e carregar a lista de lojas', () async {
      expect(controller.stores.data, isEmpty);

      await controller.fetchStores();

      expect(controller.stores.data.isNotEmpty, isTrue);
      expect(controller.stores.isLoading, isFalse);
    });

    test('deve buscar lojas por nome, id, endereço ou CEP', () async {
      await controller.fetchStores();

      controller.setSearchQuery('João');
      expect(controller.filteredStores, isEmpty);

      controller.setSearchQuery('Sapucaia');
      expect(controller.filteredStores.first.name, contains('Sapucaia'));
    });

    test(
      'deve buscar pedidos por ID, cliente, loja, produto ou status',
      () async {
        await controller.fetchOrders();

        expect(controller.filteredOrders, hasLength(2));

        controller.setOrderSearchQuery('maria');
        expect(controller.filteredOrders.single.id, 'order-001');

        controller.setOrderSearchQuery('prod-002');
        expect(controller.filteredOrders.single.id, 'order-002');

        controller.setOrderSearchQuery('pendente');
        expect(controller.filteredOrders.single.id, 'order-001');
      },
    );
  });
}

class _FakeGetStoresUseCase implements GetStoresUseCase {
  @override
  Future<Result<List<StoreModel>, StoresFailure>> call({
    String? cep,
    String? produtoId,
  }) async {
    return const Success([
      StoreModel(
        id: 'store_sapucaia_01',
        name: 'MegaLoja - Sapucaia Centro',
        address: 'Av. Sapucaia, 1020 - Centro - Sapucaia do Sul - RS',
        zipCode: '93260-000',
        stock: 3,
        status: 'DISPONIVEL',
      ),
    ]);
  }
}

class _FakeGetOrdersUseCase implements GetOrdersUseCase {
  @override
  Future<Result<List<OrderResponseModel>, OrdersFailure>> call() async {
    return const Success([
      OrderResponseModel(
        id: 'order-001',
        clienteNome: 'Maria da Silva',
        clienteCpf: '12345678901',
        produtoId: 'prod-001',
        lojaId: 'store-sapucaia',
        modalidadeEntrega: 'CLICK_COLLECT',
        status: 'PENDENTE',
      ),
      OrderResponseModel(
        id: 'order-002',
        clienteNome: 'Joao Souza',
        clienteCpf: '10987654321',
        produtoId: 'prod-002',
        lojaId: 'store-centro',
        modalidadeEntrega: 'CLICK_COLLECT',
        status: 'RETIRADO',
      ),
    ]);
  }
}
