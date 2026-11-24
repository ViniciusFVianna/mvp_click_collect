import 'package:get_it/get_it.dart';

import '../../../../app/injection/injector_base.dart';
import '../../../../share/network/custom_client_http.dart';
import '../data/datasource/orders_datasource.dart';
import '../data/datasource/orders_datasource_impl.dart';
import '../data/repository/orders_repository_impl.dart';
import '../domain/repository/orders_repository.dart';
import '../domain/usecases/create_order_usecase.dart';

class OrdersInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<OrdersDatasource>(
      () => OrdersDatasourceImpl(http: GetIt.I<CustomClientHttp>()),
    );
    GetIt.I.registerFactory<OrdersRepository>(
      () => OrdersRepositoryImpl(datasource: GetIt.I<OrdersDatasource>()),
    );
    GetIt.I.registerFactory<CreateOrderUseCase>(
      () => CreateOrderUseCaseImpl(repository: GetIt.I<OrdersRepository>()),
    );

  }
}
