import 'package:web_app/app/utils/command.dart';
import 'package:web_app/app/navigation/app_navigator.dart';
import 'package:web_app/features/orders/domain/model/order_model.dart';
import 'package:web_app/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:web_app/features/products/domain/model/product_model.dart';
import 'package:web_app/features/stores/domain/model/store_model.dart';
import 'package:web_app/presenter/order_success/page/order_success_page.dart';

class CheckoutController {
  final CreateOrderUsecase _createOrder;

  CheckoutController({required CreateOrderUsecase createOrder})
      : _createOrder = createOrder;

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
    if (product == null || store == null) {
      orderResult.setError('Produto ou loja não selecionado.');
      return;
    }

    orderResult.setLoading(true);
    final params = CreateOrderParams(
      clienteNome: clienteNome,
      clienteCpf: clienteCpf.replaceAll(RegExp(r'\D'), ''),
      produtoId: product!.id,
      lojaId: store!.id,
      modalidadeEntrega: 'CLICK_COLLECT',
      terceiroAutorizadoNome: isAuthorizedThirdParty.data ? terceiroNome : null,
      terceiroAutorizadoCpf: isAuthorizedThirdParty.data
          ? terceiroCpf?.replaceAll(RegExp(r'\D'), '')
          : null,
    );

    final result = await _createOrder(params);
    result.when(
      success: (order) {
        orderResult.setData(order);
        orderResult.setLoading(false);
        AppNavigator.pushReplacement(
          OrderSuccessPage,
          extra: {
            'order': order,
            'product': product,
            'store': store,
          },
        );
      },
      exception: (failure) => orderResult.setError(failure.message),
    );
  }
}
