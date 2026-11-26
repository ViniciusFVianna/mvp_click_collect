import 'injector_base.dart';
import '../../share/share_injector.dart';
import '../../features/auth/injection/auth_injector.dart';
import '../../features/orders/injection/order_injector.dart';
import '../../features/products/injection/products_injector.dart';
import '../../features/stores/injection/stores_injector.dart';
import '../../presenter/splash/injection/splash_injector.dart';

class Injector {
  Injector._();
  static Injector get I => _instance ??= Injector._();
  static Injector? _instance;

  final List<InjectorBase> injectors = [];

  void inject() {
    injectors.add(ShareInjector());
    injectors.add(AuthInjector());
    injectors.add(OrderInjector());
    injectors.add(ProductsInjector());
    injectors.add(StoresInjector());
    injectors.add(SplashInjector());
  }

  void call() {
    injectors.clear();
    inject();
    for (var injector in injectors) {
      injector();
    }
    injectors.clear();
  }
}
