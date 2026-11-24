import 'package:web_app/app/utils/command.dart';
import 'package:web_app/features/products/domain/model/product_model.dart';

class ProductDetailController {
  Command<ProductModel?> product = Command<ProductModel?>(data: null);

  void onInit(ProductModel? p) {
    if (p != null) {
      product.setData(p);
    }
  }
}
