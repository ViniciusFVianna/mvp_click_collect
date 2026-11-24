import 'package:get_it/get_it.dart';

import '../../../app/injection/injector_base.dart';
import '../page/splash_controller.dart';

class SplashInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<SplashController>(SplashController.new);
  }
}
