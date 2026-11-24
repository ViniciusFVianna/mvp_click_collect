import 'package:front_adm/app/utils/command.dart';
import 'package:front_adm/features/stores/domain/model/store_model.dart';
import 'package:front_adm/features/stores/domain/usecases/get_stores_usecase.dart';

class HomeController {

  Command<List<StoreModel>> stores = Command<List<StoreModel>>(data: []);
  Command<String> searchQuery = Command<String>(data: '');
  Command<String> cep = Command<String>(data: '');
  Command<String> produtoId = Command<String>(data: '');

 GetStoresUseCase _getStores = GetIt.I<GetStoresUseCase>();

  void onInit() {
    fetchStores();
  }

  Future<void> fetchStores() async {
    stores.setLoading(true);
    final result = await _getStores(
      cep: cep.data.isEmpty ? null : cep.data,
    );
    result.when(
      success: (list) {
        stores.setData(list);
        stores.setLoading(false);
      },
      exception: (failure) => stores.setError(failure.message),
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
}
