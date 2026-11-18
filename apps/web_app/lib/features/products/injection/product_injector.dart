import 'package:get_it/get_it.dart';
import 'package:web_app/app/injection/injector_base.dart';
import 'package:web_app/app/settings/app_settings.dart';
import 'package:web_app/presenter/home/page/home_controller.dart';
import 'package:web_app/presenter/product_detail/page/product_detail_controller.dart';
import 'package:web_app/share/network/custom_client_http.dart';

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
    GetIt.I.registerFactory<HomeController>(
      () => HomeController(getProducts: GetIt.I<GetProductsUsecase>()),
    );
    GetIt.I.registerFactory<ProductDetailController>(ProductDetailController.new);
  }
}
