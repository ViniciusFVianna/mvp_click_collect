import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../page/checkout_page.dart';

class CheckoutRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<CheckoutPage>(
      (extra) => CheckoutPage(data: extra as Map<String, dynamic>?),
    );
  }
}
