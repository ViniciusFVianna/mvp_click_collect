import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router_base.dart';
import '../../presenter/splash/routes/splash_routes.dart';
import '../../presenter/home/routes/home_routes.dart';
import '../../presenter/product_detail/routes/product_detail_routes.dart';
import '../../presenter/store_selector/routes/store_selector_routes.dart';
import '../../presenter/checkout/routes/checkout_routes.dart';
import '../../presenter/order_success/routes/order_success_routes.dart';

typedef PageBuilder<T extends Widget, E> = T Function(E? extra);

class RouterRegister {
  RouterRegister._();
  static RouterRegister? _instance;
  static RouterRegister get I => _instance ??= RouterRegister._();

  final List<RouteBase> routes = [];
  final List<RouterBase> routers = [];
  final GlobalKey<NavigatorState> globalContext = GlobalKey<NavigatorState>();

  GoRouter get router => GoRouter(
        navigatorKey: globalContext,
        initialLocation: '/SplashPage',
        routes: routes,
      );

  void add<T>(PageBuilder pageBuilder) {
    routes.add(
      GoRoute(
        path: '/$T',
        builder: (_, state) => pageBuilder(state.extra),
      ),
    );
  }

  void register() {
    routers.add(SplashRoutes());
    routers.add(HomeRoutes());
    routers.add(ProductDetailRoutes());
    routers.add(StoreSelectorRoutes());
    routers.add(CheckoutRoutes());
    routers.add(OrderSuccessRoutes());
  }

  void call() {
    routes.clear();
    routers.clear();
    register();

    for (var router in routers) {
      router();
    }
    routers.clear();
  }
}
