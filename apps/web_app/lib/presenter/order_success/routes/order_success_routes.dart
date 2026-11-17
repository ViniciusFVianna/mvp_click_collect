import '../../../app/navigation/router_base.dart';
import '../../../app/navigation/router_register.dart';
import '../page/order_success_page.dart';

class OrderSuccessRoutes implements RouterBase {
  @override
  void call() {
    RouterRegister.I.add<OrderSuccessPage>(
      (extra) => OrderSuccessPage(data: extra as Map<String, dynamic>?),
    );
  }
}
