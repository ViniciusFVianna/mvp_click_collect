import 'package:front_adm/app/utils/command.dart';
import 'package:front_adm/features/orders/domain/model/order_model.dart';
import 'package:front_adm/features/orders/domain/usecases/get_orders_usecase.dart';

class HomeController {
  final GetOrdersUsecase _getOrders;

  HomeController({required GetOrdersUsecase getOrders})
      : _getOrders = getOrders;

  Command<List<OrderResponseModel>> orders = Command<List<OrderResponseModel>>(data: []);
  Command<String> selectedStatusFilter = Command<String>(data: 'TODOS');
  Command<String> searchQuery = Command<String>(data: '');

  void onInit() {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders.setLoading(true);
    final result = await _getOrders();
    result.when(
      success: (list) {
        orders.setData(list);
        orders.setLoading(false);
      },
      exception: (failure) => orders.setError(failure.message),
    );
  }

  void filterByStatus(String status) {
    selectedStatusFilter.setData(status);
  }

  void setSearchQuery(String query) {
    searchQuery.setData(query);
  }

  List<OrderResponseModel> get filteredOrders {
    return orders.data.where((order) {
      final matchesStatus = selectedStatusFilter.data == 'TODOS' ||
          order.status.toUpperCase() == selectedStatusFilter.data.toUpperCase();
      final matchesSearch = searchQuery.data.isEmpty ||
          order.id.toLowerCase().contains(searchQuery.data.toLowerCase()) ||
          order.clienteNome.toLowerCase().contains(searchQuery.data.toLowerCase()) ||
          order.clienteCpf.contains(searchQuery.data);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  List<String> get statusFilters => ['TODOS', 'PENDENTE', 'EM_SEPARACAO', 'PRONTO_PARA_RETIRADA', 'ENTREGUE'];
}
