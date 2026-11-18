import 'package:web_app/app/utils/command.dart';
import 'package:web_app/features/products/domain/model/product_model.dart';
import 'package:web_app/features/products/domain/usecases/get_products_usecase.dart';

class HomeController {
  final GetProductsUsecase _getProducts;

  HomeController({required GetProductsUsecase getProducts})
      : _getProducts = getProducts;

  Command<List<ProductModel>> products = Command<List<ProductModel>>(data: []);
  Command<String> selectedCategory = Command<String>(data: 'Todos');
  Command<String> searchQuery = Command<String>(data: '');

  void onInit() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    products.setLoading(true);
    final result = await _getProducts();
    result.when(
      success: (list) {
        products.setData(list);
        products.setLoading(false);
      },
      exception: (failure) => products.setError(failure.message),
    );
  }

  void selectCategory(String category) {
    selectedCategory.setData(category);
  }

  void setSearchQuery(String query) {
    searchQuery.setData(query);
  }

  List<ProductModel> get filteredProducts {
    return products.data.where((product) {
      final matchesCategory = selectedCategory.data == 'Todos' ||
          product.category.toLowerCase() == selectedCategory.data.toLowerCase();
      final matchesSearch = searchQuery.data.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.data.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.data.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<String> get categories {
    final set = {'Todos'};
    for (var p in products.data) {
      if (p.category.isNotEmpty) set.add(p.category);
    }
    return set.toList();
  }
}
