import 'package:web_app/app/injection/injector_base.dart';

import 'stores_injector.dart';

class StoreInjector implements InjectorBase {
  @override
  void call() => StoresInjector().call();
}
