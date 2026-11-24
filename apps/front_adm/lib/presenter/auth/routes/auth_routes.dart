import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../page/auth_page.dart';

class AuthRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<AuthPage>((_) => const AuthPage());
  }
}
