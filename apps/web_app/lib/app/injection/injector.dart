import 'package:get_it/get_it.dart';

import '../../features/orders/injection/order_injector.dart';
import '../../features/products/injection/product_injector.dart';
import '../../features/stores/injection/store_injector.dart';
import '../../presenter/splash/injection/splash_injector.dart';
import '../../share/share_injector.dart';
import 'injector_base.dart';

class Injector {
  Injector._();

  static Injector? _instance;
  static Injector get I => _instance ??= Injector._();

  final List<InjectorBase> injectors = [];
  bool _initialized = false;

  void inject() {
    injectors
      ..clear()
      ..add(ShareInjector())
      ..add(SplashInjector())
      ..add(ProductInjector())
      ..add(StoreInjector())
      ..add(OrderInjector());
  }

  void call() {
    if (_initialized) return;

    inject();
    for (final injector in injectors) {
      injector();
    }
    injectors.clear();
    _initialized = true;
  }

  static Future<void> dispose() async {
    await GetIt.I.reset();
    _instance = null;
  }
}
