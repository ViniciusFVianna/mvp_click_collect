import '../models/store_model.dart';
import '../../app/utils/http_client.dart';

class StoreRepository {
  final ApiClient _apiClient;

  StoreRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<StoreModel>> getStores({String? cep, String? produtoId}) async {
    try {
      String path = '/api/stores';
      if (cep != null && produtoId != null) {
        path += '?cep=${Uri.encodeComponent(cep)}&produto_id=${Uri.encodeComponent(produtoId)}';
      }
      final response = await _apiClient.get(path);
      if (response is List) {
        return response.map((item) => StoreModel.fromJson(item)).toList();
      } else if (response is Map && response['stores'] is List) {
        return (response['stores'] as List)
            .map((item) => StoreModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (_) {
      return _mockStores;
    }
  }

  static final List<StoreModel> _mockStores = [
    StoreModel(
      id: 'store-01',
      name: 'Loja Paulista - Click & Collect Central',
      address: 'Av. Paulista, 1000 - Bela Vista, São Paulo - SP',
      zipCode: '01310-100',
      distance: '1.2 km',
      stock: 5,
      status: 'DISPONIVEL',
    ),
    StoreModel(
      id: 'store-02',
      name: 'Loja Faria Lima - Express Pick-up',
      address: 'Av. Brig. Faria Lima, 2232 - Pinheiros, São Paulo - SP',
      zipCode: '01451-000',
      distance: '3.4 km',
      stock: 2,
      status: 'DISPONIVEL',
    ),
    StoreModel(
      id: 'store-03',
      name: 'Loja Shopping Morumbi',
      address: 'Av. Roque Petroni Júnior, 1089 - Morumbi, São Paulo - SP',
      zipCode: '04707-900',
      distance: '6.8 km',
      stock: 0,
      status: 'INDISPONIVEL',
    ),
  ];
}
