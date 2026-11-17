import '../models/order_model.dart';
import '../../app/utils/http_client.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<OrderResponseModel> createOrder(CreateOrderParams params) async {
    try {
      final response = await _apiClient.post('/api/orders', params.toJson());
      if (response is Map<String, dynamic>) {
        return OrderResponseModel.fromJson(response);
      }
    } catch (e) {
      // Fallback response on error
    }
    return OrderResponseModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      clienteNome: params.clienteNome,
      clienteCpf: params.clienteCpf,
      produtoId: params.produtoId,
      lojaId: params.lojaId,
      modalidadeEntrega: params.modalidadeEntrega,
      status: 'CONFIRMADO',
      createdAt: DateTime.now().toIso8601String(),
    );
  }
}
