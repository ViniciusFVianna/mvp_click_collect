import 'package:web_app/app/utils/command.dart';
import 'package:web_app/data/models/product_model.dart';
import 'package:web_app/data/models/store_model.dart';
import 'package:web_app/data/repositories/store_repository.dart';

class StoreSelectorController {
  final StoreRepository _storeRepository = StoreRepository();

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
    try {
      final result = await _storeRepository.getStores(
        cep: cep.data.isNotEmpty ? cep.data : null,
        produtoId: product?.id,
      );
      stores.setData(result);
      if (result.isNotEmpty && selectedStore.data == null) {
        final available = result.firstWhere(
          (s) => s.stock > 0 && s.status != 'INDISPONIVEL',
          orElse: () => result.first,
        );
        if (available.stock > 0 && available.status != 'INDISPONIVEL') {
          selectedStore.setData(available);
        }
      }
    } catch (e) {
      stores.setError(e.toString());
    }
  }

  void setCep(String newCep) {
    cep.setData(newCep);
  }

  void selectStore(StoreModel store) {
    selectedStore.setData(store);
  }
}
