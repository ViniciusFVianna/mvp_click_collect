import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../page/splash_page.dart';

class SplashRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<SplashPage>((_) => const SplashPage());
  }
}
