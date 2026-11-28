import 'package:front_adm/app/utils/command.dart';
import 'package:front_adm/features/orders/domain/model/order_model.dart';
import 'package:front_adm/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:front_adm/features/stores/domain/model/store_model.dart';
import 'package:front_adm/features/stores/domain/usecases/get_stores_usecase.dart';
import 'package:front_adm/share/util/log_util.dart';
import 'package:get_it/get_it.dart';

class HomeController {

  Command<List<StoreModel>> stores = Command<List<StoreModel>>(data: []);
  Command<String> searchQuery = Command<String>(data: '');
  Command<String> cep = Command<String>(data: '');
  Command<String> produtoId = Command<String>(data: '');
  Command<List<OrderResponseModel>> orders = Command<List<OrderResponseModel>>(
    data: [],
  );
  Command<String> orderSearchQuery = Command<String>(data: '');

  final GetStoresUseCase getStores = GetIt.I<GetStoresUseCase>();
  final GetOrdersUseCase getOrders = GetIt.I<GetOrdersUseCase>();

  void onInit() {
    fetchStores();
    fetchOrders();
  }

  Future<void> fetchStores() async {
    stores.setLoading(true);
    final result = await getStores(cep: cep.data.isEmpty ? null : cep.data);
    result.when(
      success: (list) {
        stores.setData(list);
        stores.setLoading(false);
      },
      exception: (failure) => stores.setError(failure.message),
    );
  }

  Future<void> fetchOrders() async {
    orders.setLoading(true);
    final result = await getOrders();
    result.when(
      success: (list) {
        orders.setData(list);
        orders.setLoading(false);
      },
      exception: (failure) {
        errorLog(failure.message, tag: 'home');
        orders.setError(failure.message);
      },
    );
  }

  void setSearchQuery(String query) {
    searchQuery.setData(query);
  }

  void setCep(String query) {
    cep.setData(query);
  }

  void setProdutoId(String query) {
    produtoId.setData(query);
  }

  void setOrderSearchQuery(String query) {
    orderSearchQuery.setData(query);
  }

  List<StoreModel> get filteredStores {
    return stores.data.where((store) {
      final matchesSearch =
          searchQuery.data.isEmpty ||
          store.id.toLowerCase().contains(searchQuery.data.toLowerCase()) ||
          store.name.toLowerCase().contains(searchQuery.data.toLowerCase()) ||
          store.address.toLowerCase().contains(
            searchQuery.data.toLowerCase(),
          ) ||
          store.zipCode.contains(searchQuery.data);
      return matchesSearch;
    }).toList();
  }

  List<OrderResponseModel> get filteredOrders {
    final query = orderSearchQuery.data.trim().toLowerCase();
    if (query.isEmpty) return orders.data;

    return orders.data.where((order) {
      return order.id.toLowerCase().contains(query) ||
          order.clienteNome.toLowerCase().contains(query) ||
          order.produtoId.toLowerCase().contains(query) ||
          order.lojaId.toLowerCase().contains(query) ||
          order.status.toLowerCase().contains(query);
    }).toList();
  }
}
