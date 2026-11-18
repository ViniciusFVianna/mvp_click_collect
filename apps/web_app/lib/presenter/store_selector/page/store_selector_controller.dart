import 'package:web_app/app/utils/command.dart';
import 'package:web_app/features/products/domain/model/product_model.dart';
import 'package:web_app/features/stores/domain/model/store_model.dart';
import 'package:web_app/features/stores/domain/usecases/get_stores_usecase.dart';

class StoreSelectorController {
  final GetStoresUsecase _getStores;

  StoreSelectorController({required GetStoresUsecase getStores})
      : _getStores = getStores;

  Command<List<StoreModel>> stores = Command<List<StoreModel>>(data: []);
  Command<StoreModel?> selectedStore = Command<StoreModel?>(data: null);
  Command<String> cep = Command<String>(data: '01310-100');
  ProductModel? product;

  void onInit(ProductModel? p) {
    product = p;
    fetchStores();
  }

  Future<void> fetchStores() async {
    stores.setLoading(true);
    final result = await _getStores(
        cep: cep.data.isNotEmpty ? cep.data : null,
        produtoId: product?.id,
      );
    result.when(
      success: (items) {
        stores.setData(items);
        if (items.isNotEmpty && selectedStore.data == null) {
          final available = items.firstWhere(
            (store) => store.stock > 0 && store.status != 'INDISPONIVEL',
            orElse: () => items.first,
          );
          if (available.stock > 0 && available.status != 'INDISPONIVEL') {
            selectedStore.setData(available);
          }
        }
        stores.setLoading(false);
      },
      exception: (failure) => stores.setError(failure.message),
    );
  }

  void setCep(String newCep) {
    cep.setData(newCep);
  }

  void selectStore(StoreModel store) {
    selectedStore.setData(store);
  }
}
