import 'package:get_it/get_it.dart';
import 'package:front_adm/app/injection/injector_base.dart';
import 'package:front_adm/app/settings/app_settings.dart';
import 'package:front_adm/share/network/custom_client_http.dart';

import '../data/datasource/product_datasource.dart';
import '../data/datasource/product_datasource_impl.dart';
import '../data/repository/product_repository_impl.dart';
import '../domain/repository/product_repository.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';

class ProductInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<ProductDatasource>(
      () => ProductDatasourceImpl(
        http: GetIt.I<CustomClientHttp>(),
        baseUri: AppSettings.apiBaseUri,
      ),
    );
    GetIt.I.registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(dataSource: GetIt.I<ProductDatasource>()),
    );
    GetIt.I.registerFactory<GetProductsUsecase>(
      () => GetProductsUsecaseImpl(repository: GetIt.I<ProductRepository>()),
    );
    GetIt.I.registerFactory<GetProductByIdUsecase>(
      () => GetProductByIdUsecaseImpl(
        repository: GetIt.I<ProductRepository>(),
      ),
    );
  }
}
