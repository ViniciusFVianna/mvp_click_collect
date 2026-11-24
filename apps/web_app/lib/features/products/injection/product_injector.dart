import 'package:web_app/app/injection/injector_base.dart';

import 'products_injector.dart';

class ProductInjector implements InjectorBase {
  @override
  void call() => ProductsInjector().call();
}
