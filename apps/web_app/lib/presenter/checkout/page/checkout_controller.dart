import 'package:web_app/app/utils/command.dart';
import 'package:web_app/data/models/order_model.dart';
import 'package:web_app/data/models/product_model.dart';
import 'package:web_app/data/models/store_model.dart';
import 'package:web_app/data/repositories/order_repository.dart';
import 'package:web_app/app/navigation/app_navigator.dart';
import 'package:web_app/presenter/order_success/page/order_success_page.dart';

class CheckoutController {
  final OrderRepository _orderRepository = OrderRepository();

  Command<OrderResponseModel?> orderResult = Command<OrderResponseModel?>(data: null);
  Command<bool> isAuthorizedThirdParty = Command<bool>(data: false);

  ProductModel? product;
  StoreModel? store;

  void onInit(Map<String, dynamic>? data) {
    if (data != null) {
      product = data['product'] as ProductModel?;
      store = data['store'] as StoreModel?;
    }
  }

  void toggleThirdParty(bool value) {
    isAuthorizedThirdParty.setData(value);
  }

  Future<void> submitOrder({
    required String clienteNome,
    required String clienteCpf,
    String? terceiroNome,
    String? terceiroCpf,
  }) async {
    if (product == null || store == null) return;

    orderResult.setLoading(true);
    try {
      final params = CreateOrderParams(
        clienteNome: clienteNome,
        clienteCpf: clienteCpf.replaceAll(RegExp(r'\D'), ''),
        produtoId: product!.id,
        lojaId: store!.id,
        modalidadeEntrega: 'CLICK_COLLECT',
        terceiroAutorizadoNome: isAuthorizedThirdParty.data ? terceiroNome : null,
        terceiroAutorizadoCpf: isAuthorizedThirdParty.data ? terceiroCpf?.replaceAll(RegExp(r'\D'), '') : null,
      );

      final result = await _orderRepository.createOrder(params);
      orderResult.setData(result);

      AppNavigator.pushReplacement(
        OrderSuccessPage,
        extra: {
          'order': result,
          'product': product,
          'store': store,
        },
      );
    } catch (e) {
      orderResult.setError(e.toString());
    }
  }
}
