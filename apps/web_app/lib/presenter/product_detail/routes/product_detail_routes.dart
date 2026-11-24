import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../../../features/products/domain/model/product_model.dart';
import '../page/product_detail_page.dart';

class ProductDetailRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<ProductDetailPage>(
      (extra) => ProductDetailPage(product: extra as ProductModel?),
    );
  }
}
