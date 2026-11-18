import 'package:front_adm/presenter/splash/page/splash_page.dart';

import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';

class SplashRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<SplashPage>((_) => SplashPage());
  }
}
