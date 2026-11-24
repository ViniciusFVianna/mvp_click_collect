import 'package:front_adm/app/injection/injector_base.dart';

import 'orders_injector.dart';

class OrderInjector implements InjectorBase {
  @override
  void call() => OrdersInjector().call();
}
