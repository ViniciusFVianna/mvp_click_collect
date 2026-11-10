import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../../../data/models/product_model.dart';
import '../page/store_selector_page.dart';

class StoreSelectorRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<StoreSelectorPage>(
      (extra) => StoreSelectorPage(product: extra as ProductModel?),
    );
  }
}
