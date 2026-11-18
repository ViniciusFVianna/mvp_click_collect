import 'package:get_it/get_it.dart';
import 'package:front_adm/app/injection/injector_base.dart';
import 'package:front_adm/app/settings/app_settings.dart';
import 'package:front_adm/presenter/home/page/home_controller.dart';
import 'package:front_adm/share/network/custom_client_http.dart';

import '../data/datasource/order_datasource.dart';
import '../data/datasource/order_datasource_impl.dart';
import '../data/repository/order_repository_impl.dart';
import '../domain/repository/order_repository.dart';
import '../domain/usecases/create_order_usecase.dart';
import '../domain/usecases/get_orders_usecase.dart';

class OrderInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<OrderDatasource>(
      () => OrderDatasourceImpl(
        http: GetIt.I<CustomClientHttp>(),
        baseUri: AppSettings.apiBaseUri,
      ),
    );
    GetIt.I.registerFactory<OrderRepository>(
      () => OrderRepositoryImpl(dataSource: GetIt.I<OrderDatasource>()),
    );
    GetIt.I.registerFactory<GetOrdersUsecase>(
      () => GetOrdersUsecaseImpl(repository: GetIt.I<OrderRepository>()),
    );
    GetIt.I.registerFactory<CreateOrderUsecase>(
      () => CreateOrderUsecaseImpl(repository: GetIt.I<OrderRepository>()),
    );
    GetIt.I.registerFactory<HomeController>(
      () => HomeController(getOrders: GetIt.I<GetOrdersUsecase>()),
    );
  }
}
