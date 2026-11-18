import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../page/home_page.dart';

class HomeRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<HomePage>((_) => const HomePage());
  }
}
