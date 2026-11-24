import 'package:front_adm/app/injection/injector_base.dart';

import 'stores_injector.dart';

class StoreInjector implements InjectorBase {
  @override
  void call() => StoresInjector().call();
}
