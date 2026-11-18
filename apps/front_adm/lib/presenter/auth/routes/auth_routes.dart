import 'package:front_adm/app/navigation/router_base.dart';
import 'package:front_adm/app/navigation/router_register.dart';
import 'package:front_adm/presenter/auth/page/auth_page.dart';

class AuthRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<AuthPage>((_) => const AuthPage());
  }
}
